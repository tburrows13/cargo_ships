local is_waterway_str = {
    ["water-way"]=true,
    ["buoy"]=true,
    ["chain_buoy"]=true,
    ["port"]=true,
    ["ship_pump"]=true,
    ["oil_rig"]=true,
    ["floating-electric-pole"]=true,
    ["bridge_base"]=true
  }

local function is_waterway(item)
  if item and item.valid_for_read then
    return is_waterway_str[item.name]
  end
  return false
end

local function validate_global()
  if not global.last_cursor_stack_name or type(global.last_cursor_stack_name) ~= "table" then
    global.last_cursor_stack_name = {}
  end
  if not global.last_distance_bonus or type(global.last_distance_bonus) ~= "number" then
    global.last_distance_bonus = settings.global["waterway_reach_increase"].value
  end
end

function increaseReach(e)
  local reach_setting = settings.global["waterway_reach_increase"].value
  if reach_setting > 0 then
    validate_global()
    local player = game.players[e.player_index]
    if not player.character then
      return
    end

    local cursor_stack = player.cursor_stack
    if (global.last_cursor_stack_name[e.player_index] and
        cursor_stack and cursor_stack.valid_for_read and
        global.last_cursor_stack_name[e.player_index] == cursor_stack.name) then
      return
    end

    if is_waterway(cursor_stack) then
      if not is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
        player.character.character_build_distance_bonus = player.character.character_build_distance_bonus + reach_setting
        player.character_reach_distance_bonus = player.character_reach_distance_bonus + reach_setting
      end
    elseif is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
      if player.character.character_build_distance_bonus - reach_setting >= 0 then
        player.character.character_build_distance_bonus = player.character.character_build_distance_bonus - reach_setting
        player.character.character_reach_distance_bonus = player.character.character_reach_distance_bonus - reach_setting
      end
    end
    if cursor_stack and cursor_stack.valid_for_read then
      global.last_cursor_stack_name[e.player_index] = cursor_stack.name
    else
      global.last_cursor_stack_name[e.player_index] = nil
    end
  end
end

function deadReach(e)
  local reach_setting = settings.global["waterway_reach_increase"].value
  if reach_setting > 0 then
    validate_global()
    local player = game.players[e.player_index]
    if is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
      if player.character.character_build_distance_bonus - reach_setting >= 0 then
        player.character.character_build_distance_bonus = player.character.character_build_distance_bonus - reach_setting
        player.character.character_reach_distance_bonus = player.character.character_reach_distance_bonus - reach_setting
      end
    end
    global.last_cursor_stack_name[e.player_index] = nil
  end
end

function applyReachChanges(e)
  validate_global()
  local reach_setting = settings.global["waterway_reach_increase"].value
  for _, player in pairs(game.players) do
    if is_waterway(player.cursor_stack) then
      if player.character.character_build_distance_bonus + (reach_setting - global.last_distance_bonus) >= 0 then
        player.character.character_build_distance_bonus = player.character.character_build_distance_bonus + (reach_setting - global.last_distance_bonus)
        player.character.character_reach_distance_bonus = player.character.character_reach_distance_bonus + (reach_setting - global.last_distance_bonus)
      else
        player.character.character_build_distance_bonus = player.character.character_build_distance_bonus + reach_setting
        player.character.character_reach_distance_bonus = player.character.character_reach_distance_bonus + reach_setting
      end
    end
  end
  global.last_distance_bonus = reach_setting
--[[
  if e.setting == "waterway_reach_increase" then
    validate_global()
    for _,player in pairs(game.players) do
      if is_waterway(player.cursor_stack) then
        if settings.global["waterway_reach_increase"].value == false then
          if (player.character.character_build_distance_bonus - global.last_distance_bonus) >= 0 then
            player.character.character_build_distance_bonus = player.character.character_build_distance_bonus - global.last_distance_bonus
          else
            player.character.character_build_distance_bonus = 0
          end
        else
          player.character.character_build_distance_bonus = player.character.character_build_distance_bonus + settings.global["waterway_reach_increase"].value
        end
      end
    end
  end
--]]
end
