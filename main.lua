DEBUG = true

-- libraries
class = require 'lib.middleclass'
vector = require 'lib.vector'
state = require 'lib.state'
serialize = require 'lib.ser'
signal = require 'lib.signal'
sock = require 'lib.sock'
require 'lib.util'
bitser = require 'lib.bitser'
require 'lib.tablesave'


-- gamestates
require 'states.menu'
require 'states.game'
require 'states.options'
require 'states.join'
require 'states.host'
require 'states.admin'
require 'states.adminPassword'

-- entities
require 'entities.sound'
require 'entities.card'
require 'entities.cardzone'
require 'entities.displaycard'
require 'entities.creaturecard'
require 'entities.constructioncard'
require 'entities.resourcecard'
require 'entities.spellcard'
require 'entities.cardlist'
require 'entities.cardlibrary'

-- ui
require 'lib.ui.button'
require 'lib.ui.checkbox'
require 'lib.ui.input'
require 'lib.ui.list'
require 'lib.ui.slider'

cursorImg = nil

cardLibrary = CardLibrary:new()

function love.load(arg)

	if arg[#arg] == "-debug" then require("mobdebug").start() end
	
  _font = 'assets/font/OpenSans-Regular.ttf'
  _fontBold = 'assets/font/OpenSans-Bold.ttf'
  _fontLight = 'assets/font/OpenSans-Light.ttf'

  font = setmetatable({}, {
      __index = function(t,k)
          local f = love.graphics.newFont(_font, k)
          rawset(t, k, f)
          return f
      end 
  })

  fontBold = setmetatable({}, {
      __index = function(t,k)
          local f = love.graphics.newFont(_fontBold, k)
          rawset(t, k, f)
          return f
      end
  })

  fontLight = setmetatable({}, {
      __index = function(t,k)
          local f = love.graphics.newFont(_fontLight, k)
          rawset(t, k, f)
          return f
      end 
  })

  love.window.setIcon(love.image.newImageData('assets/img/icon.png'))
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setFont(font[14])

  state.registerEvents()
  state.switch(menu)

  math.randomseed(os.time()/10)

  -- Sound is instantiated before the game because it observes things beyond the game scope
  soundManager = Sound:new()

  if not love.filesystem.exists(options.file) then
      options:save(options:getDefaultConfig())
  end

	cursorImg = love.graphics.newImage('assets/img/circleCursor.png')
	love.mouse.setVisible(false)
	
  options:load()
  
end

function love.keypressed(key, code)

end

function love.mousepressed(x, y, mbutton)
    
end

function love.textinput(text)

end

function love.resize(w, h)

end

function love.update(dt)
    
end

function love.draw()

end