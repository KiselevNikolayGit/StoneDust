-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: Creative Commons 4.0
-- -- StoneDust
-- Version: 0.2.1.2

loaded = false
updated = false

function love.load( )
	-- Load settings
	contents = love.filesystem.read("settings.stone")
	values = split(contents, "+")
	-- Window
	love.window.setFullscreen(bln(values)[3])
	love.window.setTitle("StoneDust")
	w, h = love.window.getDesktopDimensions( )
	-- Graphic
	love.graphics.setBackgroundColor(121, 134, 203)
	font = love.graphics.newFont("data/Pacifico-Regular.ttf", 30)
	love.graphics.setFont(font)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("smooth")
	-- Switchers
	switchers = { }
	names = {"Volume", "Music", "Subtitles", "Fullscreen", "Russian", tostring(values[3])}
	for num = 0, #names do
		switchers[num] = { }
		switchers[num].text = love.graphics.newText(font, names[num])
		switchers[num].x = 200
		switchers[num].y = 75 * num
		switchers[num].w = switchers[num].text:getWidth()
		switchers[num].h = switchers[num].text:getHeight()
		switchers[num].t = {232, 234, 246}
		switchers[num].f = {232 - 60, 234 - 60, 246 - 20}
		if values[num] == "1" then
			switchers[num].c = switchers[num].t
		else
			switchers[num].c = switchers[num].f
		end
	end
	-- Open Gate
	gate = { }
	gate.port = -1
	gate.time = love.timer.getTime( )
	-- Chunk mark
	loaded = true
end

function split(inputstr, sep)
	if sep == nil then
		sep = ""
	end
	local t={ }; i=1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function join(table, sep)
	local strop = ""
	local thesep = ""
	for i, item in pairs(table) do
		strop = strop .. thesep
		strop = strop .. item
		thesep = sep
	end
	return strop
end

function bln(values)
	local t = { }
	for i = 0, #values do
		if values[i] == "1" then
			t[i] = true
		elseif values[i] == "0" then
			t[i] = false
		end
	end
	return t
end

function isswitch(x, y)
	-- Switchers actions
	for swtnum, swt in pairs(switchers) do
		sx = swt.x - (swt.w / 2) - 10
		sy = swt.y - (swt.h / 2)
		ex = sx + swt.w + 20
		ey = sy + swt.h
		if x >= sx and x <= ex and y >= sy and y <= ey and (gate.port ~= swtnum or gate.time + 0.3 <= love.timer.getTime( )) then
			if swtnum ~= 6 then
				gate.port = swtnum
				gate.time = love.timer.getTime( )
				if values[swtnum] == "1" then
					swt.c = swt.f
					values[swtnum] = "0"
					love.filesystem.write("settings.stone", join(values, "+"))
				else
					swt.c = swt.t
					values[swtnum] = "1"
					love.filesystem.write("settings.stone", join(values, "+"))
				end
			else
				dofile("main.lua")
			end
		end
	end
end

function love.update( )
	if loaded then
		-- Exit
		if love.keyboard.isDown("b") then
			dofile("main.lua")
		end
		-- Catch mouse
		if love.mouse.isDown(1) then
			local x, y = love.mouse.getPosition( )
			isswitch(x, y)
		end
		-- Catch fingers
		local touches = love.touch.getTouches( )
		for i, id in ipairs(touches) do
			local x, y = love.touch.getPosition(id)
			isswitch(x, y)
		end
		-- Chunk mark
		updated = true
	end
end

function love.draw( )
	if updated then
		-- Draw switchers
		for swtnum, swt in pairs(switchers) do
			love.graphics.setColor(swt.c)
			love.graphics.rectangle("line", swt.x - (swt.w / 2) - 10, swt.y - (swt.h / 2), swt.w + 20, swt.h)
			love.graphics.draw(swt.text, swt.x, swt.y, 0, 0.75, 0.75, swt.w / 2, swt.h / 2)
		end
	end
end

love.load( )
