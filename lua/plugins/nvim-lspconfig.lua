local on_attach = require("util.lsp").on_attach

local show_diagnostics_callback = function()
	-- check to see if another floating window is active
	-- if it is exit out of the function
	-- this will prevent conflicts
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			-- A floating window is open, so skip showing diagnostics
			return
		end
	end

	local float_bufnr, float_wid = vim.diagnostic.open_float(nil, { focus = false })
	if float_bufnr then
		vim.diagnostic.config({
			virtual_text = false,
		})

		vim.api.nvim_create_autocmd("WinClosed", {
			callback = function(event)
				if tonumber(event.file) == float_wid then
					vim.diagnostic.config({
						virtual_text = true,
					})
				end
			end,
			once = true,
		})
	end
end

local config_diagnostics = function()
	vim.diagnostic.config({
		virtual_text = true,
	})

	-- Show line diagnostics :w
	-- automatically in hover window
	vim.o.updatetime = 250
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		pattern = "*",
		callback = show_diagnostics_callback,
	})
end

local config = function()
	require("neoconf").setup({})
	local lspconfig = require("lspconfig")

	config_diagnostics()

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

	-- c/cpp
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "clangd" },
		filetypes = { "c", "c++", "cpp", "h", "hpp" },
	})

	lspconfig.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "json" },
	})

	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})

	lspconfig.ts_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
		},
		settings = {
			typescript = {
				indentStyle = "space",
				indentSize = 2,
			},
		},
	})

	-- lua
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	-- python
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	-- go
	local golangci_lint = require("efmls-configs.linters.golangci_lint")
	local gofmt = require("efmls-configs.formatters.gofmt")

	-- rust
	-- local bacon = require("efmls-configs.linters.bacon")

	-- json
	local eslint = require("efmls-configs.linters.eslint")
	local fixjson = require("efmls-configs.formatters.fixjson")

    local prettier_d = require("efmls-configs.formatters.prettier_d")

	-- configure efm server
	lspconfig.efm.setup({
		filetypes = {
			-- "solidity",
			"lua",
			"go",
			"python",
			"rust",
			"json",
			-- "jsonc",
			-- "sh",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
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
				-- rust = { bacon },
				lua = { luacheck, stylua },
				python = { flake8, black },
				go = { golangci_lint, gofmt },
				-- typescript = { eslint, prettier_d },
				json = { eslint, fixjson },
				-- jsonc = { eslint, fixjson },
				-- sh = { shellcheck, shfmt },
				javascript = { eslint, prettier_d },
				javascriptreact = { eslint, prettier_d },
				typescriptreact = { eslint, prettier_d },
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
