local function create_jupyter_kernel(kernel)
	-- TODO: Handle errors with vim.v.shell_error
	-- TODO: This recreates kernel.json each time.
	--       That's probably inefficient, but it's only
	--       15 lines of JSON
	--       ¯\_(ツ)_/¯
	vim.fn.system(("python -m ipykernel install --name %s"):format(kernel))
end

local function venv_has_required_packages(pkgs)
	local exit_code = 0
	for i, v in pairs(pkgs) do
		vim.fn.system(("uv pip show %s"):format(v))
		exit_code = exit_code + vim.v.shell_error
	end
	return exit_code == 0
end

-- local function use_uv_venv()
--   -- TODO: Assumes you are at the root of the project /
--   --       in the directory where the venv is located
--   local venv_defined = exists(".venv")
--   if venv then
--     vim.fn.system("source .venv/bin/activate")
--   else
--     vim.fn.system("uv venv")
--     vim.fn.system("source .venv/bin/activate")
--   end
-- end

-- Use kernel matching virtualenv
vim.keymap.set("n", "<localleader>mi", function()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv ~= nil then
		local python_deps = { "pynvim", "jupyter_client", "ipykernel" }
		local has_deps = venv_has_required_packages(python_deps)
		if not has_deps then
			local deps = table.concat(python_deps, ", ")
			print(("Must install python dependencies %s"):format(deps))
		else
			-- format /some/path/to/kernel-name/.venv
			-- used by uv
			kernel = string.match(venv, ".+/(.+)/.+")
			create_jupyter_kernel(kernel)
			vim.cmd(("MoltenInit %s"):format(kernel))
		end
	else
		print("Must be in virtual environment to use molten")
	end
end, { desc = "Initialize Molten for python3", silent = true })

-- Execute cells between delimiters
local function create_cell_between_delimiters()
	local bufnr = 0
	local ns_id = vim.api.nvim_create_namespace("molten")

	local start_row_raw = vim.fn.search("# ---", "Wb")
	if past_row == 0 then
		print("No previous occurrence of '# ---' found")
		return
	end
	local end_row_raw = vim.fn.search("# ---", "W")
	if end_row_raw == 0 then
		print("No next occurrence of '# ---' found")
		return
	end
	local start_row = start_row_raw + 1
	local end_row = end_row_raw - 1
	vim.fn.MoltenEvaluateRange(start_row, end_row)
	vim.api.nvim_win_set_cursor(0, { start_row, 0 })
	vim.cmd.MoltenShowOutput()
end
_G.create_cell_between_delimiters = create_cell_between_delimiters

vim.api.nvim_set_keymap(
	"n",
	"<leader>m",
	":<C-u>lua create_cell_between_delimiters()<CR>",
	{ noremap = true, silent = false }
)

return {
	"benlubas/molten-nvim",
	config = config,
	dependencies = {
		"3rd/image.nvim",
	},
}
