{
  config,
  pkgs,
  pwndbg,
  system,
  xwayland-satellite,
  claude-code,
  ...
}: {
  environment.systemPackages = with pkgs; [
    bind
    python3
    xxd
    direnv
    go-2fa
    kdlfmt
    typst
    tinymist
    alejandra
    atool
    gimp
    delta
    eza
    curl
    zip
    fzf
    gcc
    gh
    git
    gnumake
    helix
    jq
    just
    lazygit
    nix-index
    p7zip
    ruff
    starship
    stow
    ty
    unzip
    wezterm
    wget
    wl-clipboard
    yazi
    yt-dlp
    zoxide
    sshpass
    file
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "josh";
  };
}
