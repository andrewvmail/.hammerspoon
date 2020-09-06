-- WIP
local hsDir = os.getenv("HOME") .. "/.hammerspoon"
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

