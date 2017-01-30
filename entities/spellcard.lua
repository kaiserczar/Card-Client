SpellCard = class("SpellCard", Card)

function SpellCard:initialize(game, cardID, name, text, isToken, attributes, spCost, isReactionary, isShiny)

	Card.initialize(self, game, cardID, name, text, "Spell", isToken, attributes, isShiny)
	
	-- Spell info
	self.spCost = spCost
	self.isReactionary = isReactionary or false

end

function SpellCard:update(dt)

end

function SpellCard:mousepressed(x, y, mbutton)

end

function SpellCard:draw()

end