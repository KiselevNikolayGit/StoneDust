bitso = love.audio.newSource("shot.wav", "static")
bitso:setLooping(true)
bitso:play()

st = love.filesystem.read("stndst.i")
if st ~= nil then
	score = tonumber(st)
else
	score = 1
end

love.graphics.setBackgroundColor(colors[3])
love.physics.setMeter(12)
love.graphics.setBackgroundColor(colors[2])
World = love.physics.newWorld(0, 420, true)
edge = {}
edge.b = love.physics.newBody(World, 0, 0, "static")
edge.s = love.physics.newChainShape(true, 0, -200, 0, fur.h, fur.w, fur.h, fur.w, -200)
edge.f = love.physics.newFixture(edge.b, edge.s)
power = 0
sms = 0
nowrock = 1
isnow = nowrock

met = {
	up = function()
		if power > 1 then
			met.b:applyForce(0, -400000)
			power = 0
		end
	end,
	rg = function()
		if power > 1 then
			met.b:applyForce( 300000, -400000)
			met.b:applyAngularImpulse(20000)
			power = 0
		end
	end,
	lf = function()
		if power > 1 then
			met.b:applyForce(-300000, -400000)
			met.b:applyAngularImpulse(-20000)
			power = 0
		end
	end
}

met.map = {metamet[1]*9, metamet[2]*9, metamet[3]*9, metamet[4]*9, metamet[5]*9, metamet[6]*9, metamet[7]*9, metamet[8]*9, metamet[9]*9, metamet[10]*9, metamet[11]*9, metamet[12]*9, metamet[13]*9, metamet[14]*9, metamet[15]*9, metamet[16]*9}
met.b = love.physics.newBody(World, 150, -165, "dynamic")
met.s = love.physics.newPolygonShape(met.map)
met.f = love.physics.newFixture(met.b, met.s)
met.f:setRestitution(0.3)

stars = {}
for i = 1, 230 do
	stars[i] = {love.math.random(0, fur.w), love.math.random(0, fur.h)}
end

rocks = {}
for i = 1, 5 do
	map = {}
	for j = 1, 31 do
		map[#map + 1] = 50 * (j - 1)
		map[#map + 1] = love.math.random(fur.h - 350, fur.h - 250) + ((i - 1) * 140)
	end
	rocks[i] = {}
	rocks[i].dow = {}
		rocks[i].dow.b = love.physics.newBody(World, love.math.random(29, 1479), fur.h - 370 + ((i - 1) * 140), "static")
		rocks[i].dow.s = love.physics.newCircleShape(10)
		rocks[i].dow.f = love.physics.newFixture(rocks[i].dow.b, rocks[i].dow.s)
	rocks[i].b = love.physics.newBody(World, 0, 0, "static")
	rocks[i].s = love.physics.newChainShape(false, map)
	rocks[i].f = love.physics.newFixture(rocks[i].b, rocks[i].s)
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if x < 0.1 and y < 0.1 then
		pause()
	elseif y < 0.5 then
		met.up()
	else
		if x < 0.5 then
			met.lf()
		else
			met.rg()
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		pause()
	elseif key == "up" then
		met.up()
	elseif key == "right" then
		met.rg()
	elseif key == "left" then
		met.lf()
	end
end

function love.update(dt)
	World:update(dt)
	if isnow ~= nowrock then
		isnow = nowrock
		score = score + 1
		love.filesystem.write("stndst.i", tostring(score))
		sms = 0
	end
	if sms < 14 then
		sms = sms + 1
		met.b:setY(met.b:getY() - 15)		
		for i = nowrock, #rocks do
			rocks[i].b:setY(rocks[i].b:getY() - 10)
			rocks[i].dow.b:setY(rocks[i].dow.b:getY() - 10)
		end
	elseif sms == 14 then
		sms = sms + 1
		met.b:setY(met.b:getY() - 15)		
		for i = nowrock, #rocks do
			rocks[i].b:setY(rocks[i].b:getY() - 10)
			rocks[i].dow.b:setY(rocks[i].dow.b:getY() - 10)
		end
		i = #rocks + 1
		map = {}
		for j = 1, 31 do
			map[#map + 1] = 50 * (j - 1)
			map[#map + 1] = love.math.random(fur.h - 350, fur.h - 250) + ((i - 1) * 140) - (nowrock * 140)
		end
		rocks[i] = {}
		rocks[i].dow = {}
			rocks[i].dow.b = love.physics.newBody(World, love.math.random(29, 1479), fur.h - 370 + ((i - 1) * 140) - (nowrock * 140), "static")
			rocks[i].dow.s = love.physics.newCircleShape(10)
			rocks[i].dow.f = love.physics.newFixture(rocks[i].dow.b, rocks[i].dow.s)
		rocks[i].b = love.physics.newBody(World, 0, 0, "static")
		rocks[i].s = love.physics.newChainShape(false, map)
		rocks[i].f = love.physics.newFixture(rocks[i].b, rocks[i].s)
	end
	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		for i = 1, #stars do
			local old = stars[i]
			stars[i] = {old[1] + (love.math.random(-20, 20) / 21), old[2] + (love.math.random(-20, 20) / 21)}
		end
	end
	power = power + dt
end

function love.draw()
	love.graphics.scale(s, s)
	love.graphics.translate(t[1], t[2])
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)
	love.graphics.setColor(colors[1])
	love.graphics.setFont(aqua[5])
	love.graphics.print("Pause", 5, 0)
	love.graphics.print(tostring(score), 1400, 0)
	love.graphics.setColor(255, 255, 255, 90)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
	end
	love.graphics.setLineWidth(5)
	for i, v in ipairs(rocks) do
		if not rocks[i].b:isDestroyed() then
			if nowrock == i then
				love.graphics.setColor(colors[3])
				love.graphics.circle("line", rocks[i].dow.b:getX(), rocks[i].dow.b:getY(), 15)
				love.graphics.circle("line", rocks[i].dow.b:getX(), rocks[i].dow.b:getY(), 3)
				love.graphics.setColor(colors[1])
			else
				love.graphics.setColor(colors[3][1], colors[3][2], colors[3][3], 100)
				love.graphics.circle("line", rocks[i].dow.b:getX(), rocks[i].dow.b:getY(), 15)
				love.graphics.circle("line", rocks[i].dow.b:getX(), rocks[i].dow.b:getY(), 3)
				love.graphics.setColor(colors[1][1], colors[1][2], colors[1][3], 100)
			end
			love.graphics.line(rocks[i].b:getWorldPoints(rocks[i].s:getPoints()))
		end
	end
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", met.b:getWorldPoints(met.s:getPoints()))
	love.graphics.print("._.", met.b:getX(), met.b:getY(), met.b:getAngle() + 0.3, 1, 1, 3, 80)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end

function beginContact(a, b, coll)
	if a == met.f or b == met.f then
		if a == rocks[nowrock].dow.f or b == rocks[nowrock].dow.f then
			rocks[nowrock].dow.b:destroy()
			rocks[nowrock].b:destroy()
			rocks[nowrock].dow.f:destroy()
			rocks[nowrock].f:destroy()
			nowrock = nowrock + 1
		end
	end
end
function endContact(a, b, coll)
end
function preSolve(a, b, coll)
end
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
World:setCallbacks(beginContact, endContact, preSolve, postSolve)
