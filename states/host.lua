host = {}

function host:init()

	-- Check for previous entries file.
	if not love.filesystem.exists(connectSaveFile) then
		f = love.filesystem.newFile(connectSaveFile)
		f:open('w')
		f:write('Neophyte\n')
		prevNameText = 'Neophyte'
		f:write('127.0.0.1\n')
		self.prevAddressText = '127.0.0.1'
	else
		f = love.filesystem.newFile(connectSaveFile)
		f:open('r')
		local iter = 1
		for line in f:lines() do
			if iter == 1 then
				prevNameText = line
			elseif iter == 2 then
				self.prevAddressText = line
			end
			iter = iter + 1
		end
	end
	f:close()
	
    self.nameInput = Input:new(0, 0, 400, 80, font[36])
	self.nameInput.text = prevNameText
    self.nameInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2-150)
    self.nameInput.border = {127, 127, 127}

    self.connectButton = Button:new("Host Game", 0, 0, 200, 100, fontBold[36])
    self.connectButton:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 150)
    self.connectButton.bg = {33, 33, 33}
    self.connectButton.border = {127, 127, 127}

    self.connectButton.activated = function()
        if self.nameInput.text ~= ""  then
            self:saveInputs()
            self:doSwitchToGame()
        end
    end
end

function host:enter(prev)

end

function host:keypressed(key, code)
    if key == 'v' and love.keyboard.isDown('lctrl', 'rctrl') then
        text = love.system.getClipboardText()

        text = text:gsub("\n", "")
        text = text:gsub("\r", "")

        self.nameInput:textinput(text)
	elseif key == "escape" then
		state.switch(menu)
	else
        self.nameInput:keypressed(key, code)
    end
end

function host:keyreleased(key, code)
    if self.nameInput.text ~= "" and key == "return" then
        self:saveInputs()
		self:doSwitchToGame()
    end

    if key == "escape" then
        state.switch(menu)
    end
end

function host:mousepressed(x, y, button)
    self.connectButton:mousepressed(x, y, button)
end

function host:mousereleased(x, y, button)

end

function host:textinput(text)
    self.nameInput:textinput(text)
end

function host:update(dt)
    self.nameInput:update(dt)
    self.connectButton:update(dt)
end

function host:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[24])
    
    love.graphics.print("Name", self.nameInput.x, self.nameInput.y-30)
    self.nameInput:draw()

    self.connectButton:draw()
	
	if options:getConfig().graphics.customCursor then
		if love.mouse.isDown(1,2) then
			love.graphics.draw(mouseCursorImgPressed,love.mouse.getX(),love.mouse.getY(),0,0.5,0.5)
		else
			love.graphics.draw(mouseCursorImgUnpressed,love.mouse.getX(),love.mouse.getY(),0,0.5,0.5)
		end
	end
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
end

function host:saveInputs()
    -- Save inputs to file here.
    f = love.filesystem.newFile(connectSaveFile)
    f:open('w')
    f:write(self.nameInput.text..'\n')
    f:write(self.prevAddressText..'\n')
    f:close()
end

function host:doSwitchToGame()
	server = sock.newServer("*", 22122, 2)
	server:setSerialization(bitser.dumps, bitser.loads)
	print("Started server.")
	client = sock.newClient("localhost",22122)
	client:setSerialization(bitser.dumps, bitser.loads)
	print("Started client on localhost")
	state.switch(game, false, true, client, server)
end