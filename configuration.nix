# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];
  # Sandboxing helps ensure reproducible builds
  nix.useSandbox = true;

  # I'm no Stallman, give me my hardware acceleration!
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = /dev/sdb4;

  networking.hostName = "colossus-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Window manager configuration
  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.layout = "us";

  # Set up ADB
  programs.adb.enable = true;

  # Add my user
  users.mutableUsers = false;
  users.extraUsers.velovix =
    { isNormalUser = true;
      home = "/home/velovix";
      shell = pkgs.zsh;
      description = "Tyler Compton";
      extraGroups = [ "wheel" "networkmanager" "adbusers" ];
      hashedPassword = "$6$dC3Ib3x3$mr7N5SlFasaV96yP8io.NeitI6ojMuFJYNBY8KaeE8sAIIRo20b6K.GRe2d5wh0vjwyjqFjoGThRNLOQG0USM0";
    };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Command line tools
    kitty zsh fzf direnv trash-cli silver-searcher git wget python3
    python36Packages.virtualenv python36Packages.pip neovim androidsdk go htop

    # Applications
    chromium pavucontrol hexchat gimp redshift unity3d android-studio slack
    blender viewnior neovim-qt vlc meld libreoffice audacity

    # Desktop
    arc-theme lxappearance paper-icon-theme compton awesome i3lock arandr
    lxmenu-data rofi i3lock-color
  ];

  fonts = {
    fonts = with pkgs; [
      hack-font noto-fonts noto-fonts-cjk noto-fonts-emoji
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Noto Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  security.chromiumSuidSandbox.enable = true; # Unity3d will not work without this
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
