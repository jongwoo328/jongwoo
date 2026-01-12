" default
set tabstop=4
set shiftwidth=4

call plug#begin()

" lspconfig 설치
Plug 'neovim/nvim-lspconfig'

" one dark theme
Plug 'navarasu/onedark.nvim'
" tokyonight theme
Plug 'folke/tokyonight.nvim'

" neo-tree
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

" 자동완성
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" diff highlight
Plug 'lewis6991/gitsigns.nvim'

" add pictograms to lsp
Plug 'onsails/lspkind.nvim'

" discord presence
Plug 'andweeb/presence.nvim'

" github copilot
Plug 'github/copilot.vim'

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

" indent line
Plug 'lukas-reineke/indent-blankline.nvim'

" highlighit log file
Plug 'mtdl9/vim-log-highlighting'

" markdown viewer
Plug 'toppair/peek.nvim'

" code format
Plug 'stevearc/conform.nvim'

" cursor animation
Plug 'sphamba/smear-cursor.nvim'
call plug#end()

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

" line number 설정
set nu
set relativenumber

" 공백 변환
set list

" width 80에 라인표시
set colorcolumn=80

" set theme
"lua require('onedark').setup { style = 'darker' }
"lua require('onedark').load()
"colorscheme onedark
colorscheme tokyonight-night

lua << EOF
-- neo tree 설정
require('neo-tree').setup({
	window = {
		mappings = {
			["P"] = {
				"toggle_preview",
				config = {
					use_float = true,
					title = "Preview",
				},
			},
		},
	},
	filesystem = {
		filtered_items = {
			visible = true, -- 숨겨진 파일을 표시할지 여부
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_by_name = {
				'.DS_Store',
				'node_modules',
				'__pycache__',
				'.git',
			},
		},
	},
})
vim.keymap.set('n', '<C-t>', '<Cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<leader>t', '<Cmd>Neotree focus<CR>')
vim.keymap.set('n', '<leader>e', '<C-w>p') -- 현재 창에서 이전 창으로 이동


vim.lsp.enable({
	'lua_ls', -- lua language server
	'gopls', -- go language server
	'jsonls', -- json language server
	'marksman', -- markdown language server
	'pyrefly', -- python language server
	'rust_analyzer', -- rust language server
	'yamlls', -- yaml language server
	'tombi', -- toml language server
})
vim.lsp.config('vtsls', {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = '@vue/typescript-plugin',
						location = '/opt/homebrew/bin/vue-language-server',
						languages = { 'vue' },
						configNamespace = 'typescript',
					},
				},
			},
		},
	},
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})
vim.lsp.enable({'vtsls', 'vue_ls'})


require('smear_cursor').enabled = true
require('smear_cursor').setup{
	cursor_color='#38E57B',
	stiffness = 0.8,
	trailing_stiffness = 0.5,
	never_draw_over_target = false,
	distance_stop_animating = 0.5,
	hide_target_hack = true,
    never_draw_over_target = true,
}

-- git diff highlight
require('gitsigns').setup({
	current_line_blame = true, -- 현재 라인에 대한 blame 정보 표시
	current_line_blame_opts = {
		delay = 500,
	},
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		
		-- key mappings
		map('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
	end
})

vim.diagnostic.config({
  virtual_text = true,      -- 라인 옆에 에러 메시지 출력
  signs = true,             -- gutter(좌측)에 아이콘 표시
  underline = true,         -- 에러난 부분 밑줄
  update_in_insert = false, -- 입력 중에도 실시간으로 업데이트할지
  severity_sort = true,     -- 심각도별 정렬
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

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

-- treesitter 설정
require'nvim-treesitter'.setup {
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
        "go",
        "rust",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- blankline
require("ibl").setup()

-- markdown preview
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

-- formatter
local conform = require("conform")

-- 프로젝트에 Prettier 설정/의존성이 존재하는지 검사
local function project_has_prettier(dir)
	-- 설정 파일 탐색
	local cfg = vim.fs.find({
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yaml",
		".prettierrc.yml",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.ts",
		"prettier.config.js",
		"prettier.config.cjs",
		"prettier.config.ts",
	}, { upward = true, path = dir })[1]
	if cfg then return true end

	-- package.json에 prettier 필드가 있는 경우
	local pkg = vim.fs.find("package.json", { upward = true, path = dir })[1]
	if pkg then
		local ok, lines = pcall(vim.fn.readfile, pkg)
		if ok and lines then
			local content = table.concat(lines, "\n")
			-- package.json에 prettier 설정이 있는 경우
			if content:find([["prettier"%s*:]]) then
				return true
			end
			-- dependency에 prettier가 있는 경우
			if content:find([["prettier"%s*]]) then
				return true
			end
		end
	end

	-- 로컬 바이너리 존재 (node_modules/.bin/prettier)
	local bin = vim.fs.find("node_modules/.bin/prettier", { upward = true, path = dir })[1]
	if bin then return true end

	return false
end

-- 프로젝트에 Black 설정/의존성이 존재하는지 검사
local function project_has_black(dir)
	-- pyproject.toml의 [tool.black] 섹션
	local pyproj = vim.fs.find("pyproject.toml", { upward = true, path = dir })[1]
	if pyproj then
		local ok, lines = pcall(vim.fn.readfile, pyproj)
		if ok and lines then
			local content = table.concat(lines, "\n"):lower()
			if content:find("%[tool%.black%]") then
				return true
			end
		end
	end

	local depfile = vim.fs.find({ "requirements.txt" }, { upward = true, path = dir })[1]
	if depfile then
		local ok, lines = pcall(vim.fn.readfile, depfile)
		if ok and lines then
			for _, line in ipairs(lines) do
				local s = line:lower()
				-- 주석이나 빈 줄은 무시
				if not s:match("^%s*#") and s:match("%S") then
					-- black, black==..., black>=..., black[...] 모두 catch
					if s:match("^%s*black%s*$")               -- 그냥 black
						or s:match("^%s*black%s*[%[%]=~<>]")  -- 버전/extra 포함
					then
						return true
					end
				end
			end
		end
	end
	return false
end

conform.setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript  = { "prettier" },
		html        = { "prettier" },
		css         = { "prettier" },
		json        = { "prettier" },
		yaml        = { "prettier" },
		markdown    = { "prettier" },
		python      = { "black" },
	},
	-- 자동포맷 (조건부)
	format_on_save = function(bufnr)
		local ft = vim.bo[bufnr].filetype
		local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")

		if ft == "python" and not project_has_black(dir) then
			return nil
		end
		if (ft == "javascript" or ft == "typescript" or ft == "html"
			or ft == "css" or ft == "json" or ft == "yaml" or ft == "markdown")
			and not project_has_prettier(dir) then
			return nil
		end

		return {
			lsp_format = "fallback",
			timeout_ms = 500,
		}
	end,
})

-- 수동포맷 (항상 실행)
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({
		async = true,
		lsp_format = "fallback",
		range = range,
	})
end, { range = true })

-- custom keymap
vim.keymap.set({ "n", "v", "o" }, "<C-j>", "4j", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "o" }, "<C-k>", "4k", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "o" }, "<C-h>", "4h", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "o" }, "<C-l>", "4l", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>c", '"+y', { noremap = true, silent = true })  -- 선택영역 복사

EOF

