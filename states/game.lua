game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:enter()
	self.cards = {}
	--table.insert(self.cards,Card:new("card1",love.graphics.newImage('assets/img/card.png'),love.graphics.getWidth()/2-500,love.graphics.getHeight()/2+250,0.5,0.75,false,100,100))
	--table.insert(self.cards,Card:new("card2",love.graphics.newImage('assets/img/card.png'),love.graphics.getWidth()/2,love.graphics.getHeight()/2+250,0.5,0.75,false,100,100))
	--table.insert(self.cards,Card:new("card3",love.graphics.newImage('assets/img/card.png'),love.graphics.getWidth()/2+300,love.graphics.getHeight()/2+250,0.5,0.75,false,100,100))
	--table.insert(self.cards,Card:new("card4",love.graphics.newImage('assets/img/card.png'),love.graphics.getWidth()/2-300,love.graphics.getHeight()/2+250,0.5,0.75,false,100,100))
	--table.insert(self.cards,Card:new("card5",love.graphics.newImage('assets/img/card.png'),love.graphics.getWidth()/2+500,love.graphics.getHeight()/2+250,0.5,0.75,false,100,100))
	
	self.zones = {}
	table.insert(self.zones,CardZone:new("foeMainHand",5,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeResHand",10+(love.graphics.getWidth()-15)/2,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeBuilding",5,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeMagic",10+(love.graphics.getWidth()-15)/2,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeMonster",5,15+2*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youMonster",5,20+3*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youBuilding",5,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youMagic",10+(love.graphics.getWidth()-15)/2,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youResHand",5+love.graphics.getWidth()/2,30+5*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youMainHand",5+love.graphics.getWidth()/2,35+6*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	
	self.hoverImg = nil
	self.hoverImgScale = 1
	
	self:setHoverImage(love.graphics.newImage("assets/img/cardBack.jpg"))
end

function game:update(dt)
	for i, card in ipairs(self.cards) do
		card:update(dt)
	end
	for i, zone in ipairs(self.zones) do
		zone:update(dt)
	end
end

function game:keypressed(key, code)
	if key == "space" then
		for i, card in ipairs(self.cards) do
			zone = getCardZone(card)
			if zone == nil then
				print("Card "..tostring(card.UID).." is not in a zone.")
			else
				print("Card "..tostring(card.UID).." is in zone "..tostring(zone.UID))
			end
		end
	elseif key == "a" then
		newCard = Card:new(self,"placeholder",love.graphics.newImage('assets/img/card.png'),love.mouse.getX(),love.mouse.getY(),0.5,0.75,false,100,100)
		newCard.name = "card"..tostring(newCard.UID)
		table.insert(self.cards,newCard)
		self.zones[6]:addCard(newCard)
	end
end

function game:mousepressed(x, y, mbutton)
	for i, card in ipairs(self.cards) do
		if not card.isDragging then
			if card:isMouseOver(x,y) then
				-- We're over the card. Start dragging.
				card.isDragging = true
				card.dragOffsetX = card.x - x
				card.dragOffsetY = card.y - y
				
				zone = getCardZone(card)
				if zone ~= nil then
					print("Card ".. tostring(card.UID) .."'s zone, removing from: " .. tostring(zone.UID))
					zone:removeCard(card)
				end
			end
		end
	end
end

function game:mousereleased(x, y, mbutton)
	for i, card in ipairs(self.cards) do
		if card.isDragging then
			card.isDragging = false
			for i, zone in ipairs(self.zones) do
				if zone:isInZone(card.x,card.y) then
					-- enter the zone here
					zone:addCard(card)
					break
				end
			end
			break
		end
	end
end

function game:draw()
    love.graphics.setColor(255, 255, 255)
	
	for i, zone in ipairs(self.zones) do
		zone:draw()
	end
	for i, card in ipairs(self.cards) do
		card:draw()
	end
	
	love.graphics.draw(self.hoverImg,2,27+5*(love.graphics.getHeight()-40)/7,0,self.hoverImgScale,self.hoverImgScale)
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
end

function game:setHoverImage(img)

self.hoverImg = img
self.hoverImgScale = (love.graphics.getHeight() - (30+5*(love.graphics.getHeight()-40)/7)) / img:getHeight()

end