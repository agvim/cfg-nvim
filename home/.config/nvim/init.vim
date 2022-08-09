" Modeline and Notes {
" vim: set sw=2 sts=2 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"   vimrc based on https://github.com/bling/dotvim
" }

" misc stuff {
  set nocompatible

  function! s:get_cache_dir(suffix) " {
    return resolve(expand(s:cache_dir . '/' . a:suffix))
  endfunction " }

  function! Preserve(command) " {
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction " }

  function! StripTrailingWhitespace() " {
    call Preserve("%s/\\s\\+$//e")
  endfunction " }

  function! EnsureExists(path) " {
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path), "p")
    endif
  endfunction " }

  " grep with ripgrep
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
    set grepformat=%f:%l:%c:%m
  endif

  " vim file/folder management {
    let s:cache_dir = '/tmp/$USER/vimcache'

    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = s:get_cache_dir('undo')
    endif

    " swap files
    let &directory = s:get_cache_dir('swap')
    " set noswapfile

    call EnsureExists(s:cache_dir)
    call EnsureExists(&undodir)
    call EnsureExists(&directory)
  " }

  " folding {
    set foldenable
    set foldmethod=syntax
    set foldlevelstart=99
    " fold xml based on syntax
    let g:xml_syntax_folding=1
  " }

  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \  exe 'normal! g`"zvzz' |
    \ endif
" }

" TODO XXX make a command
" redir => m | silent registers | redir END | put=m

" Main stuff {
  " use comma as the leader key
  let mapleader = ','

  " mouse!
  set mouse=a
  set mousehide

  " Long line wrapping rulez
  set wrap

  " highlight whitespace
  set list
  set listchars=tab:›\ ,trail:•,extends:❯,precedes:❮
  let &showbreak='↪ '

  " allow backspacing everything in insert mode
  set backspace=indent,eol,start
  " automatically indent to match adjacent lines
  set autoindent
  " spaces instead of tabs
  set expandtab
  " use shiftwidth to enter tabs
  set smarttab
  " tabstob should be 8 generally because it is the assumed default
  set ts=8
  " indenting should be 4 spaces by default
  set sts=4
  set sw=4
  " line numbers
  if !exists('g:vscode')
  set number
  endif

  " Force md and markdeep files to be recognized as markdown instead of modula or html files
  au BufRead,BufNewFile *.md,*.md.html set filetype=markdown
  " Less identation for the following file types
  autocmd FileType xml,tex,markdown,docbk,xsd,xslt setlocal shiftwidth=2 softtabstop=2
  " automatically strip trailing whitespace for these file types
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,tex,markdown,docbk,xsd,xslt autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  " python is indentation based folding
  " should be handled by treesitter
  " autocmd FileType python setlocal foldmethod=indent

  " searching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

  "automatically highlight matching braces/brackets/etc.
  set showmatch

  " use OS clipboard
  if has('clipboard')
    " When possible use + register for copy-paste
    if has('unnamedplus')
      set clipboard=unnamed,unnamedplus
    " On Windows, use * register for copy-paste
    else
      set clipboard=unnamed
    endif
  endif

  " use utf-8 as default encoding
  set encoding=utf-8

  "highlight column 80 and the current line
  set colorcolumn=80
  set cursorline

  " enable vim spellchecker
  set spell

  " Use Fira code font in gui vim and fall back to the symbols font.
  " In vim is the term font
  set guifont=Fira\ Code,JetBrains\ Mono,Symbols\ Nerd\ Font:h11

  " set some neovide gui options
  let neovide_remember_window_size = v:true
  let g:neovide_cursor_animation_length=0.02
  let g:neovide_cursor_trail_length=0

  " gvim options
  " no menu items
  set guioptions+=t
  " no toolbar icons
  set guioptions-=T
" }

" Diffing {
  " Wrapping also for diffs (copies the wrap setting)
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif

  " Ignore whitespaces and tab differences when diffing and use vertical splits
  set diffopt+=iwhite,vertical
  " Use gnu diffutils as it is more powerful, added options are:
  " -w : ignore all white space
  " -B : ignore changes whose lines are all blank
  " --strip-trailing-cr : strip trailing carriage return on input
  " -d : try hard to find a smaller set of changes
  set diffexpr=MyDiff()
  " Empower iwhite option to ignore all white space and blank lines
  function MyDiff()
    let opt = ""
    if &diffopt =~ "icase"
      let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
      let opt = opt . "-w -B --strip-trailing-cr "
    endif
    silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
                \  " > " . v:fname_out
  endfunction
" }

" plugins  config {
  " plugins are managed with vim-plug
  call plug#begin('~/.vim/plugged')

  " solarized color scheme
  " Plug 'Tsuzat/NeoSolarized.nvim' " {
  "   let g:NeoSolarized_italics = 1 " 0 or 1
  "   let g:NeoSolarized_visibility = 'normal' " low, normal, high
  "   let g:NeoSolarized_diffmode = 'normal' " low, normal, high
  "   let g:NeoSolarized_termtrans = 1 " 0(default) or 1 -> Transparency
  "   let g:NeoSolarized_lineNr = 0 " 0 or 1 (default) -> To Show backgroung in LineNr
  " " }
  Plug 'maxmx03/solarized.nvim'

  " to use % to go to matching opening/closing tag/char
  Plug 'vim-scripts/matchit.zip'

  " fancy statusline
  if !exists('g:vscode')
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'romgrk/barbar.nvim'
  endif

  " surround a selected block of text
  Plug 'tpope/vim-surround'

  " show changed lines in the left bar
  if !exists('g:vscode')
  Plug 'mhinz/vim-signify' " {
    " let g:signify_update_on_bufenter=0
  " }
  endif

  " " webapi and emmet for simpler xml editing
  " if !exists('g:vscode')
  " Plug 'mattn/webapi-vim'
  " Plug 'mattn/emmet-vim'
  " endif

  " snippets and auto-completion (TODO: tune default configuration)
  if !exists('g:vscode')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  " Installed modules
  " :TSInstall python
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " {
    " disable warnings when using old vim
    let g:coc_disable_startup_warning = 1

    " Some servers have issues with backup files, see #649.
    set nobackup
    set nowritebackup

    " " Give more space for displaying messages.
    " set cmdheight=2

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("nvim-0.5.0") || has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1):
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice.
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    " nnoremap <silent> K :call <SID>ShowDocumentation()<CR>
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocActionAsync('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call CocActionAsync('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

    " generic coc extensions
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'} "{
      " use with snippets
      Plug 'honza/vim-snippets'
    " }

    " language specific coc extensions
    Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
    Plug 'fannheyward/coc-texlab', {'do': 'yarn install --frozen-lockfile'}
    " link emmet with autocompletion.
    " TODO XXX FIXME: removed as it does not currently integrate custom snippets
    " Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
    Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
    " }
  endif

  " highlighting
  if !exists('g:vscode')
  " highlight word under cursor
  Plug 'dominikduda/vim_current_word'
  " highlight colors
  Plug 'norcalli/nvim-colorizer.lua'
  " highlight improvements for scrollbar
  " Plug 'kevinhwang91/nvim-hlslens'
  endif

  " eases sharing and following editor configuration conventions
  Plug 'editorconfig/editorconfig-vim' ", {'on_event':['BufNewFile', 'BufReadPost', 'BufFilePost']}

  " auto closes braces and such
  Plug 'windwp/nvim-autopairs'

  " show the undo tree in an easier to use form
  if !exists('g:vscode')
  Plug 'mbbill/undotree', {'on':'UndotreeToggle'} " {
    let g:undotree_SetFocusWhenToggle=1
    nnoremap <silent> <leader>uu :UndotreeToggle<CR>
  " }
  endif

  " file browser
  " https://github.com/kyazdani42/nvim-tree.lua or https://github.com/ms-jpq/chadtree
  if !exists('g:vscode')
  Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " {
    " let g:NERDTreeShowHidden = 1
    let g:NERDTreeMinimalUI = 1
    let NERDTreeIgnore=['\.git','\.hg']
    nnoremap <silent> <leader>ee :NERDTreeToggle<CR>
  " }
  endif

  " functions and symbols bar
  if !exists('g:vscode')
  Plug 'liuchengxu/vista.vim' " {
    let g:vista#renderer#enable_icon = 1
    nnoremap <silent> <leader>tt :Vista!!<CR>
  " }
  endif

  " show indent levels
  if !exists('g:vscode')
  Plug 'lukas-reineke/indent-blankline.nvim'
    let g:indent_blankline_show_first_indent_level = v:false
    " let g:indent_blankline_char = '|'
    let g:indent_blankline_use_treesitter = v:true
    let g:indent_blankline_show_current_context = v:true
  " Plug 'Yggdroot/indentLine'
    " let g:indentLine_defaultGroup = 'SpecialKey'
  endif

  " xml tag closing, in vscode use auto close tag and auto rename tag
  if !exists('g:vscode')
  Plug 'sukima/xmledit'
  endif

  " icons for non-text area stuff
  if !exists('g:vscode')
  Plug 'ryanoasis/vim-devicons'
  Plug 'kyazdani42/nvim-web-devicons'
  endif
  " finish loading
  call plug#end()
" }

  " if !exists('g:vscode')
  " " load custom emmet snippets for emmet-vim ('mattn/emmet-vim')
  " " TODO FIXME: the substitution works if there is no snippet with //
  " let emmet_without_comments = substitute(join(readfile(expand('~/emmet1snippets.json')), "\n"), '//[^\r\n]*', '', 'g')
  " let g:user_emmet_settings = webapi#json#decode(emmet_without_comments)
  " endif


" General Key (re)Mappings {
  " screen line scroll
  nnoremap <silent> j gj
  nnoremap <silent> k gk

  " reselect visual block after indent
  vnoremap < <gv
  vnoremap > >gv

" }

" display stuff {
  " enable auto indent and colorized syntax
  filetype plugin indent on
  syntax enable
  set termguicolors
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  " color NeoSolarized
  color solarized
lua <<EOF
require('solarized').setup({
  mode = 'dark',
  theme = 'vim',
})
EOF
  " Fix CoC menu background for selected item
  hi CocMenuSel guibg=#002b36
  " background is autodetected by vim
  " set background=dark
  " briefly highlight yanked text
  au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=500, on_visual=true}

  " enable colorizer for all file types
  if !exists('g:vscode')
  lua require'colorizer'.setup()
  endif
  " highlight current word and copies using the same color as vscode
  " {
    hi CurrentWord guibg=#054150
    hi CurrentWordTwins guibg=#054150
  " }
  " let

  " enable autopairs
lua <<EOF
require('nvim-autopairs').setup({
  map_cr = false,
  map_bs = false,
})
EOF
  " Lualine and barbar tabline
  set noshowmode
  if !exists('g:vscode')
lua <<EOF
-- FIXME: using a global variable to use it in the autocmd below.
-- try to change once the neovim lua api exposes autocmd
_G.custom_solarized = {}
-- Change the insert and replace background to yellow and orange so green and red are free
_G.custom_solarized["light"] = require'lualine.themes.solarized_light'
_G.custom_solarized["light"].insert.a.bg = '#b58900'
_G.custom_solarized["light"].replace.a.bg = '#cb4b16'
_G.custom_solarized["dark"] = require'lualine.themes.solarized_dark'
_G.custom_solarized["dark"].insert.a.bg = '#b58900'
_G.custom_solarized["dark"].replace.a.bg = '#cb4b16'
require'lualine'.setup{
  options = { theme  = _G.custom_solarized[vim.opt.background:get()] },
}
EOF
  autocmd OptionSet background lua require'lualine'.setup{ options = {theme=_G.custom_solarized[vim.opt.background:get()]},}
  endif

  " Treesitter stuff
  if !exists('g:vscode')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
l
}
EOF
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  endif

" change the terminal title to reflect the filename
  set title
" }
