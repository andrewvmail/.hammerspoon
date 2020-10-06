require "machine-specific"
require "preload"
require "ctrlTap"

vim = hs.loadSpoon('VimMode')

local vimouse = require('vimouse')
vimouse('cmd', 'm')

-- https://github.com/andrewvmail/hammerspoon-GridMouse
local gridmouse = require('gridmouse')
gWidth = gWidth or 20 
gHeight = gHeight or 10 
print(gWidth, gHeight)
gridmouse('cmd', 'i', gWidth, gHeight)

hs.hotkey.bind({'ctrl'}, '\\', function()
  vim:enter()
end)

-- hs.hotkey.bind({'ctrl'}, 'c', function()
  -- vim:exit()
-- end)

vim:disableForApp('Code')
vim:disableForApp('iTerm')
vim:disableForApp('MacVim')
vim:disableForApp('Terminal')
vim:disableForApp('Chrome')

-- set this with karabiner
hyper = hs.hotkey.modal.new({}, 'F17') -- left ctrl
hyper2 = hs.hotkey.modal.new({}, 'F14') -- right cmd
hyperEsc = hs.hotkey.modal.new({}, 'F5')

hyper:bind({}, "h", hs.toggleConsole)
hyper:bind({}, 'j', hs.hints.windowHints)
hyper:bind({}, ",", function() hs.urlevent.openURLWithBundle("file://"..hs.configdir, hs.settings.get("editorBundleID")) end)


function enterHyperModeFactory(hyperKey) 
  local enterHyperMode = function ()
    hyperKey.triggered = false
    hyperKey:enter()
  end

  return enterHyperMode
end


function exitHyperModeFactory(hyperKey)
  local exitHyperMode = function ()
    hyperKey:exit()
    if not hyperKey.triggered then
      hs.eventtap.keyStroke({}, 'ESCAPE')
    end
  end
  return exitHyperMode
end

-- V the actual key -------- V -- that should be mapped in karabiner
leftCtrl = hs.hotkey.bind({}, 'F18', enterHyperModeFactory(hyper), exitHyperModeFactory(hyper)) -- left ctrl
rightCmd = hs.hotkey.bind({}, 'F13', enterHyperModeFactory(hyper2), exitHyperModeFactory(hyper2)) -- right cmd into
fesc = hs.hotkey.bind({}, 'F20', enterHyperModeFactory(hyperEsc), exitHyperModeFactory(hyperEsc)) -- turning esc into f20
-- ^ the actual key -------- ^ -- that should be mapped in karabiner 

require "window"

hyper2:bind({}, 'h', function()
  hyper2.triggered = true
  local shell_command = "open " .. "~/.hammerspoon" 
  hs.execute(shell_command)
end)

-- open the first window chromed opened
-- hyper:bind({}, "j", function() 
--   chrome = hs.application.find("Google Chrome")
--   hs.tabs.enableForApp(chrome)
--   hs.tabs.focusTab(chrome, 1) 
--   hyper.triggered = true
--   hs.alert.show("Gmail")
-- end)


hyper:bind({}, '0', function()
  hs.reload()
  hyper.triggered = true
end)

-- adehjknopquvyz
hyper:bind({}, "b", function() 
  hs.application.launchOrFocus("Brave Browser")
  hyper.triggered = true 
end)
hyper:bind({}, "c", function() 
  hs.application.launchOrFocus("Google Chrome")
  hyper.triggered = true 
end)
hyper:bind({}, "f", function() 
  hs.application.launchOrFocus("Finder")
  hyper.triggered = true 
end)
hyper:bind({}, "g", function() 
  hs.application.launchOrFocus("Gitup")
  hyper.triggered = true 
end)
hyper:bind({}, "i", function() 
  hs.application.launchOrFocus("IntelliJ Idea")
  hyper.triggered = true 
end)
hyper:bind({}, "l", function() 
  hs.application.launchOrFocus("Trello")
  hyper.triggered = true 
end)
hyper:bind({}, "m", function() 
  hs.application.launchOrFocus("WhatsApp")
  hyper.triggered = true 
end)
hyper:bind({}, "r", function() 
  hs.application.launchOrFocus("Simulator")
  hyper.triggered = true 
end)
hyper:bind({}, "s", function() 
  hs.application.launchOrFocus("Sublime Text")
  hyper.triggered = true 
end)
hyper:bind({}, "t", function() 
  hs.application.launchOrFocus("iTerm")
  hyper.triggered = true 
end)
hyper:bind({}, "w", function() 
  hs.application.launchOrFocus("Webstorm")
  hyper.triggered = true 
end)
hyper:bind({}, "x", function() 
  hs.application.launchOrFocus("Xcode")
  hyper.triggered = true 
end)
hyper:bind({}, "k", function() 
  hs.application.launchOrFocus("Keyboard Maestro")
  hyper.triggered = true 
end)
-- open console
hyper:bind({}, "`", function() 
  hs.application.find("DevTools"):focus()
  hyper.triggered = true 
end)

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

local function pressFn(mods, key)
  if key == nil then
    key = mods
    mods = {}
  end

  return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
  hs.hotkey.bind(mods, key, pressFn, nil, pressFn)  
end

remap({'ctrl'}, 'h', pressFn('left'))
remap({'ctrl'}, 'j', pressFn('down'))
remap({'ctrl'}, 'k', pressFn('up'))
remap({'ctrl'}, 'l', pressFn('right'))




hs.alert.show("config loaded  👍")
