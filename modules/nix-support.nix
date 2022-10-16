{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      cachix
      cntr
      niv
      nix-output-monitor
      nix-tree
    ];

    nix.package = pkgs.nix;
    nix.settings = {
      experimental-features = [ "flakes" "nix-command" ];
      max-jobs = "auto";
    };

    nixpkgs.config.allowUnfree = true;

    programs.zsh.shellAliases = {
      nrc = "nix shell -f default.nix -c ";
      nsh = "nix shell -f default.nix";
    };

    services.lorri.enable = true;
    programs.direnv.enable = true;

    programs.direnv.stdlib = ''
      export PS1="%F{8}[%F{3}direnv: $(basename -- "$DIRENV_DIR")%F{8}]%f ''${PS1}"
    '';
  };
}
