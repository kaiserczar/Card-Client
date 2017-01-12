menu = {}

menu.items = {
	{
        title = "JOIN GAME",
        action = function()
            state.switch(join)
        end,
		fontSize = 38,
    },
	{
        title = "HOST GAME",
        action = function()
            state.switch(host)
        end,
		fontSize = 38,
    },
	{
        title = "ADMIN",
        action = function()
            state.switch(admin)
        end,
		fontSize = 30,
    },
    {
        title = "OPTIONS",
        action = function()
            state.switch(options)
        end,
		fontSize = 30,
    },
    {
        title = "QUIT",
        action = function()
            love.event.quit()
        end,
		fontSize = 30,
    },
}

menu.buttons = {}

function menu:init()

	-- Constants for menu placement and spacing.
	self.screenOriginalSize = {x=960, y=720}
	self.buttonOrigin = {x=love.graphics.getWidth()/2, y = love.graphics.getHeight()*0.3}
	self.buttonCoordinates = self.buttonOrigin
	self.fontSpacingMultiplier = 1.3
	self.align = 'center'

    for i, item in pairs(self.items) do
		if self.align == 'center' then
			textWidth = font[item.fontSize]:getWidth(item.title)
            local button = Button:new(item.title, self.buttonCoordinates.x - textWidth/2, self.buttonCoordinates.y, nil, nil, font[item.fontSize], item.action)
            button.shadow = {22, 22, 22}
            button.shadowLength = 2
			table.insert(self.buttons, button)
		elseif self.align == 'left' then
            local button = Button:new(item.title, self.buttonCoordinates.x, self.buttonCoordinates.y, nil, nil, font[item.fontSize], item.action)
            button.shadow = {22, 22, 22}
            button.shadowLength = 2
			table.insert(self.buttons, button)
		elseif self.align == 'right' then
			textWidth = font[item.fontSize]:getWidth(item.title)
            local button = Button:new(item.title, self.buttonCoordinates.x - textWidth, self.buttonCoordinates.y, nil, nil, font[item.fontSize], item.action)
            button.shadow = {22, 22, 22}
            button.shadowLength = 2
			table.insert(self.buttons, button)
		end
		self.buttonCoordinates.y = self.buttonCoordinates.y + item.fontSize*self.fontSpacingMultiplier
    end
	
end

function menu:enter(prev)
	
end

function menu:update(dt)
    self.buttonCoordinates = {x=love.graphics.getWidth()/2, y = love.graphics.getHeight()/4}
	
    for i, button in pairs(self.buttons) do
        button:update(dt)
		
		if self.align == 'center' then
			textWidth = button.font:getWidth(self.items[i].title)
			button.x = self.buttonCoordinates.x - textWidth/2
			button.y = self.buttonCoordinates.y
			
		elseif self.align == 'left' then
			button.x = self.buttonCoordinates.x
			button.y = self.buttonCoordinates.y
		
		elseif self.align == 'right' then
			textWidth = button.font:getWidth(self.items[i].title)
			button.x = self.buttonCoordinates.x - textWidth
			button.y = self.buttonCoordinates.y
			
		end
		self.buttonCoordinates.y = self.buttonCoordinates.y + self.items[i].fontSize*self.fontSpacingMultiplier
    end
end

function menu:keyreleased(key, code)
	if key == "escape" and love.keyboard.isDown("lctrl", "rctrl") then
        love.event.quit()
    end
end

function menu:mousepressed(x, y, mbutton)
    for i, button in pairs(self.buttons) do
        button:mousepressed(x, y, mbutton)
    end
end

function menu:draw()
    love.graphics.setFont(fontBold[72])
	love.graphics.setColor(34, 34, 34)
    love.graphics.print("What a Card Game", 3+love.graphics.getWidth()/2-love.graphics.getFont():getWidth("What a Card Game")/2, 3+love.graphics.getHeight()*0.1)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("What a Card Game", love.graphics.getWidth()/2-love.graphics.getFont():getWidth("What a Card Game")/2, love.graphics.getHeight()*0.1)

    for i, button in pairs(self.buttons) do
        button:draw()
    end
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
end