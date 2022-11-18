{ config, pkgs, mkMerge, ... }:

{
  config = {
    # Required to use CoC.
    programs.neovim.withNodeJs = true;

    # Required to set up Jedi, HLS:
    programs.neovim.extraPython3Packages = ps: [
      ps.jedi
      ps.jedi-language-server
    ];

    programs.neovim.extraPackages =
      [ pkgs.haskell-language-server pkgs.yamllint ];

    # Write CoC settings file.
    home.file."coc-settings.json" = {
      target = ".config/nvim/coc-settings.json";

      text = builtins.toJSON {
        "languageserver" = {
          "haskell" = {
            "command" = "haskell-language-server-wrapper";
            "args" = [ "--lsp" ];
            "rootPatterns" = [
              "*.cabal"
              "stack.yaml"
              "cabal.project"
              "package.yaml"
              "hie.yaml"
            ];
            "filetypes" = [ "haskell" "lhaskell" ];
          };
        };

        "jedi.executable.command" =
          "${pkgs.python3.pkgs.jedi-language-server}/bin/jedi-language-server";

        "diagnostic-languageserver.mergeConfig" = true;

        "diagnostic-languageserver.linters" = {
          yamllint = { args = [ "-c" ".yamllint" "-f" "parsable" "-" ]; };
        };

        "diagnostic-languageserver.filetypes" = {
          "python" = "mypy";
          "sh" = "shellcheck";
          "yaml" = "yamllint";
        };

        "diagnostic-languageserver.formatFiletypes" = {
          "nix" = [ "nixfmt" ];
          "python" = [ "black" "isort" ];
          "tf" = [ "tffmt" ];
        };
      };
    };

    programs.neovim.plugins = let
      extraNodePackages =
        import ../../node-herrie/default.nix { inherit pkgs; };
    in with pkgs.vimPlugins; [
      # CoC itself
      {
        plugin = coc-nvim;
        config = ''
          " Required for TextEdit
          set hidden

          " Better display for messages
          set cmdheight=2

          " Faster update for CursorHold & CursorHoldI
          set updatetime=300

          " Don't give |ins-completion-menu| messages
          set shortmess+=c

          " Use Tab to trigger completion
          inoremap <silent><expr> <TAB>
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ CheckBackspace() ? "\<Tab>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

          " Make <CR> to accept selected completion item or notify coc.nvim to format
          inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <c-space> to trigger completion in insert mode.
          inoremap <silent><expr> <c-space> coc#refresh()

          " Use `[c` and `]c` to navigate diagnostics
          nmap <silent> [c <Plug>(coc-diagnostic-prev)
          nmap <silent> ]c <Plug>(coc-diagnostic-next)

          " Remap keys for gotos
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window.
          nnoremap <silent> K :call ShowDocumentation()<CR>

          function! ShowDocumentation()
            if CocAction('hasProvider', 'hover')
              call CocActionAsync('doHover')
            else
              call feedkeys('K', 'in')
            endif
          endfunction

          " Highlight symbol under cursor on CursorHold
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Remap for rename current word
          nmap <leader>rn <Plug>(coc-rename)

          " Remap for format selected region
          nmap <leader>F  <Plug>(coc-format)
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  <Plug>(coc-format-selected)

          augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
            " Update signature help on jump placeholder
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          augroup end

          " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
          xmap <leader>a  <Plug>(coc-codeaction-selected)
          nmap <leader>a  <Plug>(coc-codeaction-selected)

          " Remap for do codeAction of current line
          nmap <leader>ac  <Plug>(coc-codeaction)
          " Fix autofix problem of current line
          nmap <leader>qf  <Plug>(coc-fix-current)
          " Run the Code Lens action on the current line.
          nmap <leader>cl  <Plug>(coc-codelens-action)

          " Use `:Format` to format current buffer
          command! -nargs=0 Format :call CocAction('format')

          " Use `:Fold` to fold current buffer
          command! -nargs=? Fold :call     CocAction('fold', <f-args>)

          " Show
          set statusline=[%n]\ %f\ %m%r%w%q%=%{coc#status()}\ (%l,%c)

          " Fix LaTeX LS
          let g:coc_filetype_map = {
            \ 'tex': 'latext',
            \ 'plaintex': 'tex',
            \ 'yaml.ansible': 'ansible',
            \ }

          " Using CocList
          " Show all diagnostics
          nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
          " Manage extensions
          nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
          " Show commands
          nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
          " Find symbol of current document
          nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
          " Search workspace symbols
          nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
          " Do default action for next item.
          nnoremap <silent> <space>j  :<C-u>CocNext<CR>
          " Do default action for previous item.
          nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
          " Resume latest coc list
          nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
        '';
      }

      # CoC plugins:
      coc-css
      coc-json
      coc-rls
      coc-yaml
      coc-diagnostic

      {
        plugin = let
          p = extraNodePackages."coc-jedi";
        in pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = p.packageName;
          version = p.version;
          src = "${p}/lib/node_modules/${p.packageName}";
        };
      }
      {
        plugin = let
          p = extraNodePackages."@yaegassy/coc-ansible";
        in pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = p.packageName;
          version = p.version;
          src = "${p}/lib/node_modules/${p.packageName}";
        };
      }
    ];
  };
}
