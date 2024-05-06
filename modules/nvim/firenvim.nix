{ config, lib, pkgs, firenvim, ... }:

with lib;

let cfg = config.firenvim;
in {
  options = { firenvim.enable = mkEnableOption "firenvim"; };

  config = mkIf cfg.enable {
    programs.neovim.plugins = [{
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "firenvim";
        inherit version;

        src = firenvim;
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
