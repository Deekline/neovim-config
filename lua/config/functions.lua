local M = {}

local api = vim.api
local keymap = vim.keymap

local function cmd_string(cmd_arg)
	return [[<cmd>]] .. cmd_arg .. [[<cr>]]
end

local function str_to_tbl(v)
	if type(v) == "string" then
		v = { v }
	end
	return v
end

function M.key_map(lhs, rhs, modes, opts)
	modes = str_to_tbl(modes) or { "n" }
	opts = opts or { silent = true, noremap = true }
	for _, mode in ipairs(modes) do
		keymap.set(mode, lhs, rhs, opts)
	end
end

function M.lazy_map(lhs, rhs, modes, opts)
	opts = opts or {}
	local desc = opts["desc"] or ""
	if type(rhs) == "string" then
		rhs = cmd_string(rhs)
	end
	if type(modes) ~= "string" or #modes == 0 then
		modes = { "n" }
	else
		modes = str_to_tbl(modes)
	end
	return {
		lhs,
		rhs,
		mode = modes,
		desc = desc,
	}
end

function M.create_augroup(group, opts)
	opts = opts or { clear = true }
	return api.nvim_create_augroup(group, opts)
end

function M.create_cmd(command, f, opts)
	opts = opts or {}
	api.nvim_create_user_command(command, f, opts)
end

function M.deep_copy(orig)
	local t = type(orig)
	local copy
	if t == "table" then
		copy = {}
		for k, v in pairs(orig) do
			copy[k] = M.deep_copy(v)
		end
	else
		copy = orig
	end
	return copy
end

return M
