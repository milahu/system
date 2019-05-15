{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  mine.deluged.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.splashImage = null;

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
  };

  mine.hardware.cpuCount = 2;
  mine.hardware.swap = true;

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG/16YJls1qIBfmDxhbcSGXpKeZZgYQEDPTFTX6Mbm+1MKZY49fsZXKOn2kKKVJ0rvbPM9VTOGt+WcIDSZ7TaQhRpUWLC/ENFXENSZRfOltzEGObk1D4yTfmLVh8YDsvQ19hN7epWLHazD7zyZ5B5bVC2Bjwdg5zwsbrLG9ZcD+EmQOT8IFmhF9AcOm1IxHqOPV597i0eYLGmqpY2yBPavUWowmd81/FIRS5hkBmriFkrQkVWGoYJywYL1RVs56HHr+Y+YP1KEhsNJIBQdcNAvamltFjubJRExHGGt12NxDEbBQQT11n3iqxm70IWQEtFVyJXGPXBdRG2opR0EXExr infinisil@nepnep"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDF0yVirzAjPsSm4oVlm9B8ykq+SomI2c2tsVNdUG8C3MWPVcYXYOSw92lZV/9866jNQ3vaApNr2UyiBaZbypM9O9VO2O97WjkEYzSgRCmLOFy33qgrydisp7jdriWRZtWKc1YTnvMeJ3wkDN5kElF/MASLu4+0+jKhCDciJx1d6fty6LNi5boK4m1YujUpAtVHZV8/5lhKAH7KFSS3HSjBRlU7KULgqjE27PHqVj8i4BYHuR2cQpS3LKQRkWdqq+c0Fi6e+TmS5yG1QOG7Y4BDOFuqEYS5EQCAGPh+cYm2u52gFt5hndl+6WMVxFwHSrpdQEYOJZlzxk2R3FwQp//n root@bowser"
  ];

  system.stateVersion = "19.03";
}