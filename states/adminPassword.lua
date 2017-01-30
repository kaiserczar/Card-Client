adminPassword = {}

function adminPassword:init()
	
    self.passInput = Input:new(0, 0, 400, 80, font[36])
	self.passInput.text = ""
    self.passInput:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2-150)
    self.passInput.border = {127, 127, 127}
	self.passInput.selected = true

    self.submitButton = Button:new("Submit Password", 0, 0, 50+fontBold[36]:getWidth("SubmitPassword"), 100, fontBold[36])
    self.submitButton:centerAround(love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 150)
    self.submitButton.bg = {33, 33, 33}
    self.submitButton.border = {127, 127, 127}
	
    self.submitButton.activated = function()
        if self.passInput.text == "NEWCARDS" then
            state.switch(admin);
        end
    end
end

function adminPassword:enter(prev)
	
end

function adminPassword:keypressed(key, code)
    if key == 'v' and love.keyboard.isDown('lctrl', 'rctrl') then
        text = love.system.getClipboardText()

        text = text:gsub("\n", "")
        text = text:gsub("\r", "")

        self.passInput:textinput(text)
	elseif key == "escape" then
		state.switch(menu)
	else
        self.passInput:keypressed(key, code)
    end
	
end

function adminPassword:keyreleased(key, code)
    if self.passInput.text == "NEWCARDS" and key == "return" then
        state.switch(admin)
    end

    if key == "escape" then
        state.switch(menu)
    end
end

function adminPassword:mousepressed(x, y, button)
    self.submitButton:mousepressed(x, y, button)
end

function adminPassword:mousereleased(x, y, button)

end

function adminPassword:textinput(text)
    self.passInput:textinput(text)
end

function adminPassword:update(dt)
    self.passInput:update(dt)
    self.submitButton:update(dt)
end

function adminPassword:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[24])
    
    love.graphics.print("Password", self.passInput.x, self.passInput.y-30)
    self.passInput:draw()

    self.submitButton:draw()
	

	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)

end