# Session: Fix Home-Manager Deprecation Warnings
**Date:** 2026-03-06

## Context
Following the previous session (Hyprland crash fix + upgrade to 0.54.1/aquamarine 0.10.0), these deprecation warnings remained from the nixpkgs 26.05 migration.

## Changes Made

### `home/default.nix`
```nix
# Before
programs.git = {
  enable = true;
  userName = "Kitonick79";
  userEmail = "myagkov.dv@gmail.com";
};

# After
programs.git = {
  enable = true;
  settings = {
    user.name = "Kitonick79";
    user.email = "myagkov.dv@gmail.com";
  };
};
```

### `home/programs/zsh.nix`
```nix
# Before
dotDir = ".config/zsh";

# After
dotDir = "${config.xdg.configHome}/zsh";
```

### `home/programs/vscode.nix`
Moved `extensions`, `userSettings`, and `enableUpdateCheck` under `profiles.default`:
```nix
# Before
programs.vscode = {
  enable = true;
  enableUpdateCheck = false;
  mutableExtensionsDir = false;
  extensions = [ ... ];
  userSettings = { ... };
};

# After
programs.vscode = {
  enable = true;
  mutableExtensionsDir = false;
  profiles.default = {
    enableUpdateCheck = false;
    extensions = [ ... ];
    userSettings = { ... };
  };
};
```

## Apply
```bash
home-manager switch --flake /home/kit/nixos#"kit@nixos"
```
