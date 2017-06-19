-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 0.3.0.0

function love.load()
	-- Load Chunks --
	rgbhex = love.filesystem.load("rgbhex")()
	setmounts = love.filesystem.load("mounts")()
	mountmap = love.filesystem.load("map")()

	-- Setup --
	love.window.setFullscreen(true)
	sizew, sizeh = love.window.getMode()
	font = love.graphics.newFont("Pacifico-Regular.ttf", sizeh / 16)
	time = love.timer.getTime()
	movekey = true
	x, y = -1
	scale = 4
	cX = sizew / 4
	cY = sizeh / 2
	transx = 0
	transy = 0

	-- World --
	love.physics.setMeter(50)
	world = love.physics.newWorld(0, 9.81 * 75, true)

	-- Meteorit --
	mt = {}
	mt.b = love.physics.newBody(world, cX, cY, "dynamic")
	map = {-4, -2, -1, -4, 2, -5, 5, -3, 4, 3, 1, 5, -4, 4, -5, 2}
	for n = 1, #map do map[n] = map[n] * sizeh / 350 end
	mt.s = love.physics.newPolygonShape(map)
	mt.fixture = love.physics.newFixture(mt.b, mt.s)
	mt.fixture:setRestitution(0.1)
	mass = mt.b:getMass()

	-- Rocks --
	rock = {}
	rock.b = love.physics.newBody(world, 600, 400, "dynamic")
	map = {-4, -2, -1, -4, 2, -5, 5, -3, 4, 3, 1, 5, -4, 4, -5, 2}
	for n = 1, #map do map[n] = map[n] * sizeh / 700 end
	rock.s = love.physics.newPolygonShape(map)
	rock.f = love.physics.newFixture(rock.b, rock.s)
	rock.b:setGravityScale(.2)

	-- Jouints --
	joints = {}

	-- Mounts --
	mounts = setmounts()
end

function movemt(left, right, up)
	-- Test speed --
	local speed = mt.b:getLinearVelocity()
	if speed < 30 and speed > -30 then
		if love.timer.getTime() - time >= 0.75 then
			movekey = true
			time = love.timer.getTime()
		end
	end

	if love.keyboard.isDown("right") and movekey then
		mt.b:applyForce(mass * 8000, -mass * 5000)
		mt.b:applyAngularImpulse(150)
		movekey = false
	elseif love.keyboard.isDown("left") and movekey then
		mt.b:applyForce(-mass * 8000, -mass * 5000)
		mt.b:applyAngularImpulse(-150)
		movekey = false
	elseif love.keyboard.isDown("up") and movekey then
		mt.b:applyForce(mass * 1000, -mass * 10000)
		movekey = false
	end
end

function love.update(dt)
	-- Update --
	world:update(dt)
	transx = (sizew / 2) - (mt.b:getX() * scale)
	transy = (sizeh / 2) - (mt.b:getY() * scale / 3) - 1600
	if mt.b:getY() > sizeh then
		love.load()
	end

	-- Joint gets --
	if joints[1] == nil and mt.b:getX() >= rock.b:getX() - 20 then
		joints[1] = love.physics.newRopeJoint(mt.b, rock.b, mt.b:getX(), mt.b:getY(), rock.b:getX(), rock.b:getY(), 30)
	end

	-- Get keyboard --
	if love.keyboard.isDown("q") then
		love.event.quit()
	elseif love.keyboard.isDown("e") then
		love.load()
	end

	-- Controls --
	if love.keyboard.isDown("right") and movekey then right = true else right = false end
	if love.keyboard.isDown("left") and movekey then left = true else left = false end
	if love.keyboard.isDown("up") and movekey then up = true else up = false end
	local touches = love.touch.getTouches()
	for i, id in ipairs(touches) do
		touchx, touchy = love.touch.getPosition(id)
		if i == 1 then x, y = touchx, touchy end -------------------------------------------------------------------?
		if touchx > sizew / 3 * 2 and i == 1 and movekey then right = true else right = false end
		if touchx < sizew / 3 and i == 1 and movekey then left = true else left = false end
		if touchx > sizew / 3 and touchx < sizew / 3 * 2 and i == 1 and movekey then up = true else up = false end
	end
	movemt(left, right, up)
end

function love.draw()
	-- Setup Draw --
	love.graphics.translate(transx, transy)
	love.graphics.scale(scale)
	love.graphics.setFont(font)
	love.graphics.setLineWidth(1.5)
	love.graphics.setLineStyle("smooth")
	love.graphics.setBackgroundColor(rgbhex("#7986cb"))

	-- Draw Logo
	love.graphics.setColor(rgbhex("#C5CAE9"))
	love.graphics.print("StarDust", cX, cY * 1.5, 0, 0.4, 0.4)

	-- Draw Rocks --
	love.graphics.setColor(rgbhex("#C5CAE9"))
	love.graphics.polygon("line", rock.b:getWorldPoints(rock.s:getPoints()))
	love.graphics.polygon("fill", rock.b:getWorldPoints(rock.s:getPoints()))

	-- Draw Meteorit --
	love.graphics.setColor(rgbhex("#ffab91"))
	love.graphics.polygon("line", mt.b:getWorldPoints(mt.s:getPoints()))
	love.graphics.polygon("fill", mt.b:getWorldPoints(mt.s:getPoints()))
	love.graphics.setColor(rgbhex("#ff7043"))
	love.graphics.print("._.", mt.b:getX(), mt.b:getY(), mt.b:getAngle() + 0.5, 0.8 / scale, 0.8 / scale, -4, 100)

	-- Draw Mount --
	love.graphics.setLineWidth(0.1)
	for i = 1, #mounts do
		love.graphics.setColor(rgbhex("#9FA8DA"))
		love.graphics.polygon("line", mounts[i].b:getWorldPoints(mounts[i].s:getPoints()))
		love.graphics.polygon("fill", mounts[i].b:getWorldPoints(mounts[i].s:getPoints()))
	end
end
