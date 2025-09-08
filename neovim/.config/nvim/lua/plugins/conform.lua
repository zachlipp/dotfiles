return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			javascript = { "prettier" },
			css = { "prettier" },
			terraform = { "terraform_fmt" },
			go = { "goimports", "gofmt" },
			-- TODO: Figure out helm
			-- yaml = { "prettier" },
			sql = { "sqlformat" },
			["*"] = { "trim_whitespace" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
		},
	},
}
