CardLibrary = class("CardLibrary")

function CardLibrary:initialize()
  
  self.cardList = CardList:new("Library")
  
end

function CardLibrary:getCardFromId(idnum)
  for i,cardEntry in ipairs(self.cardList) do
    if cardEntry.card.cardID == idnum then
      return cardEntry.card
    end
  end
  return nil
end

function CardLibrary:update(dt)
  
end

function CardLibrary:draw()
  
end
