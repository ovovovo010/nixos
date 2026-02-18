{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    code-cursor

    # ── Language servers & tools ──────────────────────────────────────
    zls                                         # Zig
    pyright                                     # Python
    ruff                                        # Python linter/formatter
    jdt-language-server                         # Java
    nil                                         # Nix
    nodePackages.typescript-language-server     # TypeScript/JavaScript
    nodePackages.vscode-langservers-extracted   # HTML/CSS/JSON
    rust-analyzer                               # Rust
    gopls                                       # Go
    clang-tools                                 # C/C++
    lua-language-server                         # Lua
    bash-language-server                        # Bash
  ];
}
