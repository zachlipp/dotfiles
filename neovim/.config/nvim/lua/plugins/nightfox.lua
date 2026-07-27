return {
	"EdenEast/nightfox.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		-- also set in init.lua to swap between light/dark
		-- on external monitor connection (thank you hammerspoon)
		vim.cmd([[colorscheme nordfox]])
	end,
}
