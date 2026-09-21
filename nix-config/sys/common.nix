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
    borgbackup
    tmux
  ];

  programs.fuse.enable = true;
  programs.fuse.userAllowOther = true;

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

  services.xserver.xkb = {
    layout = "us";
    variant = "caps:escape";
  };

  users.users."josh" = {
    isNormalUser = true;
    description = "josh";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  environment.sessionVariables = {
    PATH = ["/usr/local/bin"];
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.upower.enable = true;

  networking.firewall.allowedTCPPorts = [22];
}
