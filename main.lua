-- CopyRight: KiselevNikolay
-- Ver 0.1.2

function love.load( )

		-- Main

	love.window.setFullscreen( true )
	sizew, sizeh = love.window.getMode( )
	love.graphics.setBackgroundColor( 121, 134, 203 )--( 197, 202, 233 )

	x, y = -1 
	--cursor = love.mouse.newCursor( love.image.newImageData( 'data/Cursor.png' ), 0, 0 )
	--love.mouse.setCursor( cursor )

	movekey = true

	scale = 4
	cX = sizew / 4
	cY = sizeh / 2

	time = love.timer.getTime( )

		-- World

	love.physics.setMeter( 50 )
	world = love.physics.newWorld( 0, 9.81 * 75, true )
	font = love.graphics.newFont( 'data/Pacifico-Regular.ttf', sizeh / 4 )

		-- Meteorit

	meteorit = { }
	meteorit.face = '._.'
	meteorit.body = love.physics.newBody( world, cX, cY, 'dynamic' )
	map = { -4, -2, -1, -4, 2, -5, 5, -3, 4, 3, 1, 5, -4, 4, -5, 2 }
	for n = 1, #map do
		map[ n ] = map[ n ] * sizeh / 350
	end
	meteorit.shape = love.physics.newPolygonShape( map )
	meteorit.fixture = love.physics.newFixture( meteorit.body, meteorit.shape )
	meteorit.fixture:setRestitution( 0.1 )
	mass = meteorit.body:getMass( )
	meteorit.body:setActive( false )

		-- Terrain

	blocks = { }
	last = 0
	max = sizeh * 0.12
	blockcount = 400
	blockscaleh = sizeh * 0.1
	blockscalew = sizew / blockcount * 20
	for i = 0, blockcount - 1 do
		blocks[i] = { }
		blocks[i].body = love.physics.newBody( world, 0, sizeh * 0.9 )
		vertices = { 0 + blockscalew * i, 100, blockscalew + blockscalew * i, 100, blockscalew + blockscalew * i, blockscaleh * 5, 0 + blockscalew * i, blockscaleh * 5 }
		if love.math.random( 500 ) > 20 then
			for j = 1, ( #vertices / 8 ) do
				vertices[ j * 4 ] = vertices[ j * 4 ] - love.math.random( max ) - max
				vertices[ j * 4 - 2 ] = last
				last = vertices[ j * 4 ]
			end
		end
		blocks[i].shape = love.physics.newPolygonShape( vertices )
		blocks[i].fixture = love.physics.newFixture( blocks[i].body, blocks[i].shape, 5 )
	end

		-- Stars

	stars = { }
	starradius = 0.75
	starscount = 250
	for i = 0, starscount do
		stars[i] = { }
		stars[i].starx = love.math.random( sizew * 5 )
		stars[i].stary = love.math.random( sizeh / 2, sizeh - blockscaleh )
	end


end

function love.update( dt )

		-- Main

	world:update( dt )
	speed = meteorit.body:getLinearVelocity( )
	transx = ( sizew / 2 ) - ( meteorit.body:getX( ) * scale )
	transy = ( sizeh / 2 ) - ( meteorit.body:getY( ) * scale / 3 ) - 1600

		-- Fall test

	if meteorit.body:getY( ) > sizeh then
		meteorit.face = '-_-'
		meteorit.body:setActive( false )
	else
		meteorit.body:setActive( true )
	end

		-- Touch

	local touches = love.touch.getTouches( )
	for i, id in ipairs( touches ) do
		touchx, touchy = love.touch.getPosition( id )

		-- setiing last-touch x and y	
		if i == 1 then
			x = touchx
			y = touchy
		end


		if touchx > sizew / 2 and i == 1 and movekey then
			meteorit.body:applyForce( mass * 10000, -mass * 8000 )
			movekey = false
		elseif touchx < sizew / 2 and i == 1 and movekey then
			meteorit.body:applyForce( -mass * 10000, -mass * 8000 )
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
	if love.mouse.isDown( 1 ) then
		x, y = love.mouse.getPosition( )
	end

		-- Keyboard

	if love.keyboard.isDown( 'q' ) then
		love.event.quit( )
	elseif love.keyboard.isDown( 'right' ) and movekey then
		meteorit.body:applyForce( mass * 10000, -mass * 8000 )
		movekey = false
	elseif love.keyboard.isDown( 'left' ) and movekey then
		meteorit.body:applyForce( -mass * 10000, -mass * 8000 )
		movekey = false
	elseif speed < 30 and speed > -30 then
		if love.timer.getTime( ) - time >= 0.75 then
			movekey = true
			time = love.timer.getTime( )
		end
	end


end

function love.draw( )

		--Main

	love.graphics.translate( transx, transy )
	love.graphics.scale( scale )
	love.graphics.setLineStyle( 'smooth' )
	love.graphics.setFont( font )

		-- Draw Logo

	love.graphics.print( 'StarFalls 0.1', cX - 100, cY + 100, 0.1, 0.5 / scale )

		-- Draw Stars

	love.graphics.setColor( 232, 234, 246 )
	for i = 0, #stars - 1 do
		love.graphics.circle( 'line', stars[i].starx + ( meteorit.body:getX( ) / 1.25 ), stars[i].stary, starradius )
		love.graphics.circle( 'fill', stars[i].starx + ( meteorit.body:getX( ) / 1.25 ), stars[i].stary, starradius )
	end

		-- Draw Meteorit

	love.graphics.setLineWidth( 1.5 )
	love.graphics.setColor( 255, 171, 145 )
	love.graphics.polygon( 'line', meteorit.body:getWorldPoints( meteorit.shape:getPoints( ) ) )
	love.graphics.polygon( 'fill', meteorit.body:getWorldPoints( meteorit.shape:getPoints( ) ) )
	love.graphics.setColor( 255, 112, 67 )
	love.graphics.print( meteorit.face, meteorit.body:getX( ), meteorit.body:getY( ), meteorit.body:getAngle( ) + 0.5, 0.2 / scale, 0.2 / scale, 5, 400 )

		-- Draw Terrain

	love.graphics.setLineWidth( 0.1 )
	love.graphics.setColor( 197, 202, 233 )
	for i = 0, blockcount - 1 do
		love.graphics.polygon( 'line', blocks[i].body:getWorldPoints( blocks[i].shape:getPoints( ) ) )
		love.graphics.polygon( 'fill', blocks[i].body:getWorldPoints( blocks[i].shape:getPoints( ) ) )
	end

		-- Draw Highscore

	love.graphics.print( tostring( math.floor( meteorit.body:getX( ) ) ), -transx / scale, -transy / scale, 0, 0.05, 0.05, -75, 50 )
	print( transx )
	print( transy )

end
