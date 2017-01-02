game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:init()
	self.zones = {}
	table.insert(self.zones,CardZone:new("foeMainHand",5,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeResHand",10+(love.graphics.getWidth()-15)/2,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeConstruction",5,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeSpell",10+(love.graphics.getWidth()-15)/2,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("foeCreature",5,15+2*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youCreature",5,20+3*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youConstruction",5,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youSpell",10+(love.graphics.getWidth()-15)/2,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youResHand",5+love.graphics.getWidth()/2,30+5*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("youMainHand",5+love.graphics.getWidth()/2,35+6*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	
	self.isSingle = true
	self.isHost = false
	self.server = nil
	self.client = nil
end

function game:enter(prev, isSingle, isHost, client, server)
	
	self.isSingle = isSingle
	if self.isSingle then
		self.isHost = false
		self.client = nil
		self.server = nil
	else
		self.isHost = isHost
		if self.isHost then
			self.server = server
			self:registerServerEvents()
		else
			self.server = nil
		end
		self.client = client
		self:registerClientEvents()
	end
	
	self.cards = {}
	for i, zone in ipairs(self.zones) do
		zone:clearCards()
	end
	
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
	
	print("Singleplayer: "..tostring(self.isSingle))
	if not self.isSingle then
		print("Hosting: "..tostring(self.isHost))
		if self.isHost then
			self.server:update()
		end
		self.client:update()
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
		client:send("newCard",{x=love.mouse.getX(),y=love.mouse.getY()})
	elseif key == "escape" then
        state.switch(menu)
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
			isInZone = false
			for i, zone in ipairs(self.zones) do
				if zone:isInZone(card.x,card.y) then
					-- enter the zone here
					self.client:send("moveCard",{card=card.UID,zone=zone.UID})
					isInZone = true
					break
				end
			end
			if not isInZone then
				card.prevZone:addCard(card)
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

function game:getCardFromID(uid)
	for i,card in ipairs(self.cards) do
		if card.UID == uid then
			return card
		end
	end
	return nil
end

function game:registerClientEvents()
	self.client:on("connect",function(data)
		print("Successfully connected to server!")
	end)
	self.client:on("disconnect",function(data)
		print("Disconnected from server.")
	end)
	
	self.client:on("newCard",function(data)
		newCard = data.card
		newCardZoneID = data.zoneID
		table.insert(self.cards,newCard)
		getZoneFromID(newCardZoneID):addCard(newCard)
	end)
	
	self.client:on("moveCard", function(data)
		card = self.getCardFromID(data.card)
		zone = getZoneFromID(data.zone)
		zone.addCard(card)
	end)
end

function game:registerServerEvents()
	self.server:on("connect", function(data,client)
		print("Got a new connection from client "..tostring(client:getIndex()))
		-- Update the new client with current cards.
		for i,card in ipairs(self.cards) do
			client:emit("newCard", card)
		end
	end)
	
	self.server:on("disconnect", function(data,client)
		print("Client disconnect, id: "..tostring(client:getIndex()))
	end)
	
	self.server:on("newCard", function(data,client)
		whichPic = math.random(4)
		if whichPic==1 then
			newCard = Card:new(self,"placeholder",love.graphics.newImage('assets/img/card1.jpg'),data.x,data.y,0.5,0.75,false,100,100)
		elseif whichPic==2 then
			newCard = Card:new(self,"placeholder",love.graphics.newImage('assets/img/card2.jpg'),data.x,data.y,0.5,0.75,false,100,100)
		elseif whichPic==3 then
			newCard = Card:new(self,"placeholder",love.graphics.newImage('assets/img/card3.jpg'),data.x,data.y,0.5,0.75,false,100,100)
		else
			newCard = Card:new(self,"placeholder",love.graphics.newImage('assets/img/card4.jpg'),data.x,data.y,0.5,0.75,false,100,100)
		end
		newCard.name = "card"..tostring(newCard.UID)
		self.server:emitToAll("newCard",{card = newCard, zoneID = 6})
	end)
	
	self.server:on("moveCard", function(data,client)
		self.server:emitToAll("moveCard",data)
	end)
end