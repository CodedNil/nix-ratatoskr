{
  pkgs,
  ...
}:

{
  home-manager.users.dan = {
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

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    font-awesome
    noto-fonts-emoji

    nixfmt-rfc-style
    just
    bottom
    fend
    tokei
    wl-clipboard

    cryfs
    sshfs

    yazi
    eza
    bat
    fd
  ];
}
