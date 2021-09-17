{ config, pkgs, mkMerge, ... }:

let
  # Extra packages for Jedi setup.
  ps = pkgs.python3Packages;

  jedi_0_18_0 = ps.jedi.overrideAttrs (old: {
    version = "0.18.0";
    src = ps.fetchPypi {
      pname = "jedi";
      version = "0.18.0";
      sha256 =
        "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707";
    };
  });

  jedi-language-server = ps.buildPythonPackage rec {
    pname = "jedi-language-server";
    version = "0.34.3";

    src = ps.fetchPypi {
      inherit pname version;
      sha256 =
        "103296591fdfe8a8dc6277f54d31ef4ddf41cee81e7af2cc04b2b1f66349cf6a";
    };

    propagatedBuildInputs = [
      ps.click
      jedi_0_18_0
      pygls_0_11_2
      ps.cached-property
      docstring-to-markdown
    ];
  };

  # Version in Nixpkgs is at 0.9.2, jedi-language-server requires a newer one.
  pygls_0_11_2 = ps.pygls.overridePythonAttrs (oldAttrs: rec {
    version = "0.11.2";

    src = ps.fetchPypi {
      pname = "pygls";
      inherit version;

      sha256 =
        "1ade26fc9cf0d7c0700fa5430e8dc8411b1108d1eb21565adbe480b64f721a84";
    };

    propagatedBuildInputs = [ ps.setuptools-scm ps.typeguard ps.pydantic ];
  });

  # Not in Nixpkgs, required by jedi-language-server.
  docstring-to-markdown = ps.buildPythonPackage rec {
    pname = "docstring-to-markdown";
    version = "0.9";

    src = ps.fetchPypi {
      inherit pname version;
      sha256 =
        "0b810e6e16737d2d0ede6182f66f513f814a11fad1222e645fbc14acde78e171";
    };
  };

in {
  config = {
    # Required to use CoC.
    programs.neovim.withNodeJs = true;

    # Required to set up Jedi, HLS:
    programs.neovim.extraPython3Packages = ps: [
      jedi_0_18_0
      jedi-language-server
    ];

    programs.neovim.extraPackages =
      [ jedi-language-server pkgs.haskell-language-server ];

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
          "${jedi-language-server}/bin/jedi-language-server";

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

    programs.neovim.plugins = with pkgs.vimPlugins; [
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
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <c-space> to trigger completion in insert mode.
          inoremap <silent><expr> <c-space> coc#refresh()

          " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
          " Coc only does snippet and additional edit on confirm.
          inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

          " Use `[c` and `]c` to navigate diagnostics
          nmap <silent> [c <Plug>(coc-diagnostic-prev)
          nmap <silent> ]c <Plug>(coc-diagnostic-next)

          " Remap keys for gotos
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window
          nnoremap <silent> K :call <SID>show_documentation()<CR>

          function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            else
              call CocAction('doHover')
            endif
          endfunction

          " Highlight symbol under cursor on CursorHold
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Remap for rename current word
          nmap <leader>rn <Plug>(coc-rename)

          " Remap for format selected region
          nmap <leader>F  <Plug>(coc-format)

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

      # Coc-jedi isn't in Nixpkgs but coc-python is, override stuff so it works.
      {
        plugin = let
          coc-jedi = pkgs.nodePackages.coc-python.override rec {
            name = "coc-jedi";
            packageName = "coc-jedi";
            version = "0.29.3";

            src = pkgs.fetchurl {
              url =
                "https://registry.npmjs.org/coc-jedi/-/coc-jedi-${version}.tgz";
              sha256 = "1wrqzldxg74qi90h60r6cvjy1bi3frr8izpdg8jg3s7i71b021r4";
            };
          };
        in pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "coc-jedi";
          version = coc-jedi.version;
          src = "${coc-jedi}/lib/node_modules/coc-jedi";
        };
      }
    ];
  };
}
