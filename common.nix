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

  # Enable GPU drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Main Intel media driver for VA-API
      intel-vaapi-driver # Intel VA-API driver
      vaapiVdpau # VDPAU to VA-API bridge
      libvdpau-va-gl # VDPAU OpenGL interoperation
      intel-compute-runtime # Support for OpenCL capabilities
      vpl-gpu-rt # Media processing runtime for modern Intel GPUs
    ];
  };

  # Enable OpenSSH daemon
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };
  # services.fail2ban.enable = true;

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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLyA2WXQ81PQgfxRPZWQcbqKC2MjUuFdYCo9TYgVm4k dan"
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
      media = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "media"
        ];
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLyA2WXQ81PQgfxRPZWQcbqKC2MjUuFdYCo9TYgVm4k dan"
        ];
      };
    };
  };
  users.groups.media = { };

  # Enable Nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "ratatoskrserver@proton.me";
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    # Rust
    cargo # RUST Package manager
    rustc # RUST The rust compiler
    clippy # RUST Linter for rust
    gcc # C++ Code linker
    trunk # RUST To compile WASM apps

    # Development Tools
    nh # RUST Reimplements nix rebuild with visualised upgrade diff
    jq # C Command line JSON processor
    just # RUST Command runner
    bottom # RUST Terminal process monitor
    tokei # RUST Code statistics tool

    # Shell Enhancements
    jp2a # C Image to ASCII art converter
    eza # RUST Modern 'ls' replacement
    yazi # RUST Terminal file manager
    bat # RUST 'cat' clone with syntax highlighting
    fd # RUST Simple, fast 'find' alternative
  ];
  programs.fish.enable = true;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken.
  system.stateVersion = "24.11";
}
