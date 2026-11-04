# nixconfig

nix-darwin + standalone home-manager flake for `neptune` (aarch64-darwin).

## Commands

These zsh functions (defined in `home/programs/shell/zsh.nix`) use the repo
you're standing in, falling back to `~nixconfig`:

| Command       | Does                                   |
| ------------- | -------------------------------------- |
| `nixrebuild`  | `sudo darwin-rebuild switch` (system)  |
| `switchhome`  | `home-manager switch` (user)           |
| `nixupdate`   | `nix flake update`                     |

`nix fmt` formats with alejandra.

## Layout

```
flake.nix                 inputs, `host` identity, outputs
overlays/default.nix      package pins/overrides (pkgs.opencode, pkgs.dart)
hosts/<name>/
  configuration.nix       nix-darwin entry: imports system/, enables `localSystem.*`
  home.nix                home-manager entry: imports home/, enables `localHome.*`
hosts/state-version.nix   home-manager stateVersion
system/                   nix-darwin modules (options under `localSystem.*`)
  default.nix             imports every system module
home/                     home-manager modules (options under `localHome.*`)
  default.nix             imports every home module
  platform/               OS-specific glue (e.g. macOS app linking)
  programs/<category>/    one file per tool or tool group
```

## Conventions

- **Every leaf module is opt-in.** It declares
  `options.localHome.programs.<category>.<name>.enable` (or `localSystem.*`)
  and wraps its config in `lib.mkIf cfg.enable`. Every module is always
  imported; the host files (`hosts/<name>/configuration.nix` for system,
  `hosts/<name>/home.nix` for home) are the only place that sets
  `enable = true`. Modules never enable themselves.
- **Module path = option path.** `home/programs/cli/ripgrep.nix` defines
  `localHome.programs.cli.ripgrep`. Move a file → rename its option and update
  the host files. Groups of interchangeable items get a folder, one file per
  item: `development/languages/dart.nix` →
  `localHome.programs.development.languages.dart.enable`, same for
  `development/databases/<db>.nix`.
- **Dependencies between modules go through options**, not duplicate package
  lists. E.g. `editors/nixvim.nix` sets `localHome.programs.cli.ripgrep.enable`.
- **Pins and overrides live in `overlays/`**, never inline in a module. Modules
  use plain `pkgs.<name>`. Each pin carries a comment saying when to drop it.
- **Machine identity lives in one place:** the `host` attrset in `flake.nix`
  (`name`, `user`, `system`). It's passed to host files as the `host` module
  argument; don't hardcode the username, hostname or platform elsewhere.
- **No empty category folders.** Create `home/programs/<category>/` when its
  first module exists, and add it to `home/programs/default.nix`.

## Adding things

- **A tool:** create `home/programs/<category>/<tool>.nix` following the
  pattern above, import it from that category's `default.nix`, enable it in
  `hosts/<name>/home.nix` (or a `system/` module → `configuration.nix`).
- **A pinned/patched package:** add it to `overlays/default.nix` under its
  normal name.
- **A second machine:** turn `host` in `flake.nix` into a list/attrset of
  hosts and add `hosts/<name>/` with its own enables. If two hosts end up
  sharing a long enable list, factor it into a shared module then.

New files must be `git add`ed before nix can see them (flakes only read
tracked files).
