text = "Upgrade!\n30 points"

stns = {
	"-4-2-1-402-505-304030105-404-502",
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

map = {metamet[1]*9+200, metamet[2]*9+200, metamet[3]*9+200, metamet[4]*9+200, metamet[5]*9+200, metamet[6]*9+200, metamet[7]*9+200, metamet[8]*9+200, metamet[9]*9+200, metamet[10]*9+200, metamet[11]*9+200, metamet[12]*9+200, metamet[13]*9+200, metamet[14]*9+200, metamet[15]*9+200, metamet[16]*9+200}

stars = {}
for i = 1, 230 do
	stars[i] = {love.math.random(0, fur.w), love.math.random(0, fur.h)}
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if y > 0.7 and x < 0.5 then
		love.filesystem.load("main.lua")()
	elseif score > 30 then
		if stns[lvl+1] ~= nil then
			score = score - 30
			lvl = lvl + 1
			love.filesystem.write("stndst.i", score)
			love.filesystem.write("lvl.i", lvl)
			love.filesystem.write("met.i", stns[lvl])
			protomet = love.filesystem.read("met.i")
			metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
			map = {metamet[1]*9+200, metamet[2]*9+200, metamet[3]*9+200, metamet[4]*9+200, metamet[5]*9+200, metamet[6]*9+200, metamet[7]*9+200, metamet[8]*9+200, metamet[9]*9+200, metamet[10]*9+200, metamet[11]*9+200, metamet[12]*9+200, metamet[13]*9+200, metamet[14]*9+200, metamet[15]*9+200, metamet[16]*9+200}
			text = "You Upgraded!\nNext: 30 points"
		else
			text = "Max lvl!\nCongrats!"
		end
	else
		text = "You have not\n30 points"
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
	love.graphics.print(tostring(score), 1400, 0)
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
	love.graphics.print("._.", 200, 200, 0.3, 1, 1, 3, 80)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end
