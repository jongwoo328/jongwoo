" Python 파일에 대한 설정
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" JavaScript 파일에 대한 설정
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab

" TypeScript 파일에 대한 설정
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 expandtab

" 기본 탭사이즈 설정
set tabstop=4
set shiftwidth=4
set expandtab

call plug#begin()

" lspconfig 설치
Plug 'neovim/nvim-lspconfig'

" one dark theme
Plug 'navarasu/onedark.nvim'

" nerdtree
Plug 'preservim/nerdtree'

" 자동완성
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" add pictograms to lsp
Plug 'onsails/lspkind.nvim'

" discord presence
Plug 'andweeb/presence.nvim'

" github copilot
Plug 'github/copilot.vim'

" kotlin syntax highlight
Plug 'udalov/kotlin-vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" vim airline (화면 부가정보)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git 관련 기능
Plug 'tpope/vim-fugitive'

" 주석 기능
Plug 'preservim/nerdcommenter'

" 괄호사용관련
Plug 'tpope/vim-surround'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" nerdtree 설정
map <C-t> :NERDTreeToggle<CR>

" vim airline 설정
let g:airline_powerline_fonts = 1        " powerline 폰트 사용
let g:airline#extensions#tabline#enabled = 1    " 탭 라인 활성화
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format

" nerdcommenter 설정
let g:NERDCreateDefaultMappings = 0        " 기본 매핑 비활성화
let g:NERDToggleCheckAllLines = 1        " 주석 토글시 모든 라인 주석처리
nnoremap // <Plug>NERDCommenterToggle
vnoremap // <Plug>NERDCommenterToggle

" custom keymap
noremap <C-j> 4j
noremap <C-k> 4k
noremap <C-h> 4h
noremap <C-l> 4l

" line number 설정
set nu

" 공백 변환
set list

" width 80에 라인표시
set colorcolumn=80

" set theme
lua require('onedark').setup { style = 'warmer' }
lua require('onedark').load()
colorscheme onedark

lua require'lspconfig'.marksman.setup{}

lua << EOF
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.jsonls.setup{
    capabilities=capabilities,
}

require'lspconfig'.marksman.setup{
    capabilities=capabilities,
}

vim.o.completeopt = 'menu,menuone,noselect'
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        format = lspkind.cmp_format(),
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item() , {'i','c'}),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false })),
    })
})
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})


require'lspconfig'.tsserver.setup{
    capabilites=capabilites,
}
require'lspconfig'.pyright.setup{
    capabilites=capabilites,
}

-- treesitter 설정
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "csv",
        "html",
        "java",
        "javascript",
        "json",
        "kotlin",
        "markdown",
        "python",
        "scss",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "go"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
EOF

