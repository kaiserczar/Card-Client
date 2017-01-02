join = {}
connectSaveFile = 'LastJoinInfo.txt'

function join:init()

	-- Check for previous entries file.
	if not love.filesystem.exists(connectSaveFile) then
		f = love.filesystem.newFile(connectSaveFile)
		f:open('w')
		f:write('Neophyte\n')
		prevNameText = 'Neophyte'
		f:write('127.0.0.1\n')
		prevAddresssText = '127.0.0.1'
	else
		f = love.filesystem.newFile(connectSaveFile)
		f:open('r')
		local iter = 1
		for line in f:lines() do
			if iter == 1 then
				prevNameText = line
			elseif iter == 2 then
				prevAddresssText = line
			end
			iter = iter + 1
		end
	end
	f:close()
	
    self.nameInput = Input:new(0, 0, 400, 80, font[36])
	self.nameInput.text = prevNameText
    self.nameInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2-150)
    self.nameInput.border = {127, 127, 127}

    self.addressInput = Input:new(0, 0, 400, 80, font[36])
    self.addressInput.text = prevAddresssText
    self.addressInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self.addressInput.border = {127, 127, 127}

    self.connectButton = Button:new("Join Game", 0, 0, 200, 100, fontBold[36])
    self.connectButton:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 150)
    self.connectButton.bg = {33, 33, 33}
    self.connectButton.border = {127, 127, 127}

    self.connectButton.activated = function()
        if self.nameInput.text ~= "" and self.addressInput.text ~= "" then
            self:saveInputs()
			self:doSwitchToGame()
        end
    end
end

function join:enter(prev)

end

function join:keypressed(key, code)
    if key == 'v' and love.keyboard.isDown('lctrl', 'rctrl') then
        text = love.system.getClipboardText()

        text = text:gsub("\n", "")
        text = text:gsub("\r", "")

        self.addressInput:textinput(text)
        self.nameInput:textinput(text)
    elseif key == 'tab' then
		if self.addressInput.selected then
			self.addressInput.selected = false
			self.nameInput.selected = true
		elseif self.nameInput.selected then
			self.nameInput.selected = false
			self.addressInput.selected = true
		end
	elseif key == "escape" then
		state.switch(menu)
	else
        self.addressInput:keypressed(key, code)
        self.nameInput:keypressed(key, code)
    end
	
end

function join:keyreleased(key, code)
    if self.nameInput.text ~= "" and self.addressInput.text ~= "" and key == "return" then
        self:saveInputs()
		-- DO CONNECTION HERE
        self:doSwitchToGame()
    end

    if key == "escape" then
        state.switch(menu)
    end
end

function join:mousepressed(x, y, button)
    self.connectButton:mousepressed(x, y, button)
end

function join:mousereleased(x, y, button)

end

function join:textinput(text)
    self.addressInput:textinput(text)
    self.nameInput:textinput(text)
end

function join:update(dt)
    self.addressInput:update(dt)
    self.nameInput:update(dt)
    self.connectButton:update(dt)
end

function join:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[24])
    
    love.graphics.print("Name", self.nameInput.x, self.nameInput.y-30)
    self.nameInput:draw()
    
    love.graphics.setFont(fontBold[24])
    love.graphics.print("IP Address", self.addressInput.x, self.addressInput.y-30)
    self.addressInput:draw()

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

function join:saveInputs()
    -- Save inputs to file here.
    f = love.filesystem.newFile(connectSaveFile)
    f:open('w')
    f:write(self.nameInput.text..'\n')
    f:write(self.addressInput.text..'\n')
    f:close()
end

function join:doSwitchToGame()
	client = sock.newClient(self.addressInput.text,22122)
	print("Sent connection request to ".. self.addressInput.text)
	state.switch(game, false, false, client, nil)
end