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
