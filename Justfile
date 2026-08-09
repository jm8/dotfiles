set default-list := true

stow:
    stow --dotfiles home
    sudo stow --dotfiles usr -t /usr
nix:
    nixos-rebuild switch --flake ~/dotfiles/nix-config --sudo
    zsh -c 'autoload -Uz compinit; compinit'
