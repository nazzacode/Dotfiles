{ config, pkgs, callPackage, ... }: {
  # ...

  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;  # Use the systemd-boot EFI boot loader
  boot.loader.efi.canTouchEfiVariables = true;  # no idea

  # Enable Nvidia
  # services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.libinput.enable = true; # Enable touchpad

  system.copySystemConfiguration = true;  # backup in /run/current-system

  i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  time.timeZone = "Europe/London";  # Set your time zone.

  system.autoUpgrade.enable = true;

  networking.hostName = "nixos";  # Define hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts.fontconfig.dpi=180;  # font scaling

  nixpkgs.config.allowUnfree = true;  # Allow unfree Packages

  services.xserver.xkbOptions = "caps:swapescape";
  console.useXkbConfig = true;  # apply to external consoles (e.g tty)

  environment.systemPackages = with pkgs; [
    # General
    neovim                       # flamewars babay
    firefox vivaldi google-chrome      # browsers (all shite)
    calibre                            # book ting
    # Shell
    zsh                                # shell
    # TUI
    taskell                            # vim kanban <3
    tmux                               # terminal multiplexer
    # Command Line
    direnv                             # virtual envs
    coreutils bat ripgrep fd           # cli utils
    git                                # version control
    # Background
    wget                               # fetch web protocols (e.g HTTP)
    gcc                                # C++ Compiler
    # Not rice
    neofetch htop
    # Rice
    cmatrix
    # Nix
    nox                                # better package search
    # Kde
    yakuake                            # REPLACE dropdown terminal
    # TODO Cloud/File Storage
  ];

  # Emacs
  services.emacs.package = pkgs.emacsGcc;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
       https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  services.emacs.enable = true;  # daemon/server mode

  programs.zsh = {
    enable = true;
  # TODO replace with zsh way!
    shellInit = ''
      export PATH="$PATH":"$HOME/.emacs.d/bin"
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nathan = {
    description = "Nathan Sharp";
    isNormalUser = true;
    home = "/home/nathan";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "network manager" "network"
                                  "video" "vboxusers" "audio" ];
  };

  home-manager.users.nathan = { pkgs, ... }: {

    # home.packages = [ pkgs.atool pkgs.httpie ];

    programs.zsh = {
      enable = true;
      autocd = true;
    };
    # TODO config!

    programs.git = {
      enable = true;
      userName  = "nazzacode";
      userEmail = "nasharp@outlook.com";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

  # Enable Xmonad Tiling Window Manager
  #services.xserver = {
  #  windowManager.xmonad = {
  #    enable = true;
  #    enableContribAndExtras = true;
  #   extraPackages = haskellPackages: [
  #      haskellPackages.xmonad-contrib
  #      haskellPackages.xmonad-extras
  #      haskellPackages.xmonad
  #    ];
  #  };
    # commented for kde run
    # displayManager.defaultSession = "none+xmonad";
    # desktopManager.xterm.enable = false;

    # displayManager.sessionCommands = with pkgs; lib.mkAfter
    #   ''
    #   xmodmap /path/to/.Xmodmap
    #   '';
  # };
