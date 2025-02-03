{ config, pkgs, ... }:

let
  package = pkgs.open-webui;
  host = "127.0.0.1";
  port = 8080;
  mainDir = "/home/dan/.config/open-webui";
in
{
  environment.systemPackages = [ package ];

  systemd.services.open-webui = {
    description = "User-friendly WebUI for LLMs";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    environment = {
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";
      STATIC_DIR = ".";
      DATA_DIR = ".";
      HF_HOME = ".";
      SENTENCE_TRANSFORMERS_HOME = ".";
      WEBUI_URL = "http://localhost:${toString port}";
    };

    serviceConfig = {
      ExecStart = "${package} serve --host ${host} --port ${toString port}";
      WorkingDirectory = dataDir;
      StateDirectory = "open-webui";
      RuntimeDirectory = "open-webui";
      RuntimeDirectoryMode = "0755";
      PrivateTmp = true;
      DynamicUser = true;
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = false; # onnxruntime/capi/onnxruntime_pybind11_state.so: cannot enable executable stack as shared object requires: Permission Denied
      PrivateUsers = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      ProcSubset = "all"; # Error in cpuinfo: failed to parse processor information from /proc/cpuinfo
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
