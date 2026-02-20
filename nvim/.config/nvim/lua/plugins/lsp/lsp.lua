return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	dependencies = {
		-- LSP Support
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },

		-- Helpers for nvim config
		{ "folke/lazydev.nvim", opts = {} },

		-- Autocompletion
		{ "saghen/blink.cmp" },
	},
	keys = {
		{
			"K",
			function()
				vim.lsp.buf.hover()
			end,
			mode = { "n" },
			desc = "LSP: hover definition",
		},
		{
			"gd",
			function()
				vim.lsp.buf.definition()
			end,
			mode = { "n" },
			desc = "LSP: go to definition",
		},
		{
			"gD",
			function()
				vim.lsp.buf.declaration()
			end,
			mode = { "n" },
			desc = "LSP: go to declaration",
		},
		{
			"gi",
			function()
				vim.lsp.buf.implementation()
			end,
			mode = { "n" },
			desc = "LSP: go to implementation",
		},
		{
			"go",
			function()
				vim.lsp.buf.type_definition()
			end,
			mode = { "n" },
			desc = "LSP: go to type definition",
		},
		{
			"gR",
			function()
				vim.lsp.buf.references()
			end,
			mode = { "n" },
			desc = "LSP: list all references",
		},
		{
			"gS",
			function()
				vim.lsp.buf.signature_help()
			end,
			mode = { "n" },
			desc = "LSP: signature help",
		},
		-- {"gS", function() vim.lsp.buf.document_symbol() end, mode = {"n"}, desc = "LSP: show document symbols"},
		{
			"<F2>",
			function()
				vim.lsp.buf.rename()
			end,
			mode = { "n" },
			desc = "LSP: rename variable",
		},
		{
			"<F4>",
			function()
				vim.lsp.buf.code_action()
			end,
			mode = { "n" },
			desc = "LSP: code actions",
		},
		{
			"gl",
			function()
				vim.diagnostic.open_float()
			end,
			mode = { "n" },
			desc = "LSP: open diagnostics float window",
		},
		{
			"[d",
			function()
				vim.diagnostic.goto_prev()
			end,
			mode = { "n" },
			desc = "LSP: previous diagnostic",
		},
		{
			"]d",
			function()
				vim.diagnostic.goto_next()
			end,
			mode = { "n" },
			desc = "LSP: next diagnostic",
		},
	},
	opts = {
		servers = {
			ruff = {
				init_options = {
					settings = {
						-- Any extra CLI arguments for `ruff` go here.
						args = {
							"--extend-select",
							"E",
							"--extend-select",
							"I",
							"--extend-select",
							"D",
							"--ignore",
							"E501,I001",
						},
						-- args = {"--extend-select", "I", "--extend-select", "D", "--force-exclude"},
					},
				},
			},
			pylsp = {
				settings = {
					pylsp = {
						configurationSources = { "pycodestyle" },
						plugins = {
							autopep8 = {
								enabled = false,
							},
							flake8 = {
								enabled = false,
							},
							jedi_completion = {
								enabled = true,
								include_params = true,
							},
							mccabe = {
								enabled = false,
							},
							pycodestyle = {
								ignore = { "E501", "E121", "E123", "E126", "E226", "E24", "E704", "W503", "W504" },
							},
							pydocstyle = {
								enabled = false,
								convention = "numpy",
							},
							pylint = {
								enabled = false,
							},
							rope_autoimport = {
								enabled = true,
								completions = {
									enabled = false,
								},
								code_actions = {
									enabled = true,
								},
							},
							yapf = {
								enabled = false,
							},
						},
					},
				},
			},
			basedpyright = {
				settings = {
					basedpyright = {
						typeCheckingMode = "standard",
					},
				},
			},
			terraformls = {
				settings = {
					terraform = {
						experimentalFeatures = {
							validateOnSave = true,
						},
					},
				},
			},
			ts_ls = {
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- 1. Setup Mason
		mason.setup({})

		-- 2. Base Capabilities (UFO + Blink)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local has_blink, blink = pcall(require, "blink.cmp")
		if has_blink then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		-- 3. The "Smart" Handler
		-- This handles the auto-installation and the setup automatically
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(opts.servers or {}),
			handlers = {
				function(server_name)
					local server_opts = opts.servers[server_name] or {}

					-- Merge your specific server settings with the global capabilities
					server_opts.capabilities =
						vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})

					-- This is the only place we call lspconfig
					lspconfig[server_name].setup(server_opts)
				end,
			},
		})
	end,
}
