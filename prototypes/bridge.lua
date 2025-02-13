local emptypic = {
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}

--bridge.collision_box = {{-6,-3},{6,3}}

local function build_bridge_anim(ori, shiftx, shifty)
  local width = 436
  local height = 930
  if ori == "n" or ori == "s" then
    width = 872
    height = 436
  end

  local function imageloop(filename)
    local filelist = {}
    for i=1,20 do
      local file = {filename = "__cargo-ships__/graphics/entity/bridge/" .. filename .. i .. ".png", width_in_frames = 1, height_in_frames = 1}
      if i == 1 then file.filename = "__cargo-ships__/graphics/entity/bridge/" .. filename .. 0 .. ".png" end
      table.insert(filelist, file)
    end
    return filelist
  end

  return {
    layers = {
      {
        stripes = imageloop("bridge-" .. ori .. "-"),
        animation_speed = 0.4,
        --line_length = 1,
        width = width,
        height = height,
        frame_count = 20,
        axially_symmetrical = false,
        direction_count = 1,
        shift = util.by_pixel(shiftx, shifty),
        scale = 0.5,
      },
      {
        stripes = imageloop("bridge-" .. ori .. "-shadow-"),
        animation_speed = 0.4,
        --line_length = 1,
        width = width,
        height = height,
        frame_count = 20,
        axially_symmetrical = false,
        direction_count = 1,
        draw_as_shadow = true,
        shift = util.by_pixel(shiftx, shifty),
        scale = 0.5,
      },
    }
  }
end

local function water_reflection(dir, num, x, y, shiftx, shifty)
  return {
    pictures = {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-" .. dir .. "-" .. num .."-water-reflection.png",
      width = x,
      height = y,
      shift = util.by_pixel(shiftx, shifty),
      variation_count = 1,
      scale = 5
    },
    rotate = false,
    orientation_to_variation = false
  }
end



local bridge = table.deepcopy(data.raw["train-stop"]["port"])
bridge.name = "bridge_base"
bridge.localised_description = {"description-template.bridge_base", {"entity-description.bridge_north_clickable"}}
bridge.animations = make_4way_animation_from_spritesheet({
  layers = {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-base.png",
      --line_length = 4,
      width = 275,
      height = 275,
      direction_count = 4,
      scale = 1.7,
      shift = util.by_pixel(-0.5, 0),
    }
  }
})
data:extend({bridge})

----------------------------------------------------------------------------------
--------------------------------- NORTH ------------------------------------------
----------------------------------------------------------------------------------

local shiftX = 53
local shiftY = -17.5

local bridge_north = table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_north.name = "bridge_north"
bridge_north.led_on = emptypic
bridge_north.led_off = emptypic
bridge_north.power_on_animation = build_bridge_anim("n", shiftX, shiftY)
bridge_north.minable = nil
bridge_north.destructible = false
bridge_north.collision_box = {{-1,-1},{1,1}}
bridge_north.collision_mask = {}
bridge_north.selection_box = nil
bridge_north.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north.selectable_in_game = false
bridge_north.allow_copy_paste = false
bridge_north.created_smoke = nil
bridge_north.water_reflection = water_reflection("n", 20, 87, 44, shiftX, shiftY)

data:extend({bridge_north})

local bridge_north_closed = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_closed.name = "bridge_north_closed"

bridge_north_closed.minable = nil
bridge_north_closed.selection_box = nil
bridge_north_closed.collision_box = {{-4,-2}, {6,2}}
bridge_north_closed.collision_mask = {} --collision with boats
bridge_north_closed.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_closed.selectable_in_game = false
bridge_north_closed.allow_copy_paste = false
bridge_north_closed.render_layer = "object"
bridge_north_closed.created_smoke = nil
bridge_north_closed.picture = {
  layers = {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-n-shadow-1.png",
      width = 872,
      height = 436,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5,
      draw_as_shadow = true
    },
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-n-1.png",
      width = 872,
      height = 436,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5
    },
  }
}
bridge_north_closed.water_reflection = water_reflection("n", 1, 87, 44, shiftX, shiftY)

data:extend({bridge_north_closed})

----------------------------------------------------------------------------------
--------------------------------- SOUTH ------------------------------------------
----------------------------------------------------------------------------------

shiftX = -6.5
shiftY = -19

local bridge_south = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_south.name = "bridge_south"
bridge_south.power_on_animation = build_bridge_anim("s", shiftX, shiftY)
bridge_south.water_reflection = water_reflection("s", 20, 87, 44, shiftX, shiftY)

local bridge_south_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_south_closed.name = "bridge_south_closed"
bridge_south_closed.collision_box = {{-6,-2}, {4,2}}
bridge_south_closed.picture = {
  layers = {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-s-shadow-1.png",
      width = 872,
      height = 436,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5,
      draw_as_shadow = true
    },
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-s-1.png",
      width = 872,
      height = 436,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5
    },
  }
}
bridge_south_closed.water_reflection = water_reflection("s", 1, 87, 44, shiftX, shiftY)

----------------------------------------------------------------------------------
--------------------------------- east -------------------------------------------
----------------------------------------------------------------------------------

shiftX = 24
shiftY = 22.5

local bridge_east = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_east.name = "bridge_east"
bridge_east.power_on_animation = build_bridge_anim("e", shiftX, shiftY)
bridge_east.water_reflection = water_reflection("e", 20, 44, 94, shiftX, shiftY+32)

local bridge_east_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_east_closed.name = "bridge_east_closed"
bridge_east_closed.collision_box = {{-2,-4}, {2,6}}
bridge_east_closed.picture = {
  layers = {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-e-shadow-1.png",
      width = 436,
      height = 930,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5,
      draw_as_shadow = true
    },
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-e-1.png",
      width = 436,
      height = 930,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5
    },
  }
}
bridge_east_closed.water_reflection = water_reflection("e", 1, 44, 94, shiftX, shiftY+32)

----------------------------------------------------------------------------------
--------------------------------- west -------------------------------------------
----------------------------------------------------------------------------------

shiftX = 24
shiftY = -53

local bridge_west = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_west.name = "bridge_west"
bridge_west.power_on_animation = build_bridge_anim("w", shiftX, shiftY)
bridge_west.water_reflection = water_reflection("w", 20, 44, 94, shiftX, shiftY)

local bridge_west_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_west_closed.name = "bridge_west_closed"
bridge_west_closed.collision_box = {{-2,-6}, {2,4}}
bridge_west_closed.picture = {
  layers = {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-w-shadow-1.png",
      width = 436,
      height = 930,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5,
      draw_as_shadow = true
    },
    {
      filename = "__cargo-ships__/graphics/entity/bridge/bridge-w-1.png",
      width = 436,
      height = 930,
      shift = util.by_pixel(shiftX, shiftY),
      scale = 0.5
    },
  }
}
bridge_west_closed.water_reflection = water_reflection("w", 1, 44, 94, shiftX, shiftY+32)

data:extend({bridge_south, bridge_south_closed, bridge_east, bridge_east_closed, bridge_west, bridge_west_closed})

----------------------------------------------------------------------------------------------------------------------------------

local invisible_chain_signal = table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"
invisible_chain_signal.selection_box = nil
invisible_chain_signal.destructible = false
invisible_chain_signal.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
invisible_chain_signal.selectable_in_game = false
invisible_chain_signal.collision_mask = {'rail-layer'}
invisible_chain_signal.allow_copy_paste = false
invisible_chain_signal.minable = nil
invisible_chain_signal.animation = {
  filename = "__cargo-ships__/graphics/blank.png",
  priority = "high",
  width = 2,
  height = 2,
  frame_count = 3,
  direction_count = 8,
}
invisible_chain_signal.rail_piece = nil
invisible_chain_signal.green_light = nil
invisible_chain_signal.orange_light = nil
invisible_chain_signal.red_light = nil
invisible_chain_signal.blue_light = nil
invisible_chain_signal.fast_replaceable_group = nil
invisible_chain_signal.created_smoke = nil
data:extend({invisible_chain_signal})


local bridge_north_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_clickable.name = "bridge_north_clickable"
bridge_north_clickable.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_clickable.minable = {mining_time = 1, result = "bridge_base"}
bridge_north_clickable.selection_box = {{-5,-3},{7,3}}
bridge_north_clickable.collision_box = {{-5,-3},{7,3}}
bridge_north_clickable.collision_mask = {"object-layer", "layer-14"}
bridge_north_clickable.max_health = 500
bridge_north_clickable.picture = emptypic
bridge_north_clickable.created_smoke = nil
data:extend({bridge_north_clickable})

local bridge_east_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
local bridge_south_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
local bridge_west_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])

bridge_east_clickable.name = "bridge_east_clickable"
bridge_south_clickable.name = "bridge_south_clickable"
bridge_west_clickable.name = "bridge_west_clickable"

bridge_east_clickable.localised_description = {"entity-description.bridge_north_clickable"}
bridge_south_clickable.localised_description = {"entity-description.bridge_north_clickable"}
bridge_west_clickable.localised_description = {"entity-description.bridge_north_clickable"}

bridge_east_clickable.collision_box = {{-3,-5},{3,7}}
bridge_south_clickable.collision_box = {{-7,-3},{5,3}}
bridge_west_clickable.collision_box = {{-3,-7},{3,5}}

bridge_east_clickable.selection_box = {{-3,-5},{3,7}}
bridge_south_clickable.selection_box = {{-7,-3},{5,3}}
bridge_west_clickable.selection_box = {{-3,-7},{3,5}}

data:extend({bridge_south_clickable, bridge_east_clickable, bridge_west_clickable})

local bridge_north_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
local bridge_east_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_east_closed"])
local bridge_south_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_south_closed"])
local bridge_west_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_west_closed"])

bridge_north_open.name = "bridge_north_open"
bridge_east_open.name = "bridge_east_open"
bridge_south_open.name = "bridge_south_open"
bridge_west_open.name = "bridge_west_open"

bridge_north_open.minable = nil
bridge_east_open.minable = nil
bridge_south_open.minable = nil
bridge_west_open.minable = nil

bridge_north_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_open.selectable_in_game = false
bridge_north_open.allow_copy_paste = false
bridge_east_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_east_open.selectable_in_game = false
bridge_east_open.allow_copy_paste = false
bridge_south_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_south_open.selectable_in_game = false
bridge_south_open.allow_copy_paste = false
bridge_west_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_west_open.selectable_in_game = false
bridge_west_open.allow_copy_paste = false

bridge_north_open.collision_mask = {}
bridge_east_open.collision_mask = {}
bridge_south_open.collision_mask = {}
bridge_west_open.collision_mask = {}

bridge_north_open.picture = emptypic
bridge_east_open.picture = emptypic
bridge_south_open.picture = emptypic
bridge_west_open.picture = emptypic
data:extend({bridge_north_open, bridge_south_open, bridge_east_open, bridge_west_open})
