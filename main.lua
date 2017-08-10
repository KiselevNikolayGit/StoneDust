-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 0.4.0.0

sec = 0
colors = {
	{159, 168, 218},
	{92, 107, 192},
	{63, 81, 181},
	{255, 112, 67},
	{102, 187, 106}
}
fur = {w = 1500, h = 750}
stars = {}
for i = 1, 1000 do
	stars[i] = {love.math.random(0, fur.w * 3), love.math.random(-fur.h * 3, fur.h)}
end

function love.load()
	love.window.setMode(1200, 600, {borderless = true, fullscreen = true})
	love.graphics.setBackgroundColor(colors[3])
	if love.filesystem.exists("main.ttf") then
		local aqua = love.graphics.newFont("main.ttf", 120)
		love.graphics.setFont(aqua)
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
			side = h / s - fur.h
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
			side = w / s - fur.w
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
end

function love.wheelmoved(x, y)
	love.event.quit()
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = x / w
	y = y / h
	if x < 0.6 then
		if y < 0.6 then
			love.filesystem.load("start.lua")()
		elseif y < 0.8 then
			options()
		else
			love.event.quit()
		end
	end
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

function love.update(dt)
	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		for i = 1, #stars do
			local old = stars[i]
			 stars[i] = {old[1] + (love.math.random(-20, 20) / 50) - 0.2, old[2] + (love.math.random(-20, 20) / 50) + 0.5}
		end
	end
end

function love.draw()
	love.graphics.scale(s, s)
	love.graphics.translate(t[1], t[2])
	love.graphics.setLineStyle("smooth")
	love.graphics.print(tostring(love.timer.getFPS()), 5, 5, 0, 0.2, 0.2)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
		love.graphics.circle("fill", stars[i][1], stars[i][2], 1)
	end
	love.graphics.print("Stone dust", 70, 190, math.rad(-8))
	love.graphics.print("Start Game", 170, 380, math.rad(-7), 0.75, 0.75)
	love.graphics.print("Options", 340, 520, math.rad(-6), 0.5, 0.5)
	love.graphics.print("Exit", 410, 630, math.rad(-5), 0.4, 0.4)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end

function options()
	love.window.showMessageBox("Sory", "Settings not is not in not ALPHA VER")
end