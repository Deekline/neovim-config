local fns= require('config/functions');
local m = fns.lazy_map
local create_cmd = fns.create_cmd

local base_file_ignore_patterns = { "node_modules", "\\.git" }

local function get_ignore_patterns()
	local patterns = require("neoconf").get("telescope.defaults.file_ignore_patterns")
	local ignore_patterns = fns.deep_copy(base_file_ignore_patterns)
	if not patterns or not vim.islist(patterns) then
		return ignore_patterns
	end
	for _, p in ipairs(patterns) do
		table.insert(ignore_patterns, p)
	end
	return ignore_patterns
end

local config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	telescope.setup({
		defaults = {
			prompt_prefix = "> ",
			selection_caret = " ",
			path_display = { truncate = 2 },
			ripgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			dynamic_preview_title = true,
			initial_mode = "insert",
			selection_strategy = "closest",
			sorting_strategy = "descending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "bottom",
					preview_width = 0.35,
					results_width = 0.65,
				},
				vertical = {
					mirror = false,
				},
				width = 0.9,
				height = 0.9,
				preview_cutoff = 120,
			},
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			file_ignore_patterns = base_file_ignore_patterns,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			--winblend = 2,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" },
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["<CR>"] = actions.select_default,
					["<C-s>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,
					["<C-f>"] = actions.preview_scrolling_up,
					["<C-b>"] = actions.preview_scrolling_down,
					["<C-u>"] = actions.results_scrolling_up,
					["<C-d>"] = actions.results_scrolling_down,
					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
					["<C-l>"] = actions.complete_tag,
					["<C-/>"] = actions.which_key,
				},
				n = {
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default,
					["<C-s>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,
					["<C-f>"] = actions.preview_scrolling_up,
					["<C-b>"] = actions.preview_scrolling_down,
					["<C-u>"] = actions.results_scrolling_up,
					["<C-d>"] = actions.results_scrolling_down,
					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["H"] = actions.move_to_top,
					["M"] = actions.move_to_middle,
					["L"] = actions.move_to_bottom,
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,
					["?"] = actions.which_key,
				},
			},
		},
		pickers = {
			help_tags = {
				mappings = {
					i = {
						["<CR>"] = actions.select_tab,
						["<S-CR>"] = actions.select_default,
					},
					n = {
						["<CR>"] = actions.select_tab,
						["<S-CR>"] = actions.select_default,
					},
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					winblend = 2,
				}),
			},
			lazy = {
				theme = "ivy",
				show_icon = true,
				mappings = {
					open_in_browser = "<C-o>",
					open_in_file_browser = "<M-b>",
					open_in_find_files = "<C-f>",
					open_in_live_grep = "<C-g>",
					open_plugins_picker = "<C-b>",
					open_lazy_root_find_files = "<C-r>f",
					open_lazy_root_live_grep = "<C-r>g",
				},
			},
		},
	})

	local extensions = {
		"fzf",
		"ui-select",
		"lazy",
	}

	for e in ipairs(extensions) do
		telescope.load_extension(extensions[e])
	end
end

--  TODO: 2024-03-26 - How to handle multiple local projects?
local keys = {
	m("<leader>fk", [[Telescope keymaps]], {}, { desc = "Find keymaps" }),
	m("<leader>ft", [[Telescope help_tags]], {}, { desc = "Find help_tags" }),
	m("<leader>ff", [[TelescopeFindFilesPreview]], {}, { desc = "Find Files Preview" }),
	m("<leader>fj", [[Telescope live_grep]], {}, { desc = "Find with grep" }),
	m("<leader>fJ", [[TelescopeLiveGrepHidden]], {}, { desc = "Find with grep hidden" }),
	m("<leader>fe", [[TelescopeFindFilesNoIgnore]], {}, { desc = "Find Files No Ignore" }),
	m("<leader>fb", [[Telescope buffers]], {}, { desc = "Telescope buffers" }),
	m("<leader>fg", [[Telescope git_status]], {}, { desc = "Telescope git status" }),
	m("<leader>fa", [[Telescope autocommands]], {}, { desc = "Telescope autocommands" }),
	m("<leader>fh", [[Telescope highlights]], {}, { desc = "Telescope highlights" }),
}

local dependencies = {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	"ThePrimeagen/harpoon",
	"tsakirist/telescope-lazy.nvim",
	"folke/neoconf.nvim",
}

return {
	"nvim-telescope/telescope.nvim",
	config = config,
	init = function()
		create_cmd("TelescopeFindFiles", function()
			require("telescope.builtin").find_files({
				file_ignore_patterns = get_ignore_patterns(),
				layout_strategy = "vertical",
				layout_config = {
					width = 0.5,
					height = 0.50,
					vertical = {
						prompt_position = "bottom",
					},
				},
			})
		end)
		create_cmd("TelescopeFindFilesPreview", function()
			require("telescope.builtin").find_files({
				file_ignore_patterns = get_ignore_patterns(),
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						preview_width = 0.65,
						results_width = 0.35,
					},
				},
			})
		end)
		create_cmd("TelescopeFindFilesNoIgnore", function()
			require("telescope.builtin").fd({
				no_ignore = true,
				hidden = true,
			})
		end)
		create_cmd("TelescopeFindFilesCWD", function()
			require("telescope.builtin").fd({
				search_dirs = {
					vim.fn.expand("%:h"),
				},
			})
		end)
		create_cmd("TelescopeLiveGrepHidden", function()
			require("telescope.builtin").live_grep({
				additional_args = { "--ignore" },
			})
		end)
	end,
	cmd = "Telescope",
	keys = keys,
	dependencies = dependencies,
}
