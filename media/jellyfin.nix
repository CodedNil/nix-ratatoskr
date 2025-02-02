{ config, pkgs, ... }:

let
  mediaUser = "media";
  mediaGroup = "media";
  homeDir = "/home/${mediaUser}";
  jellyfinConfigDir = "${homeDir}/.config/jellyfin";
  dataDir = "${jellyfinConfigDir}/data";
  configDir = "${jellyfinConfigDir}/config";
  cacheDir = "${jellyfinConfigDir}/cache";
  logDir = "${jellyfinConfigDir}/log";
  package = pkgs.jellyfin;
in
{
  systemd.services.jellyfin = {
    description = "Jellyfin Media Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = mediaUser;
      Group = mediaGroup;
      UMask = "0077";
      WorkingDirectory = jellyfinConfigDir;
      ExecStart = "${package}/bin/jellyfin --datadir='${dataDir}' --configdir='${configDir}' --cachedir='${cacheDir}' --logdir='${logDir}'";
      Restart = "on-failure";
      TimeoutSec = 15;
      SuccessExitStatus = [
        "0"
        "143"
      ];
      NoNewPrivileges = true;
      SystemCallArchitectures = "native";
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
    "d ${jellyfinConfigDir} 700 ${mediaUser} ${mediaGroup} -"
    "d ${dataDir} 700 ${mediaUser} ${mediaGroup} -"
    "d ${configDir} 700 ${mediaUser} ${mediaGroup} -"
    "d ${logDir} 700 ${mediaUser} ${mediaGroup} -"
    "d ${cacheDir} 700 ${mediaUser} ${mediaGroup} -"
  ];

  # networking.firewall.allowedTCPPorts = [
  #   8096
  #   8920
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   1900
  #   7359
  # ];
}
