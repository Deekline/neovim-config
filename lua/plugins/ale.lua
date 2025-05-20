return {
	"dense-analysis/ale",
	lazy = false,
	config = function()
		local g = vim.g

		g.ale_ruby_rubocop_auto_correct_all = 1
		g.ale_set_highlights = 0
		g.ale_disable = 0

		g.ale_linters = {
			lua = { "stylua" },
			vue = { "volar", "eslint" },
		}

		g.ale_fixers = {
			vue = { "eslint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			lua = { "stylua" },
		}

		g.ale_fix_on_save = 1
		vim.cmd("ALEEnable")
	end,
}
