-- WIP
local hsDir = os.getenv("HOME") .. "/.hammerspoon"
local desktop = os.getenv("HOME") .. "/Desktop"
local a = nil
local hintChars = "ASDFJKL"
local hintKeystrokeQueue
local linkHintsModeActivated
local spacing = 5 -- viewport h / w
local increment = 5

local characterToRender = {}

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s..'['..k..'] = '..dump(v) .. ','
        end
        return s..'} '
    else
        return tostring(o)
    end
end

function get_center(x1, y1, x2, y2)
    y = (y1 + y2) / 2
    x = (x1 + x2) / 2
    return x, y
end

function numToString(num)
    local base = string.len(hintChars)
    local hintString = {};
    local remainder = 0;
    while (num > 0) do
        remainder = num % base;
        table.insert(hintString, string.sub(hintChars, remainder, remainder + 1));
        num = num - remainder;
        num = num / math.floor(base);
    end
    print(dump(hintString))
    return table.concat(hintString, "");
end

function render_text(canvas, text, x, y)
    print(x, y)
    -- canvas:appendElements(
    --     {
    --         frame={ h=1,w=2,x=x,y=y },
    --         text=hs.styledtext.new(
    --             text,{
    --                 font={ size=13 },
    --                 backgroundColor=hs.drawing.color.hammerspoon.osx_yellow,
    --                 paragraphStyle={
    --                 maximumLineHeight=13,alignment="top" },
    --             color={ black=1.0,alpha=1 }}),
    --             type="text",
    --         }
    --     ):show( )
end

function listDiagCoordsToTable(listDiagCoords)
    local listDiagCoordsTable = {}
    local count = 0
    for word in string.gmatch(listDiagCoords, '([^:]+)') do
        count = count + 1
        x, y = word:match("([^,]+),([^,]+)")
        -- print('x', x,'y', y)
        -- print(count)
        listDiagCoordsTable[count] = {x = x, y = y}
    end
    
    return listDiagCoordsTable
end

screens = hs.screen.allScreens()
offsetX = 0
offsetY = 0

return function(tmod, tkey)
    
    local eventTypes = hs.eventtap.event.types
    local eventPropTypes = hs.eventtap.event.properties
    local keycodes = hs.keycodes.map
    screen = screens[1]:currentMode()
    width = screen["w"]
    height = screen["h"]
    
    tap = nil
    exitTap = nil
    
    tap = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
        -- print("tap")
        local code = event:getKeyCode()
        local is_tapkey = code == keycodes[tkey]
        
        if code == keycodes['escape'] or is_tapkey then
            -- imageOnScreen:hide()
            tap:stop()
            a:hide()
            a:delete()
            a = nil
            offsetX = 0
            offsetY = 0
            exitTap:stop()
        elseif code == keycodes['h'] then
            print("h tapped")
            offsetX = offsetX - increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['l'] then
            print("l tapped")
            offsetX = offsetX + increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['k'] then
            print("k tapped")
            offsetY = offsetY - increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['j'] then
            print("j tapped")
            offsetY = offsetY + increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        end
        
        return true;
    end)
    
    hs.hotkey.bind(tmod, tkey, nil, function(event)
        
        if a then
            a:hide()
            a = nil
            return
        end
        
        c = require("hs.canvas")
        
        midH = (height / 4) / 2
        midW = (width / 10) / 2
        
        H = height / 10
        W = width / 20
        
        a = c.new{x = 0, y = 0, h = height, w = width}
        
        -- draw vertical lines
        for x = 0, width, H do
            a:appendElements({
                action = "line",
                closed = false,
                coordinates = {{x = x, y = 0}, {x = x, y = height}},
                strokeColor = {red = 1.0},
                strokeWidth = 3,
                type = "segments",
            })
        end
        
        -- draw horizontal lines
        for y = 0, height, W do
            a:appendElements({
                action = "line",
                closed = false,
                coordinates = {{x = 0, y = y}, {x = width, y = y}},
                strokeColor = {red = 1.0},
                strokeWidth = 3,
                type = "segments",
            })
        end
        
        a:show()
        
        print(get_center(54, 62, 5, 16))
        local x, y = get_center(54, 62, 5, 16)
        
        print("111111111111111111111111111111111")
        print("111111111111111111111111111111111")
        print(x, y)
        -- render_text(a,"JJ", x, y)
        print("111111111111111111111111111111111")
        print("111111111111111111111111111111111")
        print(listDiagCoords, 'listDiagCoords')
        tap:start()
        
        -- hs.alert('maw on')
        
    end)
end

