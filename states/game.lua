game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:init()
	self.zones = {}
	table.insert(self.zones,CardZone:new("p2MainHand",5,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p2ResHand",10+(love.graphics.getWidth()-15)/2,5,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p2Construction",5,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p2Spell",10+(love.graphics.getWidth()-15)/2,10+(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p2Creature",5,15+2*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p1Creature",5,20+3*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-10),(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p1Construction",5,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p1Spell",10+(love.graphics.getWidth()-15)/2,25+4*(love.graphics.getHeight()-40)/7,(love.graphics.getWidth()-15)/2,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p1ResHand",5+love.graphics.getWidth()/2,30+5*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	table.insert(self.zones,CardZone:new("p1MainHand",5+love.graphics.getWidth()/2,35+6*(love.graphics.getHeight()-40)/7,love.graphics.getWidth()/2-10,(love.graphics.getHeight()-40)/7))
	self.isFieldFlipped = false
	
	self.isHost = false
	self.server = nil
	self.client = nil
end

function game:enter(prev, isHost, client, server)
	
	self.isHost = isHost
	if self.isHost then
		self.server = server
		self:registerServerEvents()
	else
		self.server = nil
	end
	self.client = client
	self:registerClientEvents()
	
	self.cards = {}
	for i, zone in ipairs(self.zones) do
		zone:clearCards()
	end
	
	if not isHost then
		self:flipField()
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
	
	if self.isHost then
		self.server:update()
	end
	self.client:update()
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
	elseif key == "p" then
		for i, card in ipairs(self.cards) do
			card:getDebug()
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
function game:setHoverCard(card)
  self.hoverCard = card
  self.hoverImg = card.img
  self.hoverImgScale = (love.graphics.getHeight() - (30+5*(love.graphics.getHeight()-40)/7)) / self.hoverImg:getHeight()
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
	print("setting up client events")
	self.client:on("connect",function(data)
		print("Successfully connected to server!")
	end)
	self.client:on("disconnect",function(data)
		print("Disconnected from server.")
	end)
	
	self.client:on("newCard",function(data)
    if DEBUG then
      print("Spawning new card; client-side event starts here.")
      print("     Size of cardListAlpha: "..tostring(#(cardListAlpha.cardList)))
      for i, card in ipairs(cardListAlpha.cardList) do
        print("     Card #"..tostring(i).." id is: "..tostring(card.card.cardID))
      end
    end
    
      --(game, card, origX, origY, normalScale, hoverScale, isDefense, doesHover)
    newCard = DisplayCard:new(self,cardListAlpha.cardList[data.imgNum].card,data.x,data.y,0.5,0.75,false,false)
--		if data.imgNum==1 then
--			newCard = DisplayCard:new(self,"placeholder",love.graphics.newImage('assets/img/card1.jpg'),1,data.x,data.y,0.5,0.75,false,100,100)
--		elseif data.imgNum==2 then
--			newCard = DisplayCard:new(self,"placeholder",love.graphics.newImage('assets/img/card2.jpg'),2,data.x,data.y,0.5,0.75,false,100,100)
--		elseif data.imgNum==3 then
--			newCard = DisplayCard:new(self,"placeholder",love.graphics.newImage('assets/img/card3.jpg'),3,data.x,data.y,0.5,0.75,false,100,100)
--		else
--			newCard = DisplayCard:new(self,"placeholder",love.graphics.newImage('assets/img/card4.jpg'),4,data.x,data.y,0.5,0.75,false,100,100)
--		end
		
		table.insert(self.cards,newCard)
		print(data.zoneID)
		print(newCard)
		getZoneFromUID(data.zoneID):addCard(newCard)
	end)
	
	self.client:on("moveCard", function(data)
		card = self:getCardFromID(data.card)
		card.prevZone:removeCard(card)
		zone = getZoneFromUID(data.zone)
		zone:addCard(card)
	end)
	print("finished setting up client events")
	
	self.client:connect()
end

function game:registerServerEvents()
	print("setting up server events")
	self.server:on("connect", function(data,client)
		print("Got a new connection from client "..tostring(client:getIndex()))
		-- Update the new client with current cards.
		for i,card in ipairs(self.cards) do
			client:send("newCard", {zoneID = card.zone.UID,imgNum = card.imgNum, x=0,y=0})
		end
	end)
	
	self.server:on("disconnect", function(data,client)
		print("Client disconnect, id: "..tostring(client:getIndex()))
	end)
	
	self.server:on("newCard", function(data,client)
		whichPic = math.random(4)
		self.server:sendToAll("newCard",{zoneID = 6,imgNum = whichPic,x=data.x,y=data.y})
	end)
	
	self.server:on("moveCard", function(data,client)
		self.server:sendToAll("moveCard",data)
	end)
	
	print("finished setting up server events.")
end

function game:flipField()
	if self.isFieldFlipped then
		-- Restore original field.
		for i,zone in ipairs(self.zones) do
			if zone.name == "p2MainHand" then
				zone.x = 5
				zone.y = 5
			elseif zone.name == "p2ResHand" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 5
			elseif zone.name == "p2Construction" then
				zone.x = 5
				zone.y = 10+(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2Spell" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 10+(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2Creature" then
				zone.x = 5
				zone.y = 15+2*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1Creature" then
				zone.x = 5
				zone.y = 20+3*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1Construction" then
				zone.x = 5
				zone.y = 25+4*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1Spell" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 25+4*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1ResHand" then
				zone.x = 5+love.graphics.getWidth()/2
				zone.y = 30+5*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1MainHand" then
				zone.x = 5+love.graphics.getWidth()/2
				zone.y = 35+6*(love.graphics.getHeight()-40)/7
			end
		end
	else
		for i,zone in ipairs(self.zones) do
			if zone.name == "p1MainHand" then
				zone.x = 5
				zone.y = 5
			elseif zone.name == "p1ResHand" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 5
			elseif zone.name == "p1Construction" then
				zone.x = 5
				zone.y = 10+(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1Spell" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 10+(love.graphics.getHeight()-40)/7
			elseif zone.name == "p1Creature" then
				zone.x = 5
				zone.y = 15+2*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2Creature" then
				zone.x = 5
				zone.y = 20+3*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2Construction" then
				zone.x = 5
				zone.y = 25+4*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2Spell" then
				zone.x = 10+(love.graphics.getWidth()-15)/2
				zone.y = 25+4*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2ResHand" then
				zone.x = 5+love.graphics.getWidth()/2
				zone.y = 30+5*(love.graphics.getHeight()-40)/7
			elseif zone.name == "p2MainHand" then
				zone.x = 5+love.graphics.getWidth()/2
				zone.y = 35+6*(love.graphics.getHeight()-40)/7
			end
		end
	end
	
	self.isFieldFlipped = not self.isFieldFlipped
end

