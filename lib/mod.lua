local mods = require 'core/mods'

--
-- behavior
--

local system_routes_reversed = {
  ["system:capture_1"] = "crone:input_2",
  ["system:capture_2"] = "crone:input_1",
  ["crone:output_1"]   = "system:playback_2",
  ["crone:output_2"]   = "system:playback_1",
}

local replace_routing = function()
  print("reversing system i/o channels")
  audio.with_change_tracking_disabled(function()
    audio.routing_disconnect(audio.default_system_routes)
    audio.default_system_routes = system_routes_reversed
    audio.routing_connect(audio.default_system_routes)
  end)
end

mods.hook.register("system_post_startup", "reversing io", replace_routing)

--
-- ui
--

local ui = {}

ui.init = function() end
ui.deinit = function() end

ui.key = function(n, z)
  -- exit on any key press
  if z > 0 then
    mods.menu.exit()
  end
end

ui.enc = function(n, d)
end

ui.redraw = function()
  screen.clear()
  screen.level(15)
  screen.move(0, 10)
  screen.text("to restore normal i/o routing:")
  screen.move(0, 20)
  screen.text("- disable this mod")
  screen.move(0, 30)
  screen.text("- SYSTEM > RESTART")
  screen.update()
end

mods.menu.register(mods.this_name, ui)