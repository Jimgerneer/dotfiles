local lspConfigAuGroup = vim.api.nvim_create_augroup("LspConfigAuGroup", { clear = false })

function PeekDefinition()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

function common_on_attach(client, bufnr)

	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = lspConfigAuGroup })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		callback = function()
			require("nvim-lightbulb").update_lightbulb({
				sign = {
					enabled = false,
				},
				virtual_text = {
					enabled = true,
					-- Text to show at virtual text
					text = "",
					-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
					hl_mode = "combine",
				},
			})
		end,
		buffer = bufnr,
		group = lspConfigAuGroup,
	})

	local function buf_set_option(name, value)
		vim.api.nvim_set_option_value(name, value, { buf = bufnr })
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set({ "i", "s" }, "<c-l>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gl", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gr", "<cmd>Glance references<CR>", opts)
	vim.keymap.set({ "x", "n" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>", opts)
	vim.keymap.set("n", "gt", "<cmd>Glance type_definitions<CR>", opts)
	vim.keymap.set("n", "gi", "<cmd>Glance implementations<CR>", opts)
	vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)

	if client.server_capabilities.codeLensProvider then
		vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
			group = lspConfigAuGroup,
		})
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.keymap.set("n", "<leader>gq", vim.lsp.buf.format, opts)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			buffer = bufnr,
			callback = function()
				if vim.g.format_on_save then
					vim.lsp.buf.format()
				end
			end,
			group = lspConfigAuGroup,
		})
	end
end

local function setup_lspconfig()
	require("fidget").setup()

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
	)

	local lspconfig = require("lspconfig")

	lspconfig.solargraph.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
	lspconfig.nushell.setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.nil_ls.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.gdscript.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.ocamllsp.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.marksman.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
end

return {
  {
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
			{
				"SmiteshP/nvim-navic",
				dependencies = { "neovim/nvim-lspconfig" },
			},
			"j-hui/fidget.nvim",
			"kosayoda/nvim-lightbulb",
		},
		config = setup_lspconfig,
	},
	{
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = common_on_attach,
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gpd", "<cmd>Glance definitions<CR>" },
      { "gpr", "<cmd>Glance references<CR>" },
      { "gpt", "<cmd>Glance type_definitions<CR>" },
      { "gpi", "<cmd>Glance implementations<CR>" },
    },
    opts = function()
      local actions = require("glance").actions
      return {
        theme = { -- This feature might not work properly in nvim-0.7.2
          -- enable = true, -- Will generate colors for the plugin based on your current colorscheme
          -- mode = "brighten", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        },
        list = {
          position = "left", -- Position of the list window 'left'|'right'
          width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
        },
        detached = function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end,
        folds = {
          fold_closed = "󰅂", -- 󰅂 
          fold_open = "󰅀", -- 󰅀 
          folded = false,
        },
        border = {
          enable = true, -- Show window borders. Only horizontal borders allowed
          top_char = "―",
          bottom_char = "―",
        },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["<C-l>"] = actions.jump_vsplit,
            ["<C-j>"] = actions.jump_split,
            ["st"] = actions.jump_tab,
            ["p"] = actions.enter_win("preview"),
          },
          preview = {
            ["q"] = actions.close,
            ["p"] = actions.enter_win("list"),
          },
        },
      }
    end,
  },
}
