hs.window.animationDuration = 0

require("ctrlTap")

vim = hs.loadSpoon('VimMode')


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

hyper = hs.hotkey.modal.new({}, 'F17')
hyper2 = hs.hotkey.modal.new({}, 'F14')

function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end
function enterHyperMode2()
  hyper2.triggered = false
  hyper2:enter()
end

function exitHyperMode2()
  hyper2:exit()
  if not hyper2.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end
-- the actual key 
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode) -- left ctrl
f13 = hs.hotkey.bind({}, 'F13', enterHyperMode2, exitHyperMode2) -- right cmd

hyper2:bind({}, 'h', function()
  hyper2.triggered = true
  local shell_command = "open " .. "~/.hammerspoon" 
  hs.execute(shell_command)
  hs.alert.show("test")
end)

-- open the first window chromed opened
hyper:bind({}, "j", function() 
  chrome = hs.application.find("Google Chrome")
  hs.tabs.enableForApp(chrome)
  hs.tabs.focusTab(chrome, 1) 
  hyper.triggered = true
  hs.alert.show("Gmail")
end)

hyper:bind({}, '0', function()
  hs.reload()
  hyper.triggered = true
end)

hyper:bind({}, "l", function()
  hs.caffeinate.lockScreen()
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

hyper:bind({}, "c", function() 
  hs.application.launchOrFocus("Google Chrome")
  hyper.triggered = true 
end)

hyper:bind({}, "b", function() 
  hs.application.launchOrFocus("Brave Browser")
  hyper.triggered = true 
end)

hyper:bind({}, "l", function() 
  hs.application.launchOrFocus("Trello")
  hyper.triggered = true 
end)

hyper:bind({}, "g", function() 
  hs.application.launchOrFocus("Gitup")
  hyper.triggered = true 
end)

hyper:bind({}, "s", function() 
  hs.application.launchOrFocus("Sublime Text")
  hyper.triggered = true 
end)

hyper:bind({}, "f", function() 
  hs.application.launchOrFocus("Finder")
  hyper.triggered = true 
end)

hyper:bind({}, "`", function() 
  hs.eventtap.keyStroke({"ctrl", "shift"}, "f2")
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


hs.alert.show("config loaded")



