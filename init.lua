require "hs.ipc"
require "preload"
require "window" 


WIDTH=hs.screen.primaryScreen():currentMode().w
HEIGHT=hs.screen.primaryScreen():currentMode().h
THIRD_WIDTH=WIDTH/3

local localLayouts = {
  [1] = { 0, 0 },
  [2] = { ['x'] = THIRD_WIDTH , ["y"] = 0 },
  [3] = { ['x'] = THIRD_WIDTH * 2, ["y"] = 0 },
}

local lastLayoutIndex = 1 

function nextLayout()
  local nextPoint = 0 + THIRD_WIDTH
  hs.window.focusedWindow():moveToUnit('[0,0 33,100]')
  hs.window.focusedWindow():move(localLayouts[lastLayoutIndex])
  lastLayoutIndex = lastLayoutIndex + 1
  if lastLayoutIndex > #localLayouts then lastLayoutIndex = 1 end
end


-- https://github.com/oniatsu/HotSwitch-HS
local hotswitchHs = require("hotswitch-hs/hotswitch-hs")
hotswitchHs.enableAutoUpdate() -- If you don't want to update automatically, remove this line.
hs.hotkey.bind({"command"}, ".", hotswitchHs.openOrClose) -- Set a keybind you like to open HotSwitch-HS panel.

-- rightCommand setup
rightCommand = hs.hotkey.modal.new({}, nil)
rightCommand.pressed = function() rightCommand:enter() end
rightCommand.released = function() rightCommand:exit() end
hs.hotkey.bind({}, 'F19', rightCommand.pressed, rightCommand.released)
-- rightCommand bind
rightCommand:bind({}, 'm', nil, function()
    local focused = hs.window.focusedWindow()
    hs.layout.apply({ {nil, focused, focused:screen(), hs.layout.maximized, 0, 0} })
end)
rightCommand:bind({}, 'f', nil, function()
  hs.window.focusedWindow():centerOnScreen()
end)
----

-- rightOption setup
rightOption = hs.hotkey.modal.new({}, nil)
rightOption.pressed = function() rightOption:enter() end
rightOption.released = function() rightOption:exit() end
hs.hotkey.bind({}, 'F20', rightOption.pressed, rightOption.released)
-- rightOption bind
rightOption:bind({}, "h", hs.toggleConsole)
rightOption:bind({}, 'j', hs.hints.windowHints)
rightOption:bind({}, ",", function() hs.urlevent.openURLWithBundle("file://"..hs.configdir, hs.settings.get("editorBundleID")) end)


rightOption:bind({}, '0', function()
  hs.reload()
end)

-- adehjknopquvyz
rightOption:bind({}, "b", function() 
  hs.application.launchOrFocus("Brave Browser")
end)
rightOption:bind({}, "c", function() 
  hs.application.launchOrFocus("Google Chrome")
end)
rightOption:bind({}, "f", function() 
  hs.application.launchOrFocus("Finder")
end)
rightOption:bind({}, "g", function() 
  hs.application.launchOrFocus("Gitup")
end)
rightOption:bind({}, "i", function() 
  hs.application.launchOrFocus("IntelliJ Idea")
end)
rightOption:bind({}, "l", function() 
  hs.application.launchOrFocus("Trello")
end)
rightOption:bind({}, "m", function() 
  hs.application.launchOrFocus("WhatsApp")
end)
rightOption:bind({}, "r", function() 
  hs.application.launchOrFocus("Simulator")
end)
rightOption:bind({}, "s", function() 
  hs.application.launchOrFocus("Sublime Text")
end)
rightOption:bind({}, "t", function() 
  hs.application.launchOrFocus("iTerm")
end)
rightOption:bind({}, "w", function() 
  hs.application.launchOrFocus("Webstorm")
end)
rightOption:bind({}, "x", function() 
  hs.application.launchOrFocus("Xcode")
end)
rightOption:bind({}, "k", function() 
  hs.application.launchOrFocus("Keyboard Maestro")
end)
rightOption:bind({}, "o", function() 
  hs.application.launchOrFocus("Firefox")
end)
rightOption:bind({}, "v", function() 
  hs.application.launchOrFocus("Visual Studio Code")
end)
-- open console
rightOption:bind({}, "`", function() 
  hs.application.find("DevTools"):focus()
end)
rightOption:bind({}, "e", function() 
  hs.window.find("Document"):focus()
end)

rightOption:bind({}, 'n', function()
  local shell_command = "open http://calendar.google.com" 
  hs.execute(shell_command)
end)


function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function copyToGoogle()
  hs.eventtap.keyStroke({"cmd"}, 'c')
  hs.timer.delayed.new(0.1,function()  
    copiedString = hs.pasteboard.readString();
    if string.starts(copiedString, "http") then
      local shell_command = "open " ..  copiedString
      hs.execute(shell_command)
    else 
      local shell_command = "open http://google.com/search?q=" .. copiedString
      hs.execute(shell_command)
    end
  end):start()
end

--
-- search highlighted text with google
--
rightOption:bind({}, '/', function()
  copyToGoogle()
end)
eventtapOtherMouseDown = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp }, function(event)
    local mouseButton = event:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    if (event:getType() == hs.eventtap.event.types.otherMouseDown and mouseButton == 2) then
      copyToGoogle()
      return true
    end
    return false -- shouldn't ever reach here, but just in case
end):start()


-- hyper:bind({}, "esc", function() 
--   hs.eventtap.keyStroke({}, 'ESCAPE')
--   hyper.triggered = true 
-- end)

-- https://www.reddit.com/r/apple/comments/5tnejo/is_there_a_way_to_simulate_a_numpad_on_a_macbook/
k = hs.hotkey.modal.new('ctrl-shift', 'n')
function k:entered() hs.alert'Virtual Numpad' end
function k:exited() hs.alert'Exit Virtual Numpad' end
k:bind('ctrl-shift', 'n', function() k:exit() end)

hs.fnutils.each({
  { key='j', padkey='pad1'},
  { key='k', padkey='pad2'},
  { key='l', padkey='pad3'},
  { key='u', padkey='pad4'},
  { key='i', padkey='pad5'},
  { key='o', padkey='pad6'},
  { key='7', padkey='pad7'},
  { key='8', padkey='pad8'},
  { key='9', padkey='pad9'},
  { key='m', padkey='pad0'},
  { key='/', padkey='pad+'},
  { key=';', padkey='pad-'},
  { key='p', padkey='pad*'},
  { key='0', padkey='pad/'},
}, function(vmap)
  k:bind({}, vmap.key,
    function() hs.eventtap.keyStroke({}, vmap.padkey, 20) end,
    nil,
    function() hs.eventtap.keyStroke({}, vmap.padkey, 20) end)
  end
)



          
-- https://github.com/kkamdooong/hammerspoon-control-hjkl-to-arrow/blob/master/init.lua

function pressFn (mods, key)
  if key == nil then
    key = mods
    mods = {}
  end

  return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

function remap(mods, key, pressFn)
  hs.hotkey.bind(mods, key, pressFn, nil, pressFn)  
end

remap({'ctrl'}, 'h', pressFn('left'))
remap({'ctrl'}, 'j', pressFn('down'))
remap({'ctrl'}, 'k', pressFn('up'))
remap({'ctrl'}, 'l', pressFn('right'))


hs.alert.show("config loaded  👍")