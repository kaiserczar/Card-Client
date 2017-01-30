ResourceCard = class("ResourceCard", Card)

function ResourceCard:initialize(game, cardID, name, text, isToken, attributes, isShiny)

	Card.initialize(self, game, cardID, name, text, "Resource", isToken, attributes, isShiny)
	
	-- Resource info

end

function ResourceCard:update(dt)

end

function ResourceCard:mousepressed(x, y, mbutton)

end

function ResourceCard:draw()

end