Card = class("Card")

function Card:initialize(game, cardID, name, text, cardType, isToken, attributes, isShiny)
  if DEBUG then print("New card, id: "..cardID) end
	self.game = game

	--Card Information
	self.type = cardType
	self.name = name
	self.cardID = cardID
	self.text = text
	self.isToken = isToken or false
	self.attributes = attributes or {}
  self.isShiny = isShiny or false

end

function Card:update(dt)

end

function Card:mousepressed(x, y, mbutton)

end

function Card:draw()

end