-- Essentials
local vim = vim
vim.opt.clipboard = "unnamedplus"

-- Plugins
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("benlubas/molten-nvim")
vim.call("plug#end")

-- Molten helpers
local function create_jupyter_kernel(kernel)
	-- TODO: Handle errors with vim.v.shell_error
	-- TODO: This recreates kernel.json each time.
	--       That's probably inefficient, but it's only
	--       15 lines of JSON
	--       ¯\_(ツ)_/¯
	-- Relies on upstream control flow to ensure we're in a venv
	vim.fn.system(("python -m ipykernel install --name %s"):format(kernel))
end

local function find_missing_dependencies(pkgs)
	local missing = {}
	for i, v in pairs(pkgs) do
		-- Assumes using uv
		vim.fn.system(("uv pip show %s"):format(v))
		if vim.v.shell_error ~= 0 then
			table.insert(missing, v)
		end
	end
	return missing
end

-- mi: MoltenInit
-- Includes some helpers to make sure you are setup for success
-- You bring: A uv venv with dependencies installed
-- You get: A jupyter kernel, code execution
vim.keymap.set("n", "<localleader>mi", function()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv ~= nil then
		local python_deps = { "pynvim", "jupyter_client", "ipykernel" }
		local missing = find_missing_dependencies(python_deps)
		if #missing > 0 then
			local deps = table.concat(missing, ", ")
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

-- m: Run cell between delimiters
-- "m" is convenient if you change your leader to ,
vim.keymap.set("n", "<localleader>m", function()
	local cell_delimiter = "# ---"
	local start_row_raw = vim.fn.search(cell_delimiter, "Wb")
	if start_row_raw == 0 then
		print(("No previous occurrence of '%s' found"):format(cell_delimiter))
		return
	end
	local end_row_raw = vim.fn.search(cell_delimiter, "W")
	if end_row_raw == 0 then
		print(("No next occurrence of '%s' found"):format(cell_delimiter))
		return
	end
	local start_row = start_row_raw + 1
	local end_row = end_row_raw - 1
	vim.fn.MoltenEvaluateRange(start_row, end_row)
	vim.api.nvim_win_set_cursor(0, { start_row, 0 })
	vim.cmd.MoltenShowOutput()
end, { desc = "Execute cells", noremap = true, silent = false })
