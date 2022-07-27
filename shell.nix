{ sources ? null }:

let
  dependencies = import ./nix/dependencies.nix { inherit sources; };
  inherit (dependencies) pkgs;
  inherit (pkgs) lib stdenv;
  caBundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

in pkgs.mkShell {
  name = "nashville-tenants-union";
  buildInputs = dependencies.shellInputs;
  nativeBuildInputs = [ pkgs.autoreconfHook ];
  shellHook = ''
    export PATH=${dependencies.shellPath}:$PATH
    # A pure nix shell breaks SSL for git and nix tools which is fixed by setting
    # the path to the certificate bundle.
    export SSL_CERT_FILE=${caBundle}
    export NIX_SSL_CERT_FILE=${caBundle}
  '';
}