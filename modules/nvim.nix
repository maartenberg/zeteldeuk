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

        {
          plugin = vim-better-whitespace;
          config = ''
            let g:strip_whitespace_on_save=1
            let g:strip_whitelines_at_eof=1
            let g:show_spaces_that_precede_tabs=1

            nnoremap ]w :NextTrailingWhitespace<CR>
            nnoremap [w :PrevTrailingWhitespace<CR>
          '';
        }

        ansible-vim

        {
          plugin = telescope-nvim;
          config = ''
            nnoremap <leader>ff <cmd>Telescope find_files<cr>
            nnoremap <leader>fg <cmd>Telescope live_grep<cr>
            nnoremap <leader>fb <cmd>Telescope buffers<cr>
            nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          '';
        }
      ];
      extraConfig = ''
        " === Options ===
        set number relativenumber
        set mouse=a

        set tabstop=4 shiftwidth=4 et

        set backup backupdir=~/.local/share/nvim/backup,.

        set scrolloff=4

        " === Autocmds ===
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

    home.file.ideavimrc = {
      target = ".ideavimrc";
      text = ''
        set number relativenumber
        set tabstop=4 shiftwidth=4 expandtab
        set scrolloff=4

        autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab

        autocmd FileType python setlocal textwidth=88

        nnoremap <silent> <BS> :nohlsearch<CR>

        map <leader>s <Action>(SelectInProjectView)
        map <leader>b <Action>(ToggleLineBreakpoint)
        map <leader>o <Action>(FileStructurePopup)

        set NERDTree
      '';
    };
  };
}
