" Python 파일에 대한 설정
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" JavaScript 파일에 대한 설정
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab

" TypeScript 파일에 대한 설정
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 expandtab


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

" discord presence
Plug 'andweeb/presence.nvim'

" github copilot
Plug 'github/copilot.vim'

" kotlin syntax highlight
Plug 'udalov/kotlin-vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" line number 설정
set nu

" set theme
lua require('onedark').setup { style = 'warmer' }
lua require('onedark').load()
colorscheme onedark

lua require'lspconfig'.marksman.setup{}

lua << EOF
require'lspconfig'.jsonls.setup{}
require'cmp'.setup {
	sources = {
		{ name = 'nvim_lsp' },
	},
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:CmpNormal",
		},
		documentation = {
			winhighlight = "Normal:CmpDocNormal",
		}
	}
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.tsserver.setup{
	capabilites=capabilites,
}
require'lspconfig'.pyright.setup{
	capabilites=capabilites,
}
