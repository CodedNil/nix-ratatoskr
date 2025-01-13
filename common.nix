{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ratatoskr"; # Define your hostname.
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  networking.networkmanager.enable = true; # Enable networking
  time.timeZone = "Europe/London"; # Set your time zone.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nixos flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Define users. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.fish;
    users = {
      dan = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLyA2WXQ81PQgfxRPZWQcbqKC2MjUuFdYCo9TYgVm4k dan@dan-arch"
        ];
      };
      max = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE2ESM/aoReVuiRZxKg+EAbG4vhPe/XmIlRuO5sJE4TZ root@DESKTOP-95MHB2J"
        ];
      };
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE2ESM/aoReVuiRZxKg+EAbG4vhPe/XmIlRuO5sJE4TZ root@DESKTOP-95MHB2J"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLyA2WXQ81PQgfxRPZWQcbqKC2MjUuFdYCo9TYgVm4k dan@dan-nixos"
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    font-awesome
    noto-fonts-emoji

    nixfmt-rfc-style
    rustup
    just
    bottom
    tokei

    diskonaut
    yazi
    eza
    bat
    fd
  ];
  programs.fish.enable = true;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken.
  system.stateVersion = "24.11";
}
