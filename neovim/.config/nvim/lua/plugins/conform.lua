return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			javascript = { "prettier" },
			terraform = { "terraform_fmt" },
			go = { "goimports", "gofmt" },
			yaml = { "prettier" },
			sql = { "sqlformat" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
		},
	},
}
