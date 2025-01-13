{
  pkgs,
  ...
}:

{
  # Sonarr
  services.sonarr = {
    enable = true;
    dataDir = /home/media/.config/sonarr;
    user = "media";
    group = "media";
  }
  services.nginx.virtualHosts."sonarr.ratatoskr.uk" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8989";
      };
  };

  # Radarr
  services.radarr = {
    enable = true;
    dataDir = /home/media/.config/radarr;
    user = "media";
    group = "media";
  }
  services.nginx.virtualHosts."radarr.ratatoskr.uk" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:7878";
      };
  };

  home-manager.users.media = {
    # Fish and compatible programs
    programs.fish = {
      enable = true;
      interactiveShellInit = 'set fish_greeting';
      shellAliases = {
        cd = "z";
        cat = "bat";
        ls = "eza";
        find = "fd";
      };
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
