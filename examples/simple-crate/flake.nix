{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nci.url = "github:yusdacra/nix-cargo-integration";
  inputs.nci.inputs.nixpkgs.follows = "nixpkgs";
  inputs.parts.url = "github:hercules-ci/flake-parts";
  inputs.parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  outputs = inputs @ {
    parts,
    nci,
    ...
  }:
  let 
    # Set crate name
    my-crate = "my-crate";
  in 
    parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [nci.flakeModule];
      perSystem = {self', ...}: {
        # configure crates
        nci.crates.${my-crate} = {
          # export crate (packages and devshell) in flake outputs
          export = true;
          # look at docs for more options
        };
        devShells.default = self'.devShells.${my-crate};
      };
    };
}
