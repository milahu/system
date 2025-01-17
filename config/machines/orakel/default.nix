{ lib, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  secrets.files.syncplay.file = ../../../external/private/secrets/syncplay;
  secrets.files.syncplay.user = "syncplay";

  services.syncplay = {
    enable = true;
    certDir =
      let base = config.security.acme.certs."torrent.infinisil.com".directory;
      in pkgs.runCommandNoCC "syncplay-certs" {} ''
        mkdir $out
        ln -s ${base}/cert.pem $out/cert.pem
        ln -s ${base}/key.pem $out/privkey.pem
        ln -s ${base}/chain.pem $out/chain.pem
      '';
    salt = "WQCMMEFEPA";
    passwordFile = config.secrets.files.syncplay.file;
    user = "syncplay";
    group = config.security.acme.certs."torrent.infinisil.com".group;
  };

  users.users.syncplay = {
    isSystemUser = true;
  };

  mine.enableUser = true;

  mine.transmission.enable = true;

  mine.profiles.server.enable = true;

  mine.music = {
    server = {
      enable = true;
      local = false;
      musicDir = "/home/infinisil/music";
      user = "infinisil";
      group = "users";
      password = config.private.passwords.mpd;
    };
  };

  mine.youtubeDl = {
    enable = true;
    user = "infinisil";
    mpdHost = "${config.private.passwords.mpd}@localhost";
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.splashImage = null;
  boot.loader.grub.configurationLimit = 5;

  boot.kernelParams = [ "net.ifnames=0" ];

  boot.zfs.devNodes = "/dev";
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "orakel";
    hostId = "cb8bdc78";
    defaultGateway = "51.15.187.1";
    interfaces.eth0.ipv4.addresses = [{
      address = "51.15.187.150";
      prefixLength = 20;
    }];
    firewall.allowedTCPPorts = [ config.services.syncplay.port ];
  };

  services.iperf3.enable = true;
  services.iperf3.openFirewall = true;

  services.znapzend = {
    enable = true;
    features.compressed = true;
    autoCreation = true;
    pure = true;
    zetup = {
      "tank/root/torrent/current" = {
        plan = "2h=>1h";
        destinations.vario = {
          host = "10.99.2.2";
          dataset = "tank2/root/torrent";
          plan = "2h=>1h";
        };
      };
      "tank/root/music" = {
        plan = "1d=>1h";
        #destinations.ninur = {
        #  host = config.networking.connections.ninur;
        #  dataset = "tank/music";
        #  plan = "1h=>5min,1d=>1h";
        #};
        destinations.vario = {
          host = "10.99.2.2";
          dataset = "tank2/root/music";
          plan = "1d=>1h";
        };
      };
    };
  };

  mine.hardware.cpuCount = 2;
  mine.hardware.swap = true;

  services.openssh.enable = true;

  system.stateVersion = "19.03";
}
