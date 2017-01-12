admin = {}

function admin:init()
	
    self.nameInput = Input:new(0, 0, 400, 80, font[36])
	self.nameInput.text = ""
    self.nameInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2-150)
    self.nameInput.border = {127, 127, 127}

    self.addressInput = Input:new(0, 0, 400, 80, font[36])
    self.addressInput.text = ""
    self.addressInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    self.addressInput.border = {127, 127, 127}

    self.connectButton = Button:new("admin Game", 0, 0, 200, 100, fontBold[36])
    self.connectButton:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 150)
    self.connectButton.bg = {33, 33, 33}
    self.connectButton.border = {127, 127, 127}

	self.listTest = List:new("Test List:",{"Option 1","Option 2","Option 3", "Option 4"},1,100,100,200,50)
	self.listTest:setText("{}")
	self.listTest:setOptionWidth(130)
	
    self.connectButton.activated = function()
        if self.nameInput.text ~= "" and self.addressInput.text ~= "" then
            
        end
    end
end

function admin:enter(prev)

end

function admin:keypressed(key, code)
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

function admin:keyreleased(key, code)
    if self.nameInput.text ~= "" and self.addressInput.text ~= "" and key == "return" then
        self:saveInputs()
		-- DO CONNECTION HERE
        self:doSwitchToGame()
    end

    if key == "escape" then
        state.switch(menu)
    end
end

function admin:mousepressed(x, y, button)
    self.connectButton:mousepressed(x, y, button)
end

function admin:mousereleased(x, y, button)

end

function admin:textinput(text)
    self.addressInput:textinput(text)
    self.nameInput:textinput(text)
end

function admin:update(dt)
    self.addressInput:update(dt)
    self.nameInput:update(dt)
    self.connectButton:update(dt)
	self.listTest:update(dt)
end

function admin:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[24])
    
    love.graphics.print("Name", self.nameInput.x, self.nameInput.y-30)
    self.nameInput:draw()
    
    love.graphics.setFont(fontBold[24])
    love.graphics.print("IP Address", self.addressInput.x, self.addressInput.y-30)
    self.addressInput:draw()

    self.connectButton:draw()
	
	self.listTest:draw()

	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)

end