require("ctrlTap")

hyper = hs.hotkey.modal.new({}, 'F17')

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

-- the actual key mapped to left ctrl
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

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