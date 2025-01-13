{
  pkgs,
  ...
}:

{
  home-manager.users.dan = {
    # Enable git
    programs.git = {
      enable = true;
      userName = "Dan Lock";
      userEmail = "codenil@proton.me";
    };

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

    # The state version is required and should stay at the version you originally installed.
    home.stateVersion = "24.11";
  };
}
