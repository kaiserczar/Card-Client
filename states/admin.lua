admin = {}

function admin:init()
	self.alwaysUsableElements = {}
	self.elements = {}
	self.currentPanel = 1

	self.leftAlign = love.graphics.getWidth()*0.1
	self.optionWidth = 130
	self.bottomMargin = 70
	self.listWidth = 400
	self.listOptionWidth = 130

	self.tabsY = 160
	self.tabSpacing = 35
end

function admin:add(obj, panel)
	panel = panel or 1
	if self.elements[panel] == nil then
		self.elements[panel] = {}
	end
	table.insert(self.elements[panel], obj)
	return obj
end

function admin:alwaysUsableAdd(obj)
	table.insert(self.alwaysUsableElements, obj)
	return obj
end

function admin:enter(prev)
	self.currentPanel = 1

	self.tabs = {"New Creature", "New Construction", "New Resource", "New Spell", "Card List"}

	self.elements = {}
	for i, tab in ipairs(self.tabs) do
		self.elements[i] = {}
	end
	self.alwaysUsableElements = {}
	-- data table for creating ui elements
	-- the indexes correspond with the tabs
	self.items = {
		{ -- New Creature
			y = 250,
			dy = 45,

			-- the short name turns into the key for the list object that can be accessed through self
			-- e.g. "resolution" creates: self.resolution (instance of the object)
			outline = {
				--{List, 		"RESOLUTION", 		"resolution", 	'{1}x{2}', 	resolutions, {config.display.width, config.display.height}},
				--{List, 		"ANTIALIASING",		"msaa", 		'{}x', 		msaaadmin, config.display.flags.msaa},
				{Checkbox, 	"FULLSCREEN", 		"fullscreen", 	false},
				{Checkbox, 	"VERTICAL SYNC", 	"vsync", 		false},
				{Checkbox, 	"BORDERLESS", 		"borderless", 	false},
			},
		},

		{ -- New Construction
			y = 250,
			dy = 45,

			outline = {
				{Slider, 	"SOUND VOLUME", 	"soundVolume", 0, 100, 50},
			},
		},
		
		{ -- New Resource
			y = 250,
			dy = 45,
			
			outline = {
			
			}
		},
		
		{ -- New Spell
			y = 250,
			dy = 45,
			
			outline = {
			
			}
		},
		
		{ -- Card List
			y = 250,
			dy = 45,
			
			outline = {
			
			}
		},
	}

	-- how to handle adding a ui element to an admin panel
	self.handling = {
		-- panel: index of the current panel
		-- y: y value of the ui element
		-- args: a table of all the data needed to make the ui element
		-- args[1] = the class (List, Checkbox, ...)

		[List] = function(panel, y, args)
			local title, name, display, list, initial = args[2], args[3], args[4], args[5], args[6]

			self[name] = self:add(List:new(title, list, initial, self.leftAlign, y, self.listWidth), panel)
			self[name]:setText(display)
			self[name]:setOptionWidth(self.listOptionWidth)
		end,

		[Checkbox] = function(panel, y, args)
			local title, name, flag = args[2], args[3], args[4]

			self[name] = self:add(Checkbox:new(title, self.leftAlign, y), panel)
			self[name].selected = flag
		end,

		[Slider] = function(panel, y, args)
			local title, name, min, max, value = args[2], args[3], args[4], args[5], args[6]

			self[name] = self:add(Slider:new(title, min, max, value, self.leftAlign, y, 400), panel)
			self[name].changed = function()
				signal.emit(name .. 'Changed', self[name].value)
			end
		end,
	}
	
	for panel, panelItems in ipairs(self.items) do
		local y = panelItems.y
		local dy = panelItems.dy

		for i, args in ipairs(panelItems.outline) do
			self.handling[args[1]](panel, y, args)

			y = y + dy
		end
	end

	-- Buttons to switch tabs
	local prevWidth = 0
	for i, tabName in ipairs(self.tabs) do
		local b = self:alwaysUsableAdd(Button:new(tabName, self.leftAlign + self.tabSpacing * (i-1) + prevWidth, self.tabsY, nil, nil, fontLight[24]))
		b.activated = function()
			self.currentPanel = i
		end
		prevWidth = b.width + prevWidth
	end
	
	local y = love.graphics.getHeight() - self.bottomMargin
	self.back = self:alwaysUsableAdd(Button:new("< BACK", self.leftAlign, y))
	self.back.activated = function()
		state.switch(menu)
	end

	self.apply = self:alwaysUsableAdd(Button:new('APPLY CHANGES', self.leftAlign+170, y))
	self.apply.activated = function ()
		
	end
end

function admin:update(dt)
	for i, element in ipairs(self.elements[self.currentPanel]) do
		element:update(dt)
	end

	for i, element in ipairs(self.alwaysUsableElements) do
		element:update(dt)
	end
end

function admin:mousepressed(x, y, button)
	for i, element in ipairs(self.elements[self.currentPanel]) do
		element:mousepressed(x, y, button)
	end

	for i, element in ipairs(self.alwaysUsableElements) do
		element:mousepressed(x, y, button)
	end
end

function admin:keypressed(key)
	if key == "escape" then
		state.switch(menu)
	end
end

function admin:draw()
    love.graphics.setFont(fontBold[72])
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('admin', 75, 70)

    for i, element in ipairs(self.elements[self.currentPanel]) do
		element:draw()
	end

	for i, element in ipairs(self.alwaysUsableElements) do
		element:draw()
	end
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
end
