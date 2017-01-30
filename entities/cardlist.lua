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

function CardList:addCard(card,inOrder)
  if inOrder then
    table.insert(self.cardList, {card=card, shuffle=card.cardID})
  else
    table.insert(self.cardList, {card=card, shuffle=math.random()})
  end
  --self.cardList[tostring(card.cardID)]={card=card, shuffle=math.random()}
	self.numCards = self.numCards + 1
end

function CardList:removeCard(card)
--  self.cardList[tostring(card.cardID)]=nil
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

function CardList:shuffle()
	for i,cardRecord in ipairs(self.cardList) do
		self.cardList[i].shuffle = math.random()
	end
	table.sort(self.cardList,cardCompare)
end

function CardList:save(filename)
	filename = filename or self.name..".txt"
	table.save({list=self.cardList,numCards=self.numCards},filename)
end

function CardList.load(listname, filename)
	loadedlist = table.load(filename)
	list = CardList:new(listname)
	list.cardList = loadedlist.list
	list.numCards = loadedlist.numCards
	return list
end

function cardCompare(a,b)
	return a.shuffle < b.shuffle
end