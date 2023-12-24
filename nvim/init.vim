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

call plug#end()

" line number 설정
set nu
" clipboard 설정
set clipboard+=unnamedplus

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
