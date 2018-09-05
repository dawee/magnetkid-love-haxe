local game = require('game')

local ref_table = {}

local function create_ref(value)
  local ref = #ref_table + 1

  ref_table[ref] = value

  return ref
end

local function wrap(func)
  return function (__, ...)
    func(...)
  end
end

local api = {
  graphics = {
    rectangle = wrap(love.graphics.rectangle),
    setBackgroundColor = wrap(love.graphics.setBackgroundColor),
    setColor = wrap(love.graphics.setColor),
  }
}

function api.graphics.draw(__, image, quad, ...)
  love.graphics.draw(
    ref_table[image.__ref__],
    ref_table[quad.__ref__],
    ...
  )
end

function api.graphics.newQuad(__, ...)
  local quad = love.graphics.newQuad(...)
  local ref = create_ref(quad)

  return {
    __ref__ = ref,
    __type__ = "quad"
  }
end

function api.graphics.newImage(__, ...)
  local image = love.graphics.newImage(...)
  local ref = create_ref(image)

  return {
    __ref__ = ref,
    __type__ = "image",
    getDimensions = function ()
      local width, height = image:getDimensions()

      return { width = width, height = height }
    end
  }
end

game.__love_Love.registerAPI(api)

local bridge = game.__love_Love.bridge

local love_entry_points = {
  "load",
  "update",
  "draw"
}

for __, entry_point in ipairs(love_entry_points) do
  love[entry_point] = function (...)
    return bridge[entry_point](bridge, ...)
  end
end
