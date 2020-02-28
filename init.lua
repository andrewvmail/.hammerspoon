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


hyper2:bind({}, 'p', function()
  hyper2.triggered = true
  -- local shell_command = "open " .. "~/.hammerspoon" 
  -- hs.execute(shell_command)
  hs.alert.show("prettier")
  
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
  hs.application.launchOrFocus("Terminal")
  hyper.triggered = true 
end)

hyper:bind({}, "w", function() 
  hs.application.launchOrFocus("Webstorm")
  hyper.triggered = true 
end)

hyper:bind({}, "c", function() 
  hs.application.launchOrFocus("Google Chrome")
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


-- hyper:bind({}, "esc", function() 
--   hs.eventtap.keyStroke({}, 'ESCAPE')
--   hyper.triggered = true 
-- end)

hs.alert.show("config loaded")