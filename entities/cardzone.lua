CardZone = class("CardZone")
CardZone.sessionUID = 1
CardZone.zones = {}

function CardZone:initialize(name, locX, locY, spanX, spanY, showTitle, showBorder)
	self.name = name
	self.x = locX
	self.y = locY
	self.width = spanX
	self.height = spanY
	self.cards = {}
	self.numCards = 0
	self.spacing = 10
	self.isTwoRows = false
	self.showTitle = showTitle or true
	self.showBorder = showBorder or true
	
	self.UID = CardZone.sessionUID
	CardZone.sessionUID = CardZone.sessionUID + 1
	
	self.center = {x = locX + 0.5*spanX, y = locY + 0.5*spanY}
	
	table.insert(CardZone.zones,self)
end

function CardZone:update(dt)
	self:balanceCards()
end

function CardZone:mousepressed(x, y, mbutton)

end

function CardZone:draw()
    love.graphics.setColor(255, 255, 255)
	
	if self.showTitle then
		love.graphics.setFont(font[24])
		local x = self.width/2 - love.graphics.getFont():getWidth(self.name)/2
		local y = self.height/2 - love.graphics.getFont():getHeight(self.name)/2
		love.graphics.print(self.name, x+self.x, y+self.y)
	end
	
	if self.showBorder then
		love.graphics.setColor(255, 0, 0)
		love.graphics.line(self.x, self.y, self.x+self.width, self.y, self.x+self.width, self.y+self.height, self.x, self.y+self.height, self.x, self.y)
	end
	
	love.graphics.setColor(255,255,255)
	for i, card in ipairs(self.cards) do
		card:draw()
	end
end

function CardZone:addCard(card)
	table.insert(self.cards,card)
	self.numCards = self.numCards + 1
	card:setZone(getZoneFromUID(self.UID))
	self:balanceCards()
	--print("Zone " .. tostring(self.UID) .. " has added card " .. card.name)
end

function CardZone:removeCard(card)
	for i, cardi in ipairs(self.cards) do
		if cardi.UID == card.UID then
			table.remove(self.cards,i)
			self.numCards = self.numCards - 1
			card:setZone(nil)
			self:balanceCards()
			--print("Zone " .. tostring(self.UID) .. " has removed card " .. card.name)
		end
	end
	
end

function CardZone:balanceCards()
	self.isTwoRows = false
	spacePerCard = (self.width - (self.numCards+1)*self.spacing) / self.numCards
	maxHeight = 0
	for i, card in ipairs(self.cards) do
		card:setScalingMax(spacePerCard,self.height)
		if card.stdHeight > maxHeight then
			maxHeight = card.stdHeight
		end
	end
	
	if self.numCards == 0 then
		return nil
	end
	--print("Max card height is: " .. tostring(maxHeight) .. " Zone total height is: " .. tostring(self.height))
	if maxHeight <= self.height/2 then
	-- Two rows of cards
		maxWidth = 0
		for i, card in ipairs(self.cards) do
			card:setScalingMax(spacePerCard,self.height/2)
			if card.stdWidth > maxWidth then
				maxWidth = card.stdWidth
			end
		end
		self.isTwoRows = true
		-- Do row 1 here.
		currentX = self.width/2 - (math.ceil(self.numCards/2)-1)/2*(spacePerCard*2 + self.spacing) + self.x
		curCard = 1
		for i, card in ipairs(self.cards) do
			card.origX = currentX
			currentX = currentX + spacePerCard*2 + self.spacing
			card.origY = self.y + self.height / 4 - self.spacing/4
			if curCard == math.ceil(self.numCards/2) then
				break
			end
			curCard = curCard + 1
		end
		-- Do row 2 here.
		currentX = self.width/2 - (math.floor(self.numCards/2)-1)/2*(spacePerCard*2 + self.spacing) + self.x
		for i, card in ipairs(self.cards) do
			if i > curCard then
				card.origX = currentX
				currentX = currentX + spacePerCard*2 + self.spacing
				card.origY = self.y + self.height * 3 / 4 + self.spacing/4
			end
		end
		
	else -- One row of cards
		currentX = self.width/2 - (self.numCards-1)/2*(spacePerCard + self.spacing) + self.x
		for i, card in ipairs(self.cards) do
			card.origX = currentX
			currentX = currentX + spacePerCard + self.spacing
			card.origY = self.y + self.height / 2
		end
	end
end

function CardZone:containsCard(card)
	for i, cardi in ipairs(self.cards) do
		if cardi.UID == card.UID then
			return true
		end
	end
	return false
end

function CardZone:isInZone(x, y)
	return x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height
end

function CardZone:clearCards()
	self.cards = {}
	self.numCards = 0
	self.isTwoRows = false
	
	self:balanceCards()
end

function getCardZone(card)
	
	for i, zone in ipairs(CardZone.zones) do
		if zone:containsCard(card) then
			return zone
		end
	end
	return nil
end

function getZoneFromUID(id)
	for i,zone in ipairs(CardZone.zones) do
		if zone.UID == id then
			return zone
		end
	end
	return nil
end