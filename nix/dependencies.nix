{ sources ? null }:

with builtins;

let
  sources_ = if (sources == null) then import ./sources.nix else sources;
  pkgs = import sources_.nixpkgs {};
  inherit (pkgs) stdenv lib;
  niv = (import sources_.niv { }).niv;

in rec {
  inherit pkgs;

  # Various tools for log files, deps management, running scripts and so on
  shellTools = 
  [
    niv
    pkgs.jq
    pkgs.nodejs-18_x
    pkgs.nodePackages.node-gyp
  ];

  frontendTools =
  [
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-test
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-optimize-level-2
    pkgs.elmPackages.elm-json
  ];

  # Needed for a development nix shell
  shellInputs = shellTools ++ frontendTools;

  shellPath = lib.makeBinPath shellInputs;
}
