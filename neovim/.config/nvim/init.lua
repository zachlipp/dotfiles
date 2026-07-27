-- Essentials
local vim = vim
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Plugins
require("config.lazy")
require("config.lsp")

-- Setup lazy.nvim
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

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.api.nvim_set_keymap("n", "<leader>di", "VimspectorBalloonEval", { desc = "yo" })

--for normal mode - the word under the cursor
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
