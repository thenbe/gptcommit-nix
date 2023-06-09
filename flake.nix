{
  description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-compat,
  }: let
    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forAllSystems ({pkgs}: {
      default = pkgs.rustPlatform.buildRustPackage rec {
        pname = "gptcommit";
        version = "0.4.0";
        src = pkgs.fetchFromGitHub {
          owner = "zurawiki";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-efxN2NqXziG/XRd9NnrSROdKqh5VEckXTXlVKelOiD8=";
        };
        meta = {
          description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3.";
          homepage = "https://github.com/zurawiki/gptcommit";
        };
        cargoSha256 = "sha256-wvcHD2lgipy3zP1h1lV4txIO3MPUFxbTYFUT2zb7EdI=";
        nativeBuildInputs = [pkgs.pkg-config];
        buildInputs = [pkgs.openssl];
        doCheck = true;
        checkPhase = ''
          OPENAI_API_KEY='sk-...' cargo test
        '';
      };
    });
  };
}
