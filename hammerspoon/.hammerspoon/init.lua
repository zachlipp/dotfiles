local ghosttyDir = os.getenv("HOME") .. "/.config/ghostty"

-- Find the exact name by running in Hammerspoon console:
-- print(hs.inspect(hs.screen.allScreens())
local EXTERNAL_MONITORS = { "DELL", "XV271U", "LG" }

local function externalConnected()
	for _, screen in ipairs(hs.screen.allScreens()) do
		local name = screen:name()
		if name then
			name = name:lower()
			for _, monitor in ipairs(EXTERNAL_MONITORS) do
				if name:find(monitor:lower(), 1, true) then
					return true
				end
			end
		end
	end
	return false
end

local currentMode = nil

local function applyTheme()
	local wantLight = externalConnected()
	local mode = wantLight and "light" or "dark"
	if mode == currentMode then
		return
	end
	currentMode = mode

	local target = wantLight and "theme-light" or "theme-dark"
	hs.execute(string.format("ln -sf %s %s/theme-active", target, ghosttyDir))
	-- Write mode to file for neovim
	local f = io.open(os.getenv("HOME") .. "/.config/theme-mode", "w")
	if f then
		f:write(mode)
		f:close()
	end

	hs.execute("/usr/bin/pkill -USR2 ghostty")
end

-- Watch for display changes
screenWatcher = hs.screen.watcher.new(applyTheme)
screenWatcher:start()

-- Apply once on load
applyTheme()

hs.alert.show("Ghostty theme watcher loaded")

-- Automatically reload config
configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
