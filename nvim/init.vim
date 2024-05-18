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

" vim airline (화면 부가정보)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git 관련 기능
Plug 'tpope/vim-fugitive'

" 주석 기능
Plug 'preservim/nerdcommenter'

" 괄호사용관련
Plug 'tpope/vim-surround'

call plug#end()

" nerdtree 설정
map <C-t> :NERDTreeToggle<CR>

" vim airline 설정
let g:airline_powerline_fonts = 1		" powerline 폰트 사용
let g:airline#extensions#tabline#enabled = 1	" 탭 라인 활성화
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format

" nerdcommenter 설정
let g:NERDCreateDefaultMappings = 0		" 기본 매핑 비활성화
let g:NERDToggleCheckAllLines = 1		" 주석 토글시 모든 라인 주석처리
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
