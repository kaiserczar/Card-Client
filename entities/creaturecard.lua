CreatureCard = class("CreatureCard", Card)

function CreatureCard:initialize(game, cardID, name, text, isToken, attack, health, destruct, attributes, spCost)

	Card.initialize(self, game, cardID, name, text, "Creature", isToken)
	
	-- Creature info
	self.origAtk = attack
	self.curAtk = attack
	self.origHp = health
	self.curHp = health
	self.origDestruct = destruct
	self.curDestruct = destruct
	self.attributes = attributes
	self.spCost = spCost

end

function CreatureCard:update(dt)

end

function CreatureCard:mousepressed(x, y, mbutton)

end

function CreatureCard:draw()

end