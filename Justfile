set default-list := true

stow:
    stow --dotfiles home
    sudo stow --dotfiles usr -t /usr

nix:
    nixos-rebuild switch --flake ~/dotfiles/nix-config --sudo
    zsh -c 'autoload -Uz compinit; compinit'

paperwm:
    cd ./paperwm && make install

vicinae:
    gnome-extensions install --force ./vicinae@dagimg-dot.shell-extension-v1.6.2.zip

dconf:
    dconf load / < dconf.txt

zcompile:
    find -name '*.zsh' -exec zsh -c 'zcompile {}' ';'
