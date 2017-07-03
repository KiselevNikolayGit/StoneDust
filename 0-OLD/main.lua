-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: Creative Commons 4.0
-- -- StoneDust
-- Version: 0.2.1.2

loaded = false
updated = false

function love.load( )
	-- Main
	love.window.setFullscreen(true)
	sizew, sizeh = love.window.getMode( )
	love.graphics.setBackgroundColor(121, 134, 203)
	-- Values
	x, y = -1
	scale = 4
	cX = sizew / 4
	cY = sizeh / 2
	transx = 0
	transy = 0
	movekey = true
	time = love.timer.getTime( )
	-- World
	love.physics.setMeter(50)
	world = love.physics.newWorld(0, 9.81 * 75, true)
	font = love.graphics.newFont("data/Pacifico-Regular.ttf", sizeh / 4)
	-- Meteorit
	meteorit = { }
	meteorit.body = love.physics.newBody(world, cX, cY, "dynamic")
	map = {-4, -2, -1, -4, 2, -5, 5, -3, 4, 3, 1, 5, -4, 4, -5, 2}
	for n = 1, #map do
		map[n] = map[n] * sizeh / 350
	end
	meteorit.shape = love.physics.newPolygonShape(map)
	meteorit.fixture = love.physics.newFixture(meteorit.body, meteorit.shape)
	meteorit.fixture:setRestitution(0.1)
	mass = meteorit.body:getMass( )
	meteorit.body:setActive(false)
	-- Terrain
	blocks = { }
	last = -100
	max = sizeh * 0.12
	blockcount = 170
	blockscaleh = sizeh * 0.1
	blockscalew = sizew / blockcount * 10
	blocks[0] = { }
	blocks[0].body = love.physics.newBody(world, 0, sizeh * 0.9)
	vertices = {-320, -420, blockscalew, -100, blockscalew, (blockscaleh * 5), -320, (blockscaleh * 5)}
	blocks[0].shape = love.physics.newPolygonShape(vertices)
	blocks[0].fixture = love.physics.newFixture(blocks[0].body, blocks[0].shape, 5)
	for i = 1, blockcount - 1 do
		blocks[i] = { }
		blocks[i].body = love.physics.newBody(world, 0, sizeh * 0.9)
		vertices = {0 + blockscalew * i, 100, blockscalew + blockscalew * i, 100, blockscalew + blockscalew * i, blockscaleh * 5, 0 + blockscalew * i, blockscaleh * 5}
		for j = 1, (#vertices / 8) do
			vertices[j * 4] = vertices[j * 4] - love.math.random(max) - max
			vertices[j * 4 - 2] = last
			last = vertices[j * 4]
		end
		blocks[i].shape = love.physics.newPolygonShape(vertices)
		blocks[i].fixture = love.physics.newFixture(blocks[i].body, blocks[i].shape, 5)
	end
	-- EndGet
	blocks[blockcount] = { }
	-- Stars
	-- body
	loaded = true
end

function love.update(dt)
	if loaded then
		-- Main
		world:update(dt)
		speed = meteorit.body:getLinearVelocity( )
		transx = (sizew / 2) - (meteorit.body:getX( ) * scale)
		transy = (sizeh / 2) - (meteorit.body:getY( ) * scale / 3) - 1600
		-- Fall test
		if meteorit.body:getY( ) > sizeh then
			meteorit.body:setActive(false)
			love.load( )
		else
			meteorit.body:setActive(true)
		end
		-- Touch
		local touches = love.touch.getTouches( )
		for i, id in ipairs(touches) do
			touchx, touchy = love.touch.getPosition(id)
			-- setiing last-touch x and y
			if i == 1 then
				x = touchx
				y = touchy
			end
			if touchx > sizew / 3 * 2 and i == 1 and movekey then
				meteorit.body:applyForce( mass * 10000, -mass * 8000 )
				meteorit.body:applyAngularImpulse(250)
				movekey = false
			elseif touchx < sizew / 3 and i == 1 and movekey then
				meteorit.body:applyForce( -mass * 10000, -mass * 8000 )
				meteorit.body:applyAngularImpulse(-250)
				movekey = false
			elseif touchx > sizew / 3 and touchx < sizew / 3 * 2 and i == 1 and movekey then
				meteorit.body:applyForce(0, -mass * 10000)
				movekey = false
			elseif speed < 30 and speed > -30 then
				if love.timer.getTime( ) - time >= 0.75 then
					movekey = true
					time = love.timer.getTime( )
				end
			end
		end
		-- Mouse
		-- setiing last-touch x and y
		if love.mouse.isDown(1) then
			x, y = love.mouse.getPosition( )
		end
		-- Keyboard
		if love.keyboard.isDown("q") then
			love.event.quit( )
		elseif love.keyboard.isDown("e") then
			love.load( )
		elseif love.keyboard.isDown("right") and movekey then
			meteorit.body:applyForce(mass * 10000, -mass * 8000)
			meteorit.body:applyAngularImpulse(250)
			movekey = false
		elseif love.keyboard.isDown("left") and movekey then
			meteorit.body:applyForce(-mass * 10000, -mass * 8000)
			meteorit.body:applyAngularImpulse(-250)
			movekey = false
		elseif love.keyboard.isDown("up") and movekey then
			meteorit.body:applyForce(0, -mass * 10000)
			movekey = false
		elseif speed < 30 and speed > -30 then
			if love.timer.getTime( ) - time >= 0.75 then
				movekey = true
				time = love.timer.getTime( )
			end
		end
		updated = true
	end
end

function love.draw( )
	if updated then
		-- Main
		love.graphics.translate(transx, transy)
		love.graphics.scale(scale)
		love.graphics.setLineStyle("smooth")
		love.graphics.setFont(font)
		-- Draw Meteorit
		love.graphics.setLineWidth(1.5)
		love.graphics.setColor(255, 171, 145)
		love.graphics.polygon("line", meteorit.body:getWorldPoints(meteorit.shape:getPoints( )))
		love.graphics.polygon("fill", meteorit.body:getWorldPoints(meteorit.shape:getPoints( )))
		love.graphics.setColor(255, 112, 67)
		love.graphics.print("._.", meteorit.body:getX( ), meteorit.body:getY( ), meteorit.body:getAngle( ) + 0.5, 0.2 / scale, 0.2 / scale, 5, 400)
		-- Draw Terrain
		love.graphics.setLineWidth(0.1)
		for i = 0, blockcount - 1 do
			love.graphics.setColor(197, 202, 233)
			love.graphics.polygon("line", blocks[i].body:getWorldPoints(blocks[i].shape:getPoints( )))
			love.graphics.polygon("fill", blocks[i].body:getWorldPoints(blocks[i].shape:getPoints( )))
		end
	end
end

love.load( )
