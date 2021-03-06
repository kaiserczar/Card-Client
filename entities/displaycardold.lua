DisplayCard = class("DisplayCard")
DisplayCard.sessionUID = 1

function DisplayCard:initialize(game, name, img, imgNum, origX, origY, normalScale, hoverScale, isDefense, origAtk, origHealth, doesHover)

	self.game = game

	--Graphical
	self.x = origX or love.graphics.getWidth()/2
	self.y = origY or love.graphics.getHeight()/2
	self.origX = origX
	self.origY = origY
	self.normalScale = normalScale or 0.5
	self.hoverScale = hoverScale or 0.75
	self.origNormalScale = self.normalScale
	self.origHoverScale = self.hoverScale
	self.doesHover = doesHover or false

	--Card Information
	self.img = img or love.graphics.newImage('assets/img/card.png')
	self.imgNum = imgNum
	self.name = name or "blankCard"
	self.isDefense = isDefense or false
	self.origAtk = origAtk
	self.origHealth = origHealth
	self.curAtk = origAtk
	self.curHealth = origHealth
	self.cardID = 0

	--UI Control
	self.isDragging = false
	self.doReturnToOriginalPosition = false
	self.dragOffsetX = 0
	self.dragOffsetY = 0
	self.UID = DisplayCard.sessionUID
	DisplayCard.sessionUID = DisplayCard.sessionUID + 1
	self.zone = nil
	self.prevZone = nil
	self.wasMouseOver = false
	
	self.stdWidth = (self.img:getWidth()*self.normalScale)
	self.stdHeight = (self.img:getHeight()*self.normalScale)

end

function DisplayCard:getDebug()
	table.save({x=self.x,y=self.y,origX=self.origX,origY=self.origY,someTable={one=1,two=2,three=3}},"debugtablesave"..tostring(self.UID)..".file")
	print("Saved to file card id: "..tostring(self.UID))
end

function DisplayCard:update(dt)

	if self:isMouseOver(love.mouse.getX(),love.mouse.getY()) then
		if not self.wasMouseOver then
			self.game:setHoverImage(self.img)
			self.wasMouseOver = true
		end
	else
		if self.wasMouseOver then
			self.wasMouseOver = false
		end
	end

	if self.isDragging then
		self.x = love.mouse.getX() + self.dragOffsetX
		self.y = love.mouse.getY() + self.dragOffsetY
	else
		if not (self.x == self.origX) or not (self.y == self.origY) then
			-- Snap back to original.
			if self.doReturnToOriginalPosition then
				moveX = (self.origX - self.x)*0.25
				moveY = (self.origY - self.y)*0.25
				if moveX < 1 and moveX > -1 then
					self.x = self.origX
				end
				if moveY < 1 and moveY > 0 then
					self.y = self.origY
				end
				self.x = self.x + moveX
				self.y = self.y + moveY
			end
		end
	end

end

function DisplayCard:mousepressed(x, y, mbutton)

end

function DisplayCard:draw()

	if self:isMouseOver(love.mouse.getX(),love.mouse.getY()) and self.doesHover then
		love.graphics.draw(self.img, self.x, self.y, 0, self.hoverScale, self.hoverScale, self.img:getWidth()/2, self.img:getHeight()/2)
		love.graphics.setFont(fontBold[16])
		love.graphics.print(tostring(self.UID),self.x,self.y)
	else
		love.graphics.draw(self.img, self.x, self.y, 0, self.normalScale, self.normalScale, self.img:getWidth()/2, self.img:getHeight()/2)
		love.graphics.setFont(fontBold[24])
		love.graphics.print(tostring(self.UID),self.x,self.y)
	end

end

function DisplayCard:isMouseOver(x, y)
	return x >= self.x-self.img:getWidth()/2*self.normalScale and x <= self.x+self.img:getWidth()/2*self.normalScale and y <= self.y+self.img:getHeight()/2*self.normalScale and y >= self.y-self.img:getHeight()/2*self.normalScale
end

-- Given the space the card can fill, sets the maximum scaling.
function DisplayCard:setScalingMax(width, height)

	scaleX = width / self.img:getWidth()
	scaleY = height / self.img:getHeight()

	if scaleX < scaleY then
		self.normalScale = scaleX
		self.hoverScale = scaleX*1.5
	else
		self.normalScale = scaleY
		self.hoverScale = scaleY*1.5
	end
	
	self.stdWidth = (self.img:getWidth()*self.normalScale)
	self.stdHeight = (self.img:getHeight()*self.normalScale)
end

function DisplayCard:resetScaling()
	self.normalScale = self.origNormalScale
	self.hoverScale = self.origHoverScale
	self.stdWidth = (self.img:getWidth()*self.normalScale)
	self.stdHeight = (self.img:getHeight()*self.normalScale)
end

function DisplayCard:setZone(zone)
	self.zone = zone
	if zone ~= nil then
		self.doReturnToOriginalPosition = true
		--print("Card " .. tostring(self.UID) .. " moved to zone " .. tostring(zone.UID))
		self.prevZone = zone
	else
		self.doReturnToOriginalPosition = false
		--print("Card " .. tostring(self.UID) .. " moved to zone nil.")
		self.normalScale = self.origNormalScale
		self.hoverScale = self.origHoverScale
	end
end

function DisplayCard:getZone()
	return self.zone
end