{
  pkgs,
  ...
}:

{
  home-manager.users.dan = {
    # Enable git
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Dan Lock";
      userEmail = "codenil@proton.me";
      lfs.enable = true;
      extraConfig.credential.helper = "libsecret";
      extraConfig.credential."https://github.com".username = "CodedNil";
      extraConfig.credential.credentialStore = "store";
    };

    # Fish and compatible programs
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          jp2a --colors --fill --chars="  " --color-depth=24 /home/dan/nix-ratatoskr/ratatoskr.png
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
