# Common operations

1. To rebuild NixOS:

```shell
nh os switch
```

2. To rebuild `$HOME`:

```shell
nh home switch
```

3. To update all packages

```shell
nix flake update
```

4. To update a single input:

```shell
nix flake update <hyprland>
```

5. Using Flake:

```
sudo nixos-rebuild switch --flake .#nixos

home-manager --flake .#kit@nixos switch
```

6. To add an Obsidian community plugin:

```shell
./scripts/obsidian-plugin.sh <plugin-id> [tag]
```

Paste the printed attrset into the `plugins` list in
`home/programs/obsidian.nix`, then `nh home switch`. The plugin id is the name
of the plugin's directory under `.obsidian/plugins` (e.g. `dataview`); the
script resolves it to a GitHub repo through Obsidian's official registry.
Without a tag it takes the latest release. Re-running it with a newer tag is
also how you bump an already-declared plugin.

Two things to know: Obsidian's in-app *Update* button cannot update a declared
plugin, because its files are read-only symlinks into the Nix store -- bump it
with the script instead. And `community-plugins.json` is rewritten on every
switch, so toggling a declared plugin off in the UI does not stick; remove it
from the `plugins` list instead.
