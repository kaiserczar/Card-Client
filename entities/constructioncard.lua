ConstructionCard = class("ConstructionCard", Card)

function ConstructionCard:initialize(game, cardID, name, text, isToken, health, attributes, sv, attack, resourceCost)

	Card.initialize(self, game, cardID, name, text, "Construction", isToken)
	
	-- Construction info
	self.origAtk = attack or 0
	self.curAtk = attack or 0
	self.origHp = health
	self.curHp = health
	self.attributes = attributes
	self.sv = sv
	self.resourceCost = resourceCost

end

function ConstructionCard:update(dt)

end

function ConstructionCard:mousepressed(x, y, mbutton)

end

function ConstructionCard:draw()

end