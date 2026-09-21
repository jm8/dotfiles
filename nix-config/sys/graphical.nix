{
  config,
  pkgs,
  pwndbg,
  system,
  xwayland-satellite,
  claude-code,
  ...
}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = [
    bind
    uv
    jdt-language-server
    (cutter.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    (rizin.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    claude-code.packages.${system}.default
    radare2
    (python3.withPackages (ps: with ps; [pwntools]))
    xxd
    asm-lsp
    wl-mirror
    direnv
    vscode
    go-2fa
    kdlfmt
    xwayland-satellite.packages.${system}.default
    alacritty
    typst
    tinymist
    alejandra
    atool
    gimp
    anki
    azahar
    delta
    clang-tools
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
    mpv
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
    xdotool
    yazi
    yt-dlp
    zoxide
    google-chrome
    sshpass
    gdb
    file
    ghidra
    pwndbg.packages.${system}.default
  ]

  programs.niri.enable = true;
  programs.dms-shell.enable = true;
}
