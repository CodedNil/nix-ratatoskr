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

  # Enable polkit agent
  security.soteria.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dan = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
  users.users.media = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # Home manager
  home-manager.users.dan = {
    # Enable git
    programs.git = {
      enable = true;
      userName = "Dan Lock";
      userEmail = "codenil@proton.me";
    };

    # The state version is required and should stay at the version you originally installed.
    home.stateVersion = "24.11";
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    rustup
    diskonaut
    baobab
  ];

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken.
  system.stateVersion = "24.11";
}
