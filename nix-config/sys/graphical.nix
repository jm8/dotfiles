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
    ioquake3
    brightnessctl
    alsa-utils
    calibre
    bind
    uv
    # jdt-language-server
    # (cutter.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    # (rizin.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    # radare2
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
    pavucontrol
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
    # pwndbg.packages.${system}.default
  ];

  services.pulseaudio.enable = false;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  programs.firefox.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
  ];

  programs.niri.enable = true;
  programs.dms-shell.enable = true;

  programs.ioquake3 = {
    enable = true;
    settings = {
      name = "onny";
      com_maxfps = 125;
      cg_frawFPS = true;
      cg_fov = 115;
      r_mode = "-1";
      r_customheight = 1080;
      r_customwidth = 1920;
      model = "sarge/default";
    };
    baseq3 = "/home/josh/Quake 3 Arena/baseq3";
  };
}
