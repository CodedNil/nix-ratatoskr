default:
  nh os switch . --update

switch:
  sudo nixos-rebuild switch --flake '.#'

update:
  git add .
  nix flake update
u: update

clean:
  nix-env --delete-generations old
  sudo nix-collect-garbage -d
  sudo nix-store --optimise
c: clean