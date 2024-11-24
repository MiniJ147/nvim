local on_attach = require("util.lsp").on_attach

local config = function()
	require("neoconf").setup({})

	local lspconfig = require("lspconfig")

	local signs = { Error = "✘", Warn = "▲", Hint = "●", Info = "●" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- lua
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = { -- custom settings for lua
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

	--python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			pyright = {
				disableOrganizeImports = false,
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletions = true,
				},
			},
		},
	})

	--go
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
	})

	-- lua
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	-- python
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	-- configure efm server
	lspconfig.efm.setup({
		filetypes = {
			-- "solidity",
			"lua",
			"go",
			"python",
			-- "json",
			-- "jsonc",
			-- "sh",
			-- "javascript",
			-- "javascriptreact",
			-- "typescript",
			-- "typescriptreact",
			-- "svelte",
			-- "vue",
			-- "markdown",
			-- "docker",
			-- "html",
			-- "css",
			-- "c",
			-- "cpp",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				-- solidity = { solhint, prettier_d },
				lua = { luacheck, stylua },
				python = { flake8, black },
				-- typescript = { eslint, prettier_d },
				-- json = { eslint, fixjson },
				-- jsonc = { eslint, fixjson },
				-- sh = { shellcheck, shfmt },
				-- javascript = { eslint, prettier_d },
				-- javascriptreact = { eslint, prettier_d },
				-- typescriptreact = { eslint, prettier_d },
				-- svelte = { eslint, prettier_d },
				-- vue = { eslint, prettier_d },
				-- markdown = { prettier_d },
				-- docker = { hadolint, prettier_d },
				-- html = { prettier_d },
				-- css = { prettier_d },
				-- c = { clangformat, cpplint },
				-- cpp = { clangformat, cpplint },
			},
		},
	})

	local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = lsp_fmt_group,
		callback = function()
			local efm = vim.lsp.get_clients({ name = "efm" })
			if vim.tbl_isempty(efm) then
				return
			end

			vim.lsp.buf.format({ name = "efm" })
		end,
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
	},
}
