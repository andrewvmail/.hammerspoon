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

f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

hyper:bind({}, '0', function()
  hs.reload()
  hyper.triggered = true
end)

hyper:bind({}, "l", function()
  hs.caffeinate.lockScreen()
  hyper.triggered = true
end)

hs.alert.show("config loaded")