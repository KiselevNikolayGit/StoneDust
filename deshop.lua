-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 2.1.57.4

stns = {
	"-5-3-2-503-606-505040206-504-602",
	"-3-2-1-403-505-304030105-404-502",
	"-5-2-1-403-505-304030205-404-502",
	"-5-3-1-402-505-304030105-404-602",
	"-5-3-2-503-606-405040206-505-603",
	"-4-3-1-403-505-304030105-404-503",
	"-3-2-1-302-505-303030105-303-502",
	"-4-2-1-402-505-304030105-404-502"
}

lvl = love.filesystem.read("lvl.i")
st = love.filesystem.read("stndst.i")
if st ~= nil then
	score = tonumber(st)
else
	score = 1
end

cost = 30 + (lvl * 45)
text = "Upgrade!\n"..tostring(cost).." points"

somx = 420
somy = 420
map = {metamet[1]*20+somx, metamet[2]*20+somy, metamet[3]*20+somx, metamet[4]*20+somy, metamet[5]*20+somx, metamet[6]*20+somy, metamet[7]*20+somx, metamet[8]*20+somy, metamet[9]*20+somx, metamet[10]*20+somy, metamet[11]*20+somx, metamet[12]*20+somy, metamet[13]*20+somx, metamet[14]*20+somy, metamet[15]*20+somx, metamet[16]*20+somy}
show = {}
for i, protomet in ipairs(stns) do
	local somx = 150 * i
	local somy = 100
	metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
	show[i] = {metamet[1]*9+somx, metamet[2]*9+somy, metamet[3]*9+somx, metamet[4]*9+somy, metamet[5]*9+somx, metamet[6]*9+somy, metamet[7]*9+somx, metamet[8]*9+somy, metamet[9]*9+somx, metamet[10]*9+somy, metamet[11]*9+somx, metamet[12]*9+somy, metamet[13]*9+somx, metamet[14]*9+somy, metamet[15]*9+somx, metamet[16]*9+somy}
end

stars = {}
for i = 1, 230 do
	stars[i] = {love.math.random(0, fur.w), love.math.random(0, fur.h)}
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if y < 0.3 then
		local x = x * 1.25
		local k = math.floor((x) * #stns + 0.5)
		if k <= tonumber(lvl) then
			if stns[k] ~= nil then
				love.filesystem.write("met.i", stns[k])
				protomet = love.filesystem.read("met.i")
				local somx = 420
				local somy = 420
				metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
				map = {metamet[1]*20+somx, metamet[2]*20+somy, metamet[3]*20+somx, metamet[4]*20+somy, metamet[5]*20+somx, metamet[6]*20+somy, metamet[7]*20+somx, metamet[8]*20+somy, metamet[9]*20+somx, metamet[10]*20+somy, metamet[11]*20+somx, metamet[12]*20+somy, metamet[13]*20+somx, metamet[14]*20+somy, metamet[15]*20+somx, metamet[16]*20+somy}
				text = "You been\nChanged!"
			end
		else
			text = "You can't\nChange!"		
		end
	elseif y > 0.7 and x < 0.5 then
		love.filesystem.load("main.lua")()
	elseif score > cost then
		if stns[lvl+1] ~= nil then
			score = score - cost
			lvl = lvl + 1
			love.filesystem.write("stndst.i", score)
			love.filesystem.write("lvl.i", lvl)
			love.filesystem.write("met.i", stns[lvl])
			protomet = love.filesystem.read("met.i")
			local somx = 420
			local somy = 420
			metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
			map = {metamet[1]*20+somx, metamet[2]*20+somy, metamet[3]*20+somx, metamet[4]*20+somy, metamet[5]*20+somx, metamet[6]*20+somy, metamet[7]*20+somx, metamet[8]*20+somy, metamet[9]*20+somx, metamet[10]*20+somy, metamet[11]*20+somx, metamet[12]*20+somy, metamet[13]*20+somx, metamet[14]*20+somy, metamet[15]*20+somx, metamet[16]*20+somy}
			text = "You Upgraded!\nNext: "..tostring(cost).." points"
		else
			text = "Max lvl!\nCongrats!"
		end
	else
		text = "You have not\n"..tostring(cost).." points"
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
	love.graphics.setLineWidth(5)
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", map)
	for i, ma in ipairs(show) do
		if i <= tonumber((lvl)) then
			love.graphics.polygon("line", ma)
		else
			love.graphics.print("?", 150 * i, 60)
			love.graphics.circle("line", 150 * i + 8, 100, 50)
		end
	end
	love.graphics.print("._.", 420, 420, 0.3, 1.6, 1.6, 0, 90)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end
