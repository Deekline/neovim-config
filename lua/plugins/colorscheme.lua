return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			compile = true,
			transparent = true,
			overrides = function(colors)
				local theme = colors.theme
				local makeDiagnosticColor = function(color)
					local c = require("kanagawa.lib.color")
					return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
				end

				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					SignColumn = { bg = "NONE" },
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					LineNr = { bg = "NONE" },
					CursorLineNr = { bg = "NONE" }, -- Treesitter context transparency
					TreesitterContext = { bg = "NONE" },
					TreesitterContextLineNumber = { bg = "NONE" },
					TreesitterContextSeparator = { bg = "NONE" },
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
		vim.cmd("highlight TelescopeBorder guibg=none")
		vim.cmd("highlight TelescopeTitle guibg=none")
	end,
	build = function()
		vim.cmd("KanagawaCompile")
	end,
}
