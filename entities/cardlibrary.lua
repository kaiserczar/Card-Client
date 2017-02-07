CardLibrary = class("CardLibrary")

function CardLibrary:initialize()
  
  self:reload()
  
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

function CardLibrary:reload()
  
  if DEBUG then print("Library is reloading all cards.") end
  
  -- Clear whatever we might have.
  self.cardList = CardList:new("Library")
  
  -- Grab all lua files in a directory. Load each into memory
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('dir "cards" /b')
  for filename in pfile:lines() do
    if string.lower(string.sub(filename,string.len(filename)-2,-1)) == 'lua' then
      filename = string.format('cards.%s',string.sub(filename, 1, string.len(filename) - 4))
      curCardSet = require(filename)
      curCardSet:loadCards(self)
    end
  end
  pfile:close()
  
  if DEBUG then print("Library is finished reloading all cards.") end
end
