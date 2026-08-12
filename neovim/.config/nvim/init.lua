local vim = vim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Must be set before lazy loads so plugin mappings pick them up.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "nord" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

require("vale")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Used by hammerspoon to configure themes
local function read_mode()
	local f = io.open(vim.fn.expand("~/.config/theme-mode"), "r")
	if not f then
		return "dark"
	end
	local mode = f:read("*l")
	f:close()
	return mode == "light" and "light" or "dark"
end
vim.o.background = read_mode()
vim.cmd.colorscheme(vim.o.background == "light" and "dayfox" or "nordfox")

-- Mad scientist stuff to compile C in a Docker container on file save
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.fn.expand("~") .. "/git/systems_programming_class/**.c",
	callback = function()
		vim.cmd("rightbelow vsplit")
		-- swap to Docker
		-- vim.cmd("terminal gcc % -o %:r && %:r")
		-- See https://stackoverflow.com/a/36501915
		local currdir = vim.fn.expand("%:.:h")
		local filename_without_extension = vim.fn.expand("%:t:r")
		local build_dir = "out"
		local build_path = currdir .. "/" .. build_dir .. "/" .. filename_without_extension
		vim.cmd("terminal docker exec -t -w /home compiler make test" .. build_path .. " && " .. build_path .. "'")
		vim.schedule(function()
			vim.cmd("wincmd w")
			vim.cmd("startinsert")
		end)
	end,
})
