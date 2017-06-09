-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: Creative Commons 4.0
-- Version: 0.0.0.0

function love.load( )
	love.window.setFullscreen(false)
	love.window.setTitle("StoneDust")
	w, h = love.window.getDesktopDimensions( )

	love.graphics.setColor(232, 234, 246)
	love.graphics.setBackgroundColor(121, 134, 203)
	font = love.graphics.newFont("data/Pacifico-Regular.ttf", 30)
	love.graphics.setFont(font)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("smooth")

	buttons = { }
	names = {"Contine", "New game", "Options"}

	for num = 0, #names do
		buttons[num] = { }
		buttons[num].text = love.graphics.newText(font, names[num])
		buttons[num].x = 200
		buttons[num].y = 75 * num
		buttons[num].w = buttons[num].text:getWidth()
		buttons[num].h = buttons[num].text:getHeight()
	end
end

function love.update( )
	if love.keyboard.isDown("escape") then
		love.window.close( )
	end
	if love.mouse.isDown(1) then
		x, y = love.mouse.getPosition( )
		for butnum, but in pairs(buttons) do
			sx = but.x - (but.w / 2) - 10
			sy = but.y - (but.h / 2)
			ex = sx + but.w + 20
			ey = sy + but.h
			if x >= sx and x <= ex and y >= sy and y <= ey then
				if butnum == 1 then
					-- body
				elseif butnum == 2 then
					love.load = nil
					love.update = nil
					love.draw = nil
					chunk = love.filesystem.load("lvl1.lua")
					chunk( )
				end
			end
		end
	end
end

function love.draw( )
	for butnum, but in pairs(buttons) do
		love.graphics.rectangle("line", but.x - (but.w / 2) - 10, but.y - (but.h / 2), but.w + 20, but.h)
		love.graphics.draw(but.text, but.x, but.y, 0, 0.75, 0.75, but.w / 2, but.h / 2)
	end
end
