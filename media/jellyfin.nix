{ config, pkgs, ... }:

let
  package = pkgs.jellyfin;
  user = "media";
  group = "media";
  homeDir = "/home/${user}";
  jellyfinConfigDir = "${homeDir}/.config/jellyfin";
  dataDir = "${jellyfinConfigDir}/data";
  configDir = "${jellyfinConfigDir}/config";
  cacheDir = "${jellyfinConfigDir}/cache";
  logDir = "${jellyfinConfigDir}/log";
in
{
  environment.systemPackages = [ pkgs.jellyfin ];

  systemd.services.jellyfin = {
    description = "Jellyfin Media Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
    # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
    serviceConfig = {
      Type = "simple";
      User = user;
      Group = group;
      UMask = "0077";
      WorkingDirectory = jellyfinConfigDir;
      ExecStart = "${package}/bin/jellyfin --datadir='${dataDir}' --configdir='${configDir}' --cachedir='${cacheDir}' --logdir='${logDir}'";
      Restart = "on-failure";
      TimeoutSec = 15;
      SuccessExitStatus = [
        "0"
        "143"
      ];

      # Security options:
      NoNewPrivileges = true;
      SystemCallArchitectures = "native";
      # AF_NETLINK needed because Jellyfin monitors the network connection
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      RestrictNamespaces = !config.boot.isContainer;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      ProtectControlGroups = !config.boot.isContainer;
      ProtectHostname = true;
      ProtectKernelLogs = !config.boot.isContainer;
      ProtectKernelModules = !config.boot.isContainer;
      ProtectKernelTunables = !config.boot.isContainer;
      LockPersonality = true;
      PrivateTmp = !config.boot.isContainer;
      # needed for hardware acceleration
      PrivateDevices = false;
      PrivateUsers = true;
      RemoveIPC = true;

      SystemCallFilter = [
        "~@clock"
        "~@aio"
        "~@chown"
        "~@cpu-emulation"
        "~@debug"
        "~@keyring"
        "~@memlock"
        "~@module"
        "~@mount"
        "~@obsolete"
        "~@privileged"
        "~@raw-io"
        "~@reboot"
        "~@setuid"
        "~@swap"
      ];
      SystemCallErrorNumber = "EPERM";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${jellyfinConfigDir} 700 ${user} ${group} -"
    "d ${dataDir} 700 ${user} ${group} -"
    "d ${configDir} 700 ${user} ${group} -"
    "d ${logDir} 700 ${user} ${group} -"
    "d ${cacheDir} 700 ${user} ${group} -"
  ];

  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedTCPPorts = [
      8096
      8920
    ];
    allowedUDPPorts = [
      1900
      7359
    ];
  };
}
