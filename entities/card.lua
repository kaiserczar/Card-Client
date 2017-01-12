Card = class("Card")
Card.cardTypes = {"Creature", "Construction", "Resource", "Spell"}

function Card:initialize(game, cardID, name, text, cardType, isToken)

	self.game = game

	--Card Information
	self.type = cardType
	self.name = name
	self.cardID = 0
	self.text = text
	self.isToken = isToken or false

end

function Card:update(dt)

end

function Card:mousepressed(x, y, mbutton)

end

function Card:draw()

end