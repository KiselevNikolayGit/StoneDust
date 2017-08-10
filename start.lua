love.physics.setMeter(12)
love.graphics.setBackgroundColor(colors[2])
World = love.physics.newWorld(0, 420)
sms = 1

met = {
	up = function()
		met.b:applyForce(0, -30000)
	end,
	rg = function()
		met.b:applyForce( 20000, -30000)
		met.b:applyAngularImpulse(5000)
	end,
	lf = function()
		met.b:applyForce(-20000, -30000)
		met.b:applyAngularImpulse(-5000)
	end
}

met.b = love.physics.newBody(World, 50, 50, "dynamic")
met.s = love.physics.newPolygonShape(-4*3, -2*3, -1*3, -4*3, 2*3, -5*3, 5*3, -3*3, 4*3, 3*3, 1*3, 5*3, -4*3, 4*3, -5*3, 2*3)
met.f = love.physics.newFixture(met.b, met.s)

stars = {}
for i = 1, 1000 do
	stars[i] = {love.math.random(0, fur.w * 10), love.math.random(0, fur.h)}
end

map = {0, fur.h + 500, 0, fur.h - 110}
for i = 1, 100 do
	map[#map + 1] = 100 * i
	map[#map + 1] = love.math.random(fur.h - 100, fur.h)
end
map[#map + 1] = map[#map - 1]
map[#map + 1] = fur.h + 500
WM = {}
WM.b = love.physics.newBody(World, 0, 0, "static")
WM.s = love.physics.newChainShape(false, map)
WM.f = love.physics.newFixture(WM.b, WM.s)

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = x / w
	y = y / h
end

function love.keypressed(key)
	if key == "up" then
		met.up()
	elseif key == "right" then
		met.rg()
	elseif key == "left" then
		met.lf()
	end
end

function love.update(dt)
	World:update(dt)
	if sms < 3 then
		sms = sms + dt
	end
	if time == nil then time = 0 else
		time = time + dt
	end
end

function love.draw()
	love.graphics.scale(s * sms, s * sms)
	love.graphics.translate((t[1] / sms) - met.b:getX() + (fur.w / sms / 2), (t[2] / sms) - met.b:getY() + (fur.h / sms / 2))
	love.graphics.setLineStyle("smooth")
	love.graphics.setColor(255, 255, 255, 200)
		for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
		love.graphics.circle("fill", stars[i][1], stars[i][2], 1)
	end
	love.graphics.print(tostring(love.timer.getFPS()), 5 + met.b:getX() - (fur.w / sms / 2), 5 + met.b:getY() - (fur.h / sms / 2), 0, 0.2, 0.2)
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", met.b:getWorldPoints(met.s:getPoints()))
	love.graphics.polygon("fill", met.b:getWorldPoints(met.s:getPoints()))
	love.graphics.setLineWidth(2)
	love.graphics.setColor(colors[1])
	love.graphics.polygon("fill", WM.b:getWorldPoints(WM.s:getPoints()))
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", WM.b:getWorldPoints(WM.s:getPoints()))
end