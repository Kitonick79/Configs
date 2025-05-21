{pkgs, ...}: {
  home.packages = with pkgs; [
    nil # Nix language server
  ];
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      ms-azuretools.vscode-docker
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      jnoortheen.nix-ide
      github.copilot
      #hashicorp.terraform
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-python.python
      redhat.vscode-yaml
      shd101wyy.markdown-preview-enhanced
      davidanson.vscode-markdownlint
      #dbaeumer.vscode-eslint
      #hashicorp.hcl
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "window.zoomLevel" = 1;
      #"editor.fontFamily" = "FiraCode Nerd Font Mono, Fira Code Symbol, monospace";
      #"terminal.integrated.fontFamily" = "FiraCode Nerd Font Mono, Fira Code Symbol, monospace";
      "editor.fontSize" = 12;
      "terminal.integrated.fontSize" = 12;
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = false;
        "markdown" = false;
        "scminput" = false;
      };
      #"editor.fontLigatures" = "'ss09', 'zero', 'cv27', 'ss10'"; # https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets

      "editor.codeActionsOnSave" = {
        "source.fixAll.markdownlint" = true;
      };
      "[markdown]" = {
        "editor.formatOnSave" = false;
        "editor.formatOnPaste" = true;
      };
      "nix.enableLanguageServer" = true; # Enable LSP.
      "nix.serverPath" = "nil"; # The path to the LSP server executable.
    };
  };
}
