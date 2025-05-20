return {
	"echasnovski/mini.pairs",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.pairs").setup({
			modes = {
				insert = true,
				command = true,
				terminal = false,
			},
			mappings = {
				["("] = { action = "open", pair = "()" },
				[")"] = { action = "close", pair = "()" },
				["["] = { action = "open", pair = "[]" },
				["]"] = { action = "close", pair = "[]" },
				["{"] = { action = "open", pair = "{}" },
				["}"] = { action = "close", pair = "{}" },
				['"'] = { action = "closeopen", pair = '""' },
				["'"] = { action = "closeopen", pair = "''" },
				["`"] = { action = "closeopen", pair = "``" },
			},
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- Don't autopair inside Treesitter string nodes
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		})
	end,
}
