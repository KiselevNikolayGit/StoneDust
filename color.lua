-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 2.2.0.0

sascolors = {
    "#FF6E40",
    "#FFD740",
    "#B2FF59",
    "#69F0AE",
    "#76FF03",
    "#40C4FF",
    "#FF5252",
    "#FF4081"
}

local wid = fur.w / #sascolors

text = "Choose Your\nDust Color"

stars = {}
for i = 1, 230 do
	stars[i] = {love.math.random(0, fur.w), love.math.random(0, fur.h)}
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if y < 0.3 then
		x = math.floor(x * 8 + 1)
        love.filesystem.write("clr.i", sascolors[x])
        colors[4] = {hc(love.filesystem.read("clr.i"))}
        text = "Color Changed!"
	elseif y > 0.7 and x < 0.2 then
		love.filesystem.load("main.lua")()
	end
end

function love.update(dt)
	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		for i = 1, #stars do
			local old = stars[i]
			stars[i] = {old[1] + (love.math.random(-20, 20) / 21), old[2] + (love.math.random(-20, 20) / 21)}
		end
	end
end

function love.draw()
	love.graphics.scale(s, s)
	love.graphics.translate(t[1], t[2])
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)
	love.graphics.setColor(colors[1])
	love.graphics.setFont(aqua[4])
	love.graphics.print(tostring(score), 150, 200)
	love.graphics.print("Exit", 100, 600)
	love.graphics.print(text, 1000, 300)
	love.graphics.setFont(aqua[5])	
	love.graphics.setColor(255, 255, 255, 90)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
	end
    for i = 1, #sascolors do
        love.graphics.setColor({hc(sascolors[i])})
        love.graphics.rectangle("fill", 30 + (i - 1) * wid - 20, 0, wid - 20, 20)
    end
	love.graphics.setLineWidth(15)
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", map)
    love.graphics.print("._.", 420, 420, 0.3, 1.9, 1.9, 1, 85)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end
