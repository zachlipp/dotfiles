return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "ConformInfo",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "jq" },
			terraform = { "terraform_fmt" },
			go = { "goimports", "gofmt" },
			c = { "clang-format" },
			-- Prevents regressions from trailing whitespace in multiline string
			yaml = { "trim_whitespace", "yamlfmt" },
			sql = { "sqlformat" },
			gdscript = { "gdformat" },
			["*"] = { "trim_whitespace" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
		},
	},
}
