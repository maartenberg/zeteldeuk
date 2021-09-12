{ config, pkgs, ... }:

{
  imports = [ ./nvim/coc.nix ./nvim/firenvim.nix ./nvim/python-syntax.nix ];

  config = {
    firenvim.enable = true;

    home.sessionVariables.EDITOR = "nvim";
    home.sessionVariables.VISUAL = "nvim";

    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        editorconfig-vim

        {
          plugin = nerdtree;
          config = ''
            noremap <silent> <leader>n :NERDTreeToggle<CR>
            noremap <silent> <leader>f :NERDTreeFind<CR>

            function! NERDTreeRefresh()
              if &filetype == "nerdtree"
                silent exe substitute(mapcheck("R"), "<CR>", "", "")
              endif
            endfunction

            autocmd BufEnter * call NERDTreeRefresh()
          '';
        }

        nerdcommenter

        targets-vim
        vim-indent-object

        {
          plugin = gruvbox-community;
          config = ''
            set termguicolors
            let g:gruvbox_contrast_dark = 'medium'
            let g:gruvbox_contrast_light = 'hard'
            let g:gruvbox_italic = 1
            color gruvbox
          '';
        }

        {
          plugin = vimtex;
          config = ''
            let g:tex_comment_nospell=1
            let g:vimtex_compiler_latexmk = {
            \   'options': [
            \     '-pdf',
            \     '-shell-escape',
            \     '-interaction=nonstopmode',
            \     '-synctex=0',
            \     'file-line-error',
            \     'verbose',
            \   ],
            \ }
          '';
        }
        vim-nix
        dhall-vim

        vim-pandoc
        {
          plugin = vim-pandoc-syntax;
          config = ''
            let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "bash=sh", "haskell"]
          '';
        }
        vim-toml
        # vim-jinja2-syntax
      ];
      extraConfig = ''
        " === Options ===
        set number relativenumber
        set mouse=a

        set tabstop=4 shiftwidth=4 et

        set backup backupdir=~/.local/share/nvim/backup,.

        " === Autocmds ===
        " Trailing space highlighting, taken from
        " <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>
        highlight ExtraWhitespace ctermbg=red guibg=red
        match ExtraWhitespace /\s\+$/
        autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
        autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
        autocmd BufWinLeave * call clearmatches()

        " Yaml: 2 spaces for indentation
        autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab

        " Python: default width for Black
        autocmd FileType python setlocal textwidth=88

        " Haskell: better style
        autocmd FileType haskell setlocal shiftwidth=2 tabstop=2 expandtab

        " === Keybinds ===
        " Quick format
        map Q gq

        " Map backspace to removing search highlight
        nnoremap <silent> <BS> :nohlsearch<CR>

        " Toggle paste mode
        set pastetoggle=<F2>

        " Toggle spellcheck
        map z! :set spell!<CR>

        " C-Backspace == ^W
        inoremap <C-BS> <C-W>
      '';

      extraPackages = [ pkgs.nixfmt ];
    };
  };
}
