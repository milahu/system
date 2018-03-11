{ config, pkgs, lib, ... }:

with lib;

{

  options.mine.wlan.enable = mkEnableOption "wlan config";

  config = mkIf config.mine.wlan.enable {

    environment.systemPackages = with pkgs; [
      wpa_supplicant_gui
    ];

    networking.wireless = {
      enable = true;
      userControlled.enable = true;

      networks = {

        infinisil = {
          psk = "${config.private.passwords."wlan/iPhone"}";
          priority = 60;
        };

        eth-5 = {
          auth = ''
            key_mgmt=WPA-EAP
            eap=TTLS
            identity="msilvan"
            password="${config.private.passwords."wlan/eth"}"
            phase2="auth=MSCHAPV2"
          '';
          priority = 80;
        };

        Swisscom.priority = 10;

        "FRITZ!Box 7490".priority = 30;

      };
    };

    # Needed for Swisscom router web interface
    networking.extraHosts = ''
      192.168.1.1 swisscom.mobile
    '';
  };

}