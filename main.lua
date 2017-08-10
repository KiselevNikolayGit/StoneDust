-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 0.5.2

sec = 0
colors = {
	{159, 168, 218},
	{92, 107, 192},
	{63, 81, 181},
	{255, 112, 67},
	{33, 150, 243}
}
fur = {w = 1500, h = 750}
met = {-4*30+1100, -2*30+400, -1*30+1100, -4*30+400, 2*30+1100, -5*30+400, 5*30+1100, -3*30+400, 4*30+1100, 3*30+400, 1*30+1100, 5*30+400, -4*30+1100, 4*30+400, -5*30+1100, 2*30+400}
stars = {}
for i = 1, 1000 do
	stars[i] = {love.math.random(0, fur.w * 3), love.math.random(-fur.h * 3, fur.h)}
end

function fit()
	local w, h = love.window.getMode()
	if w / fur.w < h / fur.h then
		s = w / fur.w
		t = {0, (h / s - fur.h) / 2}
	else
		s = h / fur.h
		t = {(w / s - fur.w) / 2, 0}
	end
end

love.window.setMode(1200, 600, {borderless = true, fullscreen = true})
love.window.setPosition(0, 0)
love.graphics.setBackgroundColor(colors[3])
if love.filesystem.exists("main.ttf") then
	aqua = {
		love.graphics.newFont("main.ttf", 170),
		love.graphics.newFont("main.ttf", 170 * 0.75),
		love.graphics.newFont("main.ttf", 170 * 0.5),
		love.graphics.newFont("main.ttf", 170 * 0.4),
		love.graphics.newFont("main.ttf", 30)
	}
end
fit()
do --MESH
	backimg = love.graphics.newImage("bg.bmp")
	backimg:setWrap("repeat")
	backimg:setFilter("nearest")
	local w, h = love.window.getMode()
	local iw, ih = backimg:getDimensions()
	iw = iw / s
	ih = ih / s
	if w / fur.w < h / fur.h then
		side = t[2]
		fortouch = {0, side}
		meshp = {x1 = 0, y1 = -side, x2 = 0, y2 = fur.h}
		vertices = {
		{ -- top-left
			0, 0,
			0, 0,
			255, 255, 255},
		{ -- top-right
			fur.w, 0,
			fur.w / iw, 0,
			255, 255, 255},
		{ -- bottom-right
			fur.w, side,
			fur.w / iw, side / ih,
			255, 255, 255},
		{ -- bottom-left
			0, side,
			0, side / ih,
			255, 255, 255}
		}
	else
		side = t[1]
		fortouch = {side, 0}
		meshp = {x1 = -side, y1 = 0, x2 = fur.w, y2 = 0}
		vertices = {
		{ -- top-left
			0, 0,
			0, 0,
			255, 255, 255},
		{ -- top-right
			side, 0,
			side / iw, 0,
			255, 255, 255},
		{ -- bottom-right
			side, fur.h,
			side / iw, fur.h / ih,
			255, 255, 255},
		{ -- bottom-left
			0, fur.h,
			0, fur.h / ih,
			255, 255, 255}
		}
	end
	mesh = love.graphics.newMesh(vertices, "fan")
	mesh:setTexture(backimg)
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if x < 0.7 and y > 0 then
		if y < 0.6 then
			love.filesystem.load("start.lua")()
		elseif y < 0.8 then
			options()
		elseif y < 1 then
			love.event.quit()
		end
	end
end

function love.update(dt)
	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		for i = 1, #stars do
			local old = stars[i]
			stars[i] = {old[1] + (love.math.random(-20, 20) / 50) - 0.2, old[2] + (love.math.random(-20, 20) / 50) + 0.5}
		end
		for i = 1, #met / 2 do
			local old = met[i * 2 - 1]
			met[i * 2 - 1] = old + (love.math.random(-20, 20) / 20) - 0.2
			local old = met[i * 2]
			met[i * 2] = old + (love.math.random(-20, 20) / 20) + 0.5
		end
	end
end

function love.draw()
	love.graphics.scale(s, s)
	love.graphics.translate(t[1], t[2])
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)	
	love.graphics.setColor(255, 255, 255, 200)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
	end
	love.graphics.setColor(255, 255, 255, 50)
	love.graphics.setLineWidth(3)
	for i = 1, #met / 2 do
		love.graphics.circle("line", met[i * 2 - 1], met[i * 2], 1)
	end
	love.graphics.setLineWidth(1)
	love.graphics.polygon("line", met)
	love.graphics.setColor(colors[1])
	love.graphics.setFont(aqua[1])
	love.graphics.print("Stone Dust", 30, 110, math.rad(-8))
	love.graphics.setFont(aqua[2])
	love.graphics.print("Start game", 170, 300, math.rad(-7))
	love.graphics.setFont(aqua[3])
	love.graphics.print("Options", 340, 440, math.rad(-6))
	love.graphics.setFont(aqua[4])
	love.graphics.print("Exit", 410, 570, math.rad(-5))
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end

function options()
	love.window.showMessageBox("Sory", "Settings not is not in not ALPHA VER")
end

function pause()
	local screen = love.draw
	local mousen = love.mousepressed
	local updatn = love.update
	local met = {-4*30+1100, -2*30+400, -1*30+1100, -4*30+400, 2*30+1100, -5*30+400, 5*30+1100, -3*30+400, 4*30+1100, 3*30+400, 1*30+1100, 5*30+400, -4*30+1100, 4*30+400, -5*30+1100, 2*30+400}
	local stars = {}
	for i = 1, 1000 do
		stars[i] = {love.math.random(0, fur.w * 3), love.math.random(-fur.h * 3, fur.h)}
	end
	function love.update(dt)
		sec = sec + dt
		if sec > 0.05 then
			sec = 0
			for i = 1, #stars do
				local old = stars[i]
				stars[i] = {old[1] + (love.math.random(-20, 20) / 50) - 0.2, old[2] + (love.math.random(-20, 20) / 50) + 0.5}
			end
			for i = 1, #met / 2 do
				local old = met[i * 2 - 1]
				met[i * 2 - 1] = old + (love.math.random(-20, 20) / 20) - 0.2
				local old = met[i * 2]
				met[i * 2] = old + (love.math.random(-20, 20) / 20) + 0.5
			end
		end
	end
	function love.mousepressed(x, y)
		local w, h = love.window.getMode()
		x = (x - (fortouch[1] * s)) / (fur.w * s)
		y = (y - (fortouch[2] * s)) / (fur.h * s)
		if x < 0.7 and y > 0 then
			if y < 0.6 then
				love.draw = screen
				love.mousepressed = mousen
				love.update = updatn
			elseif y < 0.8 then
				options()
			elseif y < 1 then
				dofile("main.lua")
			end
		end
	end
	function love.draw()
		love.graphics.scale(s, s)
		love.graphics.translate(t[1], t[2])
		love.graphics.setLineStyle("smooth")
		love.graphics.setLineWidth(1)	
		love.graphics.setColor(255, 255, 255, 200)
		for i = 1, #stars do
			love.graphics.circle("line", stars[i][1], stars[i][2], 1)
		end
		love.graphics.setColor(255, 255, 255, 50)
		love.graphics.setLineWidth(3)
		for i = 1, #met / 2 do
			love.graphics.circle("line", met[i * 2 - 1], met[i * 2], 1)
		end
		love.graphics.setLineWidth(1)
		love.graphics.polygon("line", met)
		love.graphics.setColor(colors[1])
		love.graphics.setFont(aqua[1])
		love.graphics.print("Star Pause", 10, 110, math.rad(-8))
		love.graphics.setFont(aqua[2])
		love.graphics.print("Resume game", 140, 300, math.rad(-7))
		love.graphics.setFont(aqua[3])
		love.graphics.print("Options", 340, 440, math.rad(-6))
		love.graphics.setFont(aqua[4])
		love.graphics.print("Exit", 410, 570, math.rad(-5))
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(mesh, meshp.x1, meshp.y1)
		love.graphics.draw(mesh, meshp.x2, meshp.y2)
	end
end