{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg = {
      url = "github:pwndbg/pwndbg";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "google-chrome"
        ];
    };
  in {
    nixosConfigurations.stryver = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs // {inherit pkgs system;};
      modules = [
        ./sys/common.nix
        ./sys/stryver.nix
        nixos-hardware.nixosModules.framework-12th-gen-intel
      ];
    };
  };
}
