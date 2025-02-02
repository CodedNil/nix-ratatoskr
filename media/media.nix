{
  pkgs,
  ...
}:

let
  configDir = "/home/media/.config";
in
{
  imports = [
    ./jellyfin.nix
  ];

  # environment.systemPackages = with pkgs; [
  #   qbittorrent-nox
  # ];

  # Sonarr
  # nixpkgs.config.permittedInsecurePackages = [
  #   "dotnet-sdk-6.0.428" # Temporary override to run sonarr until it's patched
  #   "aspnetcore-runtime-6.0.36"
  # ];
  # services.sonarr = {
  #   enable = true;
  #   dataDir = "${configDir}/sonarr";
  #   user = "media";
  #   group = "media";
  #   openFirewall = true;
  # };
  # services.nginx.virtualHosts."sonarr.ratatoskr.uk" = {
  #     addSSL = true;
  #     enableACME = true;
  #     locations."/" = {
  #       proxyPass = "http://localhost:8989";
  #     };
  # };

  # Radarr
  # services.radarr = {
  #   enable = true;
  #   dataDir = "${configDir}/radarr";
  #   user = "media";
  #   group = "media";
  #   openFirewall = true;
  # };
  # services.nginx.virtualHosts."radarr.ratatoskr.uk" = {
  #     addSSL = true;
  #     enableACME = true;
  #     locations."/" = {
  #       proxyPass = "http://localhost:7878";
  #     };
  # };

  # Jellyfin
  # services.jellyfin = {
  #   enable = true;
  #   dataDir = "${configDir}/jellyfin/data";
  #   configDir = "${configDir}/jellyfin/config";
  #   logDir = "${configDir}/jellyfin/logs";
  #   user = "media";
  #   group = "media";
  #   openFirewall = true;
  # };
  # services.nginx.virtualHosts."jellyfin.ratatoskr.uk" = {
  #     addSSL = true;
  #     enableACME = true;
  #     locations."/" = {
  #       proxyPass = "http://localhost:8096";
  #     };
  # };

  # Prowlarr
  #services.prowlarr = {
  #  enable = true;
  #  openFirewall = true;
  #};

  home-manager.users.media = {
    # qBittorrent
    # systemd.user.services.qbittorrent = {
    #   Unit = {
    #     Description = "qBittorrent Client";
    #     After = [ "network.target" ];
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent";
    #     Restart = "on-failure";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };
    # Port 8123

    # Fish and compatible programs
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          jp2a --colors --fill --chars="  " --color-depth=24 /home/media/ratatoskr.png
        end
      '';
      shellAliases = {
        cd = "z";
        cat = "bat";
        ls = "eza";
        find = "fd";
      };
    };

    programs.starship.enable = true; # RUST Shell prompt
    programs.zoxide.enable = true; # RUST Directory jumper
    programs.atuin.enable = true; # RUST Shell history manager

    # The state version is required and should stay at the version you originally installed.
    home.stateVersion = "24.11";
  };
}
