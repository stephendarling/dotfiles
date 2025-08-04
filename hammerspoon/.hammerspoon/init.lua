-- Keep a list of the two most recently focused windows
-- Subscribe to window focus events
windowHistory = {}
local hyper = { "ctrl", "alt", "cmd" }
local margin = 10

-- Hook into window focus changes
function trackWindowFocus(win)
	if not win or not win:id() then
		return
	end
	-- Remove duplicates
	for i, w in ipairs(windowHistory) do
		if w:id() == win:id() then
			table.remove(windowHistory, i)
			break
		end
	end
	-- Insert the newest at the front
	table.insert(windowHistory, 1, win)
	-- Limit to last 2
	if #windowHistory > 2 then
		table.remove(windowHistory, 3)
	end
end

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, trackWindowFocus)

function launchAndTile(appName, side)
	hs.application.launchOrFocus(appName)
	hs.timer.doAfter(0.1, function()
		local win = hs.application(appName):mainWindow()
		if not win then
			return
		end

		local screen = win:screen()
		local frame = screen:frame()
		local halfWidth = frame.w / 2
		local gap = margin / 2

		if side == "left" then
			win:setFrame({
				x = frame.x + gap,
				y = frame.y + margin,
				w = halfWidth - margin - gap,
				h = frame.h - (2 * margin),
			})
		elseif side == "right" then
			win:setFrame({
				x = frame.x + halfWidth + gap,
				y = frame.y + margin,
				w = halfWidth - margin - gap,
				h = frame.h - (2 * margin),
			})
		end
	end)
end

local margin = 10 -- pixels

hs.hotkey.bind(hyper, "l", function()
	local mainWin = hs.window.focusedWindow()
	if not mainWin then
		return
	end

	local screen = mainWin:screen()
	local frame = screen:frame()

	local halfWidth = frame.w / 2
	local gap = margin / 2

	-- Current window to right half
	mainWin:setFrame({
		x = frame.x + halfWidth + gap,
		y = frame.y + margin,
		w = halfWidth - margin - gap,
		h = frame.h - (2 * margin),
	})

	-- Previous window to left half
	local secondaryWin = windowHistory[2]
	if secondaryWin and secondaryWin:id() ~= mainWin:id() then
		secondaryWin:setFrame({
			x = frame.x + gap,
			y = frame.y + margin,
			w = halfWidth - margin - gap,
			h = frame.h - (2 * margin),
		})
	end
end)

hs.hotkey.bind(hyper, "h", function()
	local mainWin = hs.window.focusedWindow()
	if not mainWin then
		return
	end

	local screen = mainWin:screen()
	local frame = screen:frame()

	local halfWidth = frame.w / 2
	local gap = margin / 2

	-- Current window to left half
	mainWin:setFrame({
		x = frame.x + gap,
		y = frame.y + margin,
		w = halfWidth - margin - gap,
		h = frame.h - (2 * margin),
	})

	-- Previous window to right half
	local secondaryWin = windowHistory[2]
	if secondaryWin and secondaryWin:id() ~= mainWin:id() then
		secondaryWin:setFrame({
			x = frame.x + halfWidth + gap,
			y = frame.y + margin,
			w = halfWidth - margin - gap,
			h = frame.h - (2 * margin),
		})
	end
end)

hs.hotkey.bind(hyper, "e", function()
	launchAndTile("Safari", "left")
end)
