{ config, lib, pkgs, ... }:

with lib;

let cfg = config.firenvim;
in {
  options = { firenvim.enable = mkEnableOption "firenvim"; };

  config = mkIf cfg.enable {
    programs.neovim.plugins = [{
      plugin = let
        version = "0.2.12";
        hash = "0qz13y0qlh9l0ksxccpaf4njb14i7jbdz5a1kpg089gi53av6wz0";

      in pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "firenvim";
        inherit version;

        src = pkgs.fetchFromGitHub {
          owner = "glacambre";
          repo = "firenvim";
          rev = "v${version}";
          sha256 = hash;
        };
      };

      config = ''
		" Bind C-Backspace to C-W
		inoremap <C-BS> <C-W>

        au BufEnter github.com_*.txt set filetype=markdown tw=120

		let g:firenvim_config = {
			\ 'globalSettings': {
				\ 'alt': 'all',
			\  },
			\ 'localSettings': {
				\ '.*': {
					\ 'cmdline': 'nvim',
					\ 'priority': 0,
					\ 'selector': 'textarea',
					\ 'takeover': 'never',
				\ },
			\ }
		\ }
      '';
    }];

    home.activation.firenvim = hm.dag.entryAfter ["writeBoundary" "onFilesChange"] ''
      $DRY_RUN_CMD nvim --headless "+call firenvim#install(0) | q"
      echo ""
    '';
  };
}
