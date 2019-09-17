set number relativenumber

source $HOME/.config/nvim/lightswitch.vim

" Python-style tabs
set tabstop=4
set shiftwidth=4
set et

" Spelling
set spelllang=en,nl

" Backups
set backup
set backupdir=~/.local/share/nvim/backup,.

"" Mappings
" Quick format
map Q gq

" Map backspace to removing search highlight
nnoremap <silent> <BS> :nohlsearch<CR>

" Toggle paste mode
set pastetoggle=<F2>

" Toggle spellcheck
map z! :set spell!<CR>

" Allow to use mouse
set mouse=a

"" Gruvbox
" Enable true color
set termguicolors

" Gruvbox setup
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_italic = 1

" Plugins
call plug#begin()

" Base
Plug 'editorconfig/editorconfig-vim'

" Vim Experience
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'scrooloose/nerdcommenter'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'morhetz/gruvbox'

" Languages
Plug 'neoclide/coc.nvim', {'tag': '*'}
Plug 'hdima/python-syntax', {'for': 'python' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'thmshrpr/uuagc-syntax-vim', {'for': 'uuagc'}
Plug 'elmcast/elm-vim', {'for': 'elm'}

" Markup / Data
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'cespare/vim-toml', {'for': 'toml' }
Plug 'Glench/Vim-Jinja2-Syntax'

call plug#end()

color gruvbox

" Highlight these languages in Markdown blocks
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "bash=sh", "haskell"]

""" LaTeX
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:tex_comment_nospell=1
let g:vimtex_compiler_latexmk = {
    \ 'options': [
    \   '-pdf',
    \   '-shell-escape',
    \   '-interaction=nonstopmode',
    \   '-synctex=0',
    \   '-file-line-error',
    \   '-verbose',
    \ ],
    \}

""" NERDtree
noremap <silent> <leader>n :NERDTreeToggle<CR>
noremap <silent> <leader>f :NERDTreeFind<CR>

function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

""" COC
" if hidden is not set, TextEdit might fail.
set hidden

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
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

" Trailing space highlighting, taken from
" <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

