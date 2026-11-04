{
  config,
  lib,
  pkgs,
  ...
}: let
  # The one vault registered in ~/.config/obsidian/obsidian.json.
  vaultRel = "Obsidian_Vaults";
  vaultDir = "${config.home.homeDirectory}/${vaultRel}";

  # Declared community plugins. To add one, or to bump an existing one, run
  #   ./scripts/obsidian-plugin.sh <plugin-id> [tag]
  # and paste its output here. The plugin id is the directory name Obsidian
  # gives the plugin under .obsidian/plugins (e.g. "dataview").
  plugins = [
    {
      id = "weave-epub-reader";
      repo = "zhuzhige123/obsidian-weave-reader";
      version = "0.6.8";
      files = {
        "main.js" = "sha256-d7mWxlF0sdU2VDX3SMz/O8zGS0f7kz1xz/eOgUhhKdU=";
        "manifest.json" = "sha256-1TGC+ed2e1Nzf41CHY1/YH0kt01iJjQRGcQkSHKzA80=";
        "styles.css" = "sha256-tlxc0gQ2QwEr9BKbwLAGmc1akPmIWssvgi6LcHyvPxk=";
      };
    }
  ];

  # One store path per release asset, linked in as an individual file. Linking
  # the leaves rather than the plugin directory leaves the directory itself
  # writable, which is what Obsidian needs for a plugin's mutable state --
  # data.json and whatever cache/ or state/ the plugin keeps beside its code.
  pluginFiles = plugin:
    lib.mapAttrs' (name: hash:
      lib.nameValuePair "${vaultRel}/.obsidian/plugins/${plugin.id}/${name}" {
        source = pkgs.fetchurl {
          url = "https://github.com/${plugin.repo}/releases/download/${plugin.version}/${name}";
          inherit hash;
        };
      })
    plugin.files;

  enabledPlugins =
    pkgs.writeText "community-plugins.json"
    (builtins.toJSON (map (plugin: plugin.id) plugins));
in {
  home.packages = [pkgs.obsidian];

  home.file = lib.mkMerge (map pluginFiles plugins);

  # Obsidian loads only the ids listed in community-plugins.json, and rewrites
  # that file whenever a plugin is toggled in the UI -- so unlike the plugin
  # code it has to stay a real writable file, not a read-only store symlink.
  # Each switch resets it to the declared set.
  home.activation.obsidianCommunityPlugins = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p ${lib.escapeShellArg "${vaultDir}/.obsidian"}
    run install -m644 ${enabledPlugins} \
      ${lib.escapeShellArg "${vaultDir}/.obsidian/community-plugins.json"}
  '';
}
