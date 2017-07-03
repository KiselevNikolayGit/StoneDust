-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: Creative Commons 4.0
-- -- StoneDust
-- Version: 0.2.1.2

function love.load( )
	-- Savings
	contents, size = love.filesystem.read("settings.stone")
	if size ~= 9 then
		contents = "1+1+1+1+0"
		love.filesystem.write("settings.stone", contents)
		values = split(contents, "+")
	else
		values = split(contents, "+")
	end
	-- Window
	love.window.setFullscreen(bln(values)[3])
	love.window.setTitle("StoneDust")
	w, h = love.window.getDesktopDimensions( )
	-- Graphic
	love.graphics.setColor(232, 234, 246)
	love.graphics.setBackgroundColor(121, 134, 203)
	font = love.graphics.newFont("data/Pacifico-Regular.ttf", 30)
	love.graphics.setFont(font)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("smooth")
	-- Buttons
	buttons = { }
	names = {"Contine", "New game", "Options", contents}
	for num = 0, #names do
		buttons[num] = { }
		buttons[num].text = love.graphics.newText(font, names[num])
		buttons[num].x = 200
		buttons[num].y = 75 * num
		buttons[num].w = buttons[num].text:getWidth()
		buttons[num].h = buttons[num].text:getHeight()
	end
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

function isbutton(x, y)
	-- Buttons actions
	for bn, b in pairs(buttons) do
		local svx = b.x - (b.w / 2) - 10
		local svy = b.y - (b.h / 2)
		local evx = svx + b.w + 20
		local evy = svy + b.h
		if x >= svx and x <= evx and y >= svy and y <= evy then
			if bn == 1 then
				-- body
			elseif bn == 2 then
				love.load = nil
				love.update = nil
				love.draw = nil
				values = nil
				chunk = love.filesystem.load("lvl1.lua")
				chunk( )
			elseif bn == 3 then
				love.load = nil
				love.update = nil
				love.draw = nil
				values = nil
				chunk = love.filesystem.load("opt.lua")
				chunk( )
			end
		end
	end
end

love.load( )

function love.update( )
	-- Exit
	if love.keyboard.isDown("escape") then
		love.window.close( )
	end
	-- Catch mouse
	if love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition( )
		isbutton(x, y)
	end
	-- Catch fingers
	local touches = love.touch.getTouches( )
	for i, id in ipairs(touches) do
		local x, y = love.touch.getPosition(id)
		isbutton(x, y)
	end
end

love.update( )

function love.draw( )
	for butnum, but in pairs(buttons) do
		-- Draw buttons
		love.graphics.rectangle("line", but.x - (but.w / 2) - 10, but.y - (but.h / 2), but.w + 20, but.h)
		love.graphics.draw(but.text, but.x, but.y, 0, 0.75, 0.75, but.w / 2, but.h / 2)
	end
end


love.draw( )