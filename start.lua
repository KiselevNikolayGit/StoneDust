love.physics.setMeter(12)
love.graphics.setBackgroundColor(colors[2])
World = love.physics.newWorld(0, 420)
edge = {}
edge.b = love.physics.newBody(World, 0, 0, "static")
edge.s = love.physics.newChainShape(false, 0, 0, 0, fur.h, fur.w, fur.h, fur.w, 0)
edge.f = love.physics.newFixture(edge.b, edge.s)
power = 0

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

met.b = love.physics.newBody(World, 150, -500, "dynamic")
met.s = love.physics.newPolygonShape(-4*7, -2*7, -1*7, -4*7, 2*7, -5*7, 5*7, -3*7, 4*7, 3*7, 1*7, 5*7, -4*7, 4*7, -5*7, 2*7)
met.f = love.physics.newFixture(met.b, met.s)

stars = {}
for i = 1, 230 do
	stars[i] = {love.math.random(0, fur.w), love.math.random(0, fur.h)}
end

WM = {}
for i = 1, 4 do
	map = {}
	for j = 1, 31 do
		map[#map + 1] = 50 * (j - 1)
		map[#map + 1] = love.math.random(fur.h - 100, fur.h) - ((i-1) * 100)
	end
	WM[i] = {dow = love.math.random(1, 30)}
	WM[i].b = love.physics.newBody(World, 0, 0, "static")
	WM[i].s = love.physics.newChainShape(false, map)
	WM[i].f = love.physics.newFixture(WM[i].b, WM[i].s)
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
	love.graphics.setColor(255, 255, 255, 90)
	love.graphics.print("Pause", 5, 5, 0, 0.23, 0.23)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
	end
	love.graphics.setLineWidth(4)
	love.graphics.setColor(colors[4])
	love.graphics.polygon("line", met.b:getWorldPoints(met.s:getPoints()))
	love.graphics.print("._.", met.b:getX(), met.b:getY(), met.b:getAngle() + 0.3, 0.2, 0.2, 20, 330)
	love.graphics.setColor(colors[1])
	for i, v in ipairs(WM) do
		love.graphics.line(WM[i].b:getWorldPoints(WM[i].s:getPoints()))
	end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end