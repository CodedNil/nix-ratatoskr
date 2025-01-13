{
  pkgs,
  ...
}:

{
  services.sonarr = {
    enable = true;
    dataDir = /home/media/.config/sonarr
  }

  home-manager.users.media = {
    # Fish and compatible programs
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
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
