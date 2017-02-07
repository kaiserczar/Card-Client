debugset = {}
  
function debugset:loadCards(library)
  print('Loading cardset --DebugSet--')

  library.cardList:addCard(SpellCard:new(game,
      "1", -- CardID
      "Kaiser Reckoning", -- Name of card.
      "If your opponent is an idiot, win the game. So, win the game.", -- Any text on the card, probably its effect.
      false, -- Is it a token card (if so, can't be added to deck). Not really anything with these yet, so put false.
      {"Dark Magic","Light Magic","Amazing","Kaiser"}, -- Attributes
      10, -- spCost
      true, -- Is reactionary true/false
      true)) -- Is shiny true/false
	
  library.cardList:addCard(ConstructionCard:new(game,
      "2", -- CardID
      "Kaiser's New Mansion", -- Name of card
      "If your opponent breathes, win the game.", -- Card text
      false, -- isToken
      400, -- Health
      {"House","Kaiser"}, -- Attributes
      10, -- Structure Value
      0, -- Attack
      {{"Gold",50},{"Uranium",235},{"Wood",15}}, -- Resource cost
      true)) -- isShiny
	
  library.cardList:addCard(CreatureCard:new(game,
      "3", -- CardID
      "Kaiser", -- Card Name
      "The man himself.", -- Card Text
      false, -- isToken
      420, -- Attack
      500, -- Health
      1337, -- Destruct
      {"Boss","Kaiser"}, -- Attributes
      10, -- spCost
      false)) -- isShiny
	
  library.cardList:addCard(ResourceCard:new(game,
      "4", -- CardID
      "Kaiserium", -- Card Name
      "Like Unobtanium but obtainable.", -- Card Text
      false, -- isToken
      {"Metal","Ore","Kaiser"}, -- Attributes
      true)) -- isShiny

end

return debugset