# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
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

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    alejandra
    delta
    fzf
    gcc
    git
    gnumake
    helix
    jq
    just
    lazygit
    nix-index
    starship
    stow
    vicinae
    wezterm
    wget
    wl-clipboard
    xdotool
    yazi
    zoxide
    gh
  ];

  environment.sessionVariables = {
    PATH = ["/usr/local/bin"];
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [22];

  system.stateVersion = "26.05"; # Did you read the comment?
}
