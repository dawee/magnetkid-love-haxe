local bridge = require('game')

local ref_table = {}

local function wrap(func)
  return function (__, ...)
    func(...)
  end
end

local bridge = {
  graphics = {
    rectangle = wrap(love.graphics.rectangle),
  }
}

function bridge.graphics.newQuad(__, ...)
  local quad = love.graphics.newQuad(...)
  local ref = #ref_table + 1

  ref_table[ref] = quad

  return {
    __ref__ = ref,
    __type__ = "quad"
  }
end

local game = bridge.Game.new(bridge)

function love.load()
  game:load()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end
