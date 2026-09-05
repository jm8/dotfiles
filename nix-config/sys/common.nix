{
  config,
  pkgs,
  # pwndbg,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xwayland-satellite
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
    python3
    ruff
    starship
    stow
    ty
    unzip
    vicinae
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.tailscale.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
  users.defaultUserShell = pkgs.zsh;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # services.xserver.enable = true;

  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;
  programs.dms-shell.enable = true;
  programs.dms-shell.systemd.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "caps:escape";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."josh" = {
    isNormalUser = true;
    description = "josh";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  programs.firefox.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glibc
      openssl
    ];
  };

  systemd.user.services.vicinae-server = {
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session-pre.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.vicinae}/bin/vicinae server";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  environment.sessionVariables = {
    PATH = ["/usr/local/bin"];
  };

  services.openssh.enable = true;
  services.upower.enable = true;

  networking.firewall.allowedTCPPorts = [22];

  system.stateVersion = "26.05"; # Did you read the comment?
}
