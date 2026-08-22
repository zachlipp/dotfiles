-- Add the word under the cursor to the Vale accept list.
local M = {}

-- Insert your voice here
local accept_path = vim.fn.expand("~/styles/config/vocabularies/my_voice/accept.txt")

-- Prefer the exact span Vale flagged; fall back to <cword>.
function M.flagged_word()
	local pos = vim.api.nvim_win_get_cursor(0)
	local lnum, col = pos[1] - 1, pos[2]

	local hit
	for _, d in ipairs(vim.diagnostic.get(0, { lnum = lnum })) do
		local end_col = d.end_col or (d.col + 1)
		if col >= d.col and col < end_col then
			-- a vale diagnostic wins over anything else under the cursor
			if not hit or d.source == "vale" then
				hit = d
			end
		end
	end

	if hit then
		local ok, text = pcall(
			vim.api.nvim_buf_get_text,
			0,
			hit.lnum,
			hit.col,
			hit.end_lnum or hit.lnum,
			hit.end_col or (hit.col + 1),
			{}
		)
		if ok and text[1] and text[1] ~= "" then
			return table.concat(text, " ")
		end
	end

	return vim.fn.expand("<cword>")
end

local function accepted_words()
	local words = {}
	local f = io.open(accept_path, "r")
	if not f then
		return words
	end
	for line in f:lines() do
		words[#words + 1] = line
	end
	f:close()
	return words
end

-- Vale re-reads the vocabulary on every run, so accepting a word only needs a re-lint.
local function relint()
	local ok, client = pcall(require, "null-ls.client")
	if not ok then
		return
	end
	local methods = require("null-ls.methods")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
			client.notify_client(methods.lsp.DID_OPEN, {
				textDocument = { uri = vim.uri_from_bufnr(buf) },
			})
		end
	end
end

local function accept(word)
	word = vim.trim(word)
	if word == "" then
		return
	end

	local existing = accepted_words()
	for _, w in ipairs(existing) do
		if w == word then
			vim.notify(("%q is already accepted"):format(word), vim.log.levels.INFO)
			return
		end
	end

	local f, err = io.open(accept_path, "a")
	if not f then
		vim.notify("Could not open " .. accept_path .. ": " .. tostring(err), vim.log.levels.ERROR)
		return
	end
	-- guard against a file that does not end in a newline
	local needs_newline = #existing > 0 and vim.fn.getfsize(accept_path) > 0
	if needs_newline then
		local last = io.open(accept_path, "r"):read("*a"):sub(-1)
		if last ~= "\n" then
			f:write("\n")
		end
	end
	f:write(word .. "\n")
	f:close()

	relint()
	vim.notify(("Added %q to the Vale vocabulary"):format(word), vim.log.levels.INFO)
end

-- Small floating prompt, pre-filled and editable.
local function prompt(default, on_confirm)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })

	local width = math.max(30, #default + 10)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = width,
		height = 1,
		style = "minimal",
		border = "rounded",
		title = " Accept word ",
		title_pos = "center",
	})
	vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

	local done = false
	local function close(confirm)
		if done then
			return
		end
		done = true
		local text = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if confirm then
			on_confirm(text)
		end
	end

	local map = function(mode, lhs, confirm)
		vim.keymap.set(mode, lhs, function()
			close(confirm)
		end, { buffer = buf, nowait = true, silent = true })
	end

	map({ "i", "n" }, "<CR>", true)
	map({ "i", "n" }, "<Esc>", false)
	map("n", "q", false)

	vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
		buffer = buf,
		once = true,
		callback = function()
			close(false)
		end,
	})

	-- start in insert at end of line so the word is ready to edit or accept
	vim.cmd("startinsert!")
end

function M.accept_word()
	local word = M.flagged_word()
	if word == "" then
		vim.notify("No word under the cursor", vim.log.levels.WARN)
		return
	end
	prompt(word, accept)
end

vim.keymap.set("n", "<leader>j", M.accept_word, { desc = "Vale: accept word under cursor" })

return M
