CardList = class("CardList")

function CardList:initialize(name, formerCardList)
	
	self.name = name
	self.cardList = {}
	self.numCards = 0
	
	if formerCardList then
		for i, card in ipairs(formerCardList) do
			self:addCard(card)
		end
	end
	
end

function CardList:addCard(card)
	table.insert(self.cardList, {card=card, shuffle=math.random()})
	self.numCards = self.numCards + 1
end

function CardList:removeCard(card)
	for i, cardi in ipairs(self.cardList) do
		if cardi.card.cardID == card.cardID then
			table.remove(self.cards,i)
			self.numCards = self.numCards - 1
			break
		end
	end
end

function CardList:update(dt)

end

function CardList:mousepressed(x, y, mbutton)

end

function CardList:draw()

end

function getTotalCardLibrary()
	
	
	
end