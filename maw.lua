-- WIP
local keycodes = hs.keycodes.map
local eventTypes = hs.eventtap.event.types
local eventPropTypes = hs.eventtap.event.properties local hsDir = os.getenv("HOME") .. "/.hammerspoon"
local desktop = os.getenv("HOME") .. "/Desktop"
local a = nil
local hintChars = "QWERASDFTYGZXCVBN"
local hintKeystrokeQueue
local linkHintsModeActivated
local spacing = 5 -- viewport h / w
local increment = 5

local characterToRender = {}
local grid = {}
local hintOpt =
{
    font = {size = 12},
    backgroundColor = hs.drawing.color.hammerspoon.osx_yellow,
}
local keyPressedStack = {}
local hintsToCoords = {}

local screens = hs.screen.allScreens()
local offsetX = 0
local offsetY = 0

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

function checkKeysInHintChars(char, hintChars)
    if string.match(hintChars, string.upper(char)) then
        return true
    end
    return false
end

-- // Refer to:
-- // https://github.com/philc/vimium/blob/881a6fdc3644f55fc02ad56454203f654cc76618/content_scripts/link_hints.coffee#L434
function buildHintSrings(linkCount)
    hints = {}
    offset = 0
    while #hints - offset < linkCount or #hints == 1 do
        offset = offset + 1
        local hint = hints[offset]
        for i = 0, string.len(hintChars) do
            table.insert(hints, string.sub(hintChars, i, i) .. (hint or ""));
        end
    end
    
    local newHints = {}
    for key, value in pairs({table.unpack(hints, offset, offset + linkCount)}) do
        newHints[key] = value
    end
    
    return newHints
end

function numToString(num)
    
    local base = string.len(hintChars)
    local hintString = {};
    local remainder = 0;
    while (num > 0) do
        remainder = math.floor(num % base);
        table.insert(hintString, string.sub(hintChars, remainder, remainder + 1));
        -- num = num - remainder;
        num = math.floor(num / base);
    end
    -- print(dump(hintString))
    return table.concat(hintString, "");
end

function renderHints(canvas, grid)
    count = 1
    for k, v in pairs(grid) do
        if(v["x"] ~= nil and v["y"] ~= nil) then
            count = count + 1
        end
    end
    hints = buildHintSrings(count)
    count = 1
    for k, v in pairs(grid) do
        if(v["x"] ~= nil and v["y"] ~= nil) then
            x = v["x"]
            y = v["y"]
            opts = {
                frame = {h = 200, w = 200, x = x, y = y},
                text = hs.styledtext.new(hints[count], hintOpt),
                type = "text"
            }
            canvas:appendElements(opts):show()
            hintsToCoords[hints[count]] = {
                x = x, y = y
            }
            count = count + 1
        end
    end
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

return function(tmod, tkey)
    
    local eventTypes = hs.eventtap.event.types
    local eventPropTypes = hs.eventtap.event.properties
    screen = screens[1]:currentMode()
    width = screen["w"]
    height = screen["h"]
    
    tap = nil
    exitTap = nil
    
    tap = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
        -- print("tap", event.type)
        local code = event:getKeyCode()
        local char = event:getCharacters()
        local keyDirection = event:getType()
        local is_tapkey = code == keycodes[tkey]
        
        if code == keycodes['escape'] or is_tapkey then
            -- imageOnScreen:hide()
            keyPressedStack = {}
            tap:stop()
            a:hide()
            a:delete()
            a = nil
            offsetX = 0
            offsetY = 0
            if(exitTap) then
                exitTap:stop()
            end
        elseif code == keycodes['h'] then
            -- print("h tapped")
            offsetX = offsetX - increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['l'] then
            -- print("l tapped")
            offsetX = offsetX + increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['k'] then
            -- print("k tapped")
            offsetY = offsetY - increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif code == keycodes['j'] then
            -- print("j tapped")
            offsetY = offsetY + increment
            a:transformation(hs.canvas.matrix.translate(offsetX, offsetY))
        elseif(keyDirection == eventTypes.keyUp and checkKeysInHintChars(char, hintChars)) then
            table.insert(keyPressedStack, char)
            hs.alert.closeAll()
            local keyPressedString = ""
            -- table to string
            for k, v in pairs(keyPressedStack) do
                keyPressedString = keyPressedString .. v
            end
            
            local hintsToCoordsFiltered = {}
            local hintsToCoordsFilteredCount = 0
            for k, v in pairs(hintsToCoords) do
                if (k:match("^" .. string.upper(keyPressedString) .. '(.*)$')) then
                    hintsToCoordsFiltered[k] = v
                    hintsToCoordsFilteredCount = hintsToCoordsFilteredCount + 1
                    -- print(hintsToCoordsFilteredCount)
                end
            end
            --
            if(hintsToCoordsFilteredCount == 1 and hintsToCoords[string.upper(keyPressedString)]) then
                -- print(keyPressedString, dump(hintsToCoords[string.upper(keyPressedString)]))
                -- click here
                
                -- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], point):setProperty(clickState, 2):post()
                -- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], point):setProperty(clickState, 2):post()
                -- imageOnScreen:hide()
                keyPressedStack = {}
                tap:stop()
                a:hide()
                a:delete()
                a = nil
                if(exitTap) then
                    exitTap:stop()
                end
                
                function click()
                    local point = hintsToCoords[string.upper(keyPressedString)]
                    point["x"] = point["x"] + offsetX
                    point["y"] = point["y"] + offsetY
                    local clickState = hs.eventtap.event.properties.mouseEventClickState
                    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], point):setProperty(clickState, 1):post()
                    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], point):setProperty(clickState, 1):post()
                end
                
                click()
                
                offsetX = 0
                offsetY = 0
                
                -- hs.timer.usleep(10000)
            end
            hs.alert.show(keyPressedString)
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
            -- grid[xcounter] = {}
            -- grid[xcounter]["x"] = x
            -- xcounter = xcounter + 1
            
            a:appendElements({
                action = "stroke",
                closed = false,
                coordinates = {{x = x, y = 0}, {x = x, y = height}},
                strokeColor = {red = 1.0},
                strokeWidth = 3,
                type = "segments",
            })
        end
        
        -- draw horizontal lines
        ycounter = 0
        for y = 0, height, W do
            -- grid[ycounter]["y"] = y
            
            local xcounter = 0
            for x = 0, width, H do
                gindex = tostring(xcounter)..tostring(ycounter) .. tostring(y) .. tostring(x)
                grid[gindex] = {}
                grid[gindex]["x"] = x
                grid[gindex]["y"] = y
                
                -- print(xcounter)
                xcounter = xcounter + 1
                
                -- a:appendElements({
                --     action = "line",
                --     closed = false,
                --     coordinates = {{x = x, y = 0}, {x = x, y = height}},
                --     strokeColor = {red = 1.0},
                --     strokeWidth = 3,
                --     type = "segments",
                -- })
            end
            
            a:appendElements({
                action = "stroke",
                closed = false,
                coordinates = {{x = 0, y = y}, {x = width, y = y}},
                strokeColor = {red = 1.0},
                strokeWidth = 3,
                type = "segments",
            })
            ycounter = ycounter + 1
        end
        
        a:show()
        renderHints(a, grid)
        tap:start()
        
    end)
end

