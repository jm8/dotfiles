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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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

  services.pipewire.wireplumber.extraConfig."80-passthrough" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            # Matches all HDMI and S/PDIF digital outputs
            "node.name" = "~alsa_output.*";
          }
        ];
        apply_properties = {
          # Force-enable bitstream capabilities
          "audio.allowed-rates" = "44100,48000";
          "api.alsa.passthrough" = true;
        };
      }
    ];
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
  ];

  environment.systemPackages = with pkgs; [
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
  ];

  programs.niri.enable = true;
  programs.dms-shell.enable = true;
}
