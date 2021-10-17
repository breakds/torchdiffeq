{
  description = "Nueral ODE pytorch implementation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/21.05";

    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";

    ml-pkgs.url = "github:nixvital/ml-pkgs";
    ml-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    ml-pkgs.inputs.utils.follows = "utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            # Use this overlay to provide customized python packages
            # for development environment.
            (import ./nix/overlay.nix {
              inherit (inputs.ml-pkgs.packages."${system}")
                pytorchWithCuda11
                torchvisionWithCuda11;
            })
          ];
        };
      in {
        # Some of the python tools are developed and packaged with poetry.
        devShell = pkgs.callPackage ./nix/pkgs/dev-shell {};
      });
}
