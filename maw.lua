-- WIP
local hsDir = os.getenv("HOME") .. "/.hammerspoon"
local desktop = os.getenv("HOME") .. "/Desktop"
local a = nil
local hintChars = "ASDFJKL"
local hintKeystrokeQueue
local linkHintsModeActivated

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
            end
        return s .. '} '
    else
        return tostring(o)
    end
end


function get_center(x1,y1,x2,y2) 
    y = (y1 + y2)/2
    x = (x1 + x2)/2
    return x, y
end

function numToString(num)
    local base = string.len(hintChars)
    local hintString = {};
    local remainder = 0;
    while (num > 0) do
        remainder = num % base;
        table.insert(hintString, string.sub(hintChars, remainder, remainder + 1) );
        num = num - remainder;
        num = num / math.floor(base);
    end 
    print(dump(hintString))
    return table.concat(hintString, ""); 
end

function render_text(canvas, text, x, y)
    print(x, y)
    canvas:appendElements(
    {
        frame = {h = 1, w = 2, x = x, y = y},
        text = hs.styledtext.new(
            text, {
                font = {size = 13},
                backgroundColor = hs.drawing.color.hammerspoon.osx_yellow,
                paragraphStyle = {
                maximumLineHeight = 13, alignment = "top"},
                color = {black = 1.0, alpha = 1 }}), 
        type = "text",
    }  
    ):show()
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

function feed_snapshot_to_opencv(shotPath, canvas)
    -- local back_task = hs.task.new('/usr/local/bin/python3', task_callback, stream_callback, {'/Volumes/Jeff/bin/backup_phone'})
    hs.task.new(
        '/usr/local/bin/python3',
        function(code,out,err) 
            -- print('111111')
            -- print(dump(code))
            -- print(dump(out))
            -- print(dump(err))
            return true
        end,
        function(code,out,err)
            -- print('----')
            -- print(dump(code))
            -- print(dump(out))
            -- listDiagCoords = out
            -- print("listDiagCoords")
            -- print(listDiagCoords)
            -- print(type(listDiagCoords))


            listDiagCoords = listDiagCoordsToTable(out)
            print('list', dump(listDiagCoords))



            for k, v in pairs(listDiagCoords) do
              --print(k, v['x'], v['y'], v[3])
              render_text(canvas,numToString(k), tonumber(v['x']), tonumber(v['y']))
              print("k", k, type(k1))
              print(numToString(k))
              -- print(numToString(2))
              -- print(numToString(3))
              -- print(numToString(4))
              -- print(numToString(5))
            end



            -- print(dump(err))
            return true
        end,
        {hsDir ..'/mser.py', shotPath, shotPath}
        ):start()

    return listDiagCoords
end

screens = hs.screen.allScreens()

print(screens)
return function(tmod, tkey)

local eventTypes = hs.eventtap.event.types
local eventPropTypes = hs.eventtap.event.properties
local keycodes = hs.keycodes.map
screen = screens[1]:currentMode()
width = screen["w"]
height = screen["h"]

tap = nil
exitTap = nil



exitTap = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
    local code = event:getKeyCode()
    local is_tapkey = code == keycodes[tkey]

    if code == keycodes['escape'] then
        imageOnScreen:hide()
        exitTap:stop()
        a:hide()
        a = nil
    end

    return true;
end)

tap = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
    -- print("tap")
    local code = event:getKeyCode()
    local is_tapkey = code == keycodes[tkey]

    -- if a then
        --     hs.mouse.setAbsolutePosition({ x=0, y=0 })
        local shotPath = desktop .. "/test.jpg"
        local image = screens[1]:shotAsJPG(shotPath, {x=0,y=0,w=width/10,h=height/4})

     
        feed_snapshot_to_opencv(shotPath, a)











        --     imageOnScreen = hs.loadSpoon('FadeLogo'):start(0.5, image)
        --     exitTap:start()
        -- end

        

        -- if is_tapkey then
            --     -- imageOnScreen:hide()
            --     tap:stop()
            --     a:hide()
            --     a = nil
            -- end

            if code == keycodes['escape'] or is_tapkey then
                -- imageOnScreen:hide()
                tap:stop()
                a:hide()
                a:delete()
                a = nil
                exitTap:stop()
            end

            return true;
        end)

hs.hotkey.bind(tmod, tkey, nil, function(event)

    print(dump(screens[1]:currentMode()))
    -- screen = screens[1]:currentMode()
    -- width = screen["w"]
    -- height = screen["h"]

    if a then
        a:hide()
        a = nil
        return
    end

    c = require("hs.canvas")

    midH = (height / 4) / 2
    midW = (width / 10) / 2

    H = height / 4
    W = width / 10

    a = c.new{x = 0, y = 0, h = height, w = width}:appendElements({
        -- first we start with a rectangle that covers the full canvas
        action = "fill", padding = 0, type = "rectangle", withShadow = true,
        fillColor = {alpha = 0, black = 1.0},
    }

    ,

    {
        action = "line",
        closed = false,
        coordinates = {{x = 0, y = height / 4}, {x = width, y = height / 4}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = 0, y = (height / 4) * 2}, {x = width, y = (height / 4) * 2}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = 0, y = (height / 4) * 3}, {x = width, y = (height / 4) * 3}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },

    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 1, y = 0}, {x = (width / 10) * 1, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },

    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 2, y = 0}, {x = (width / 10) * 2, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },

    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 3, y = 0}, {x = (width / 10) * 3, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 4, y = 0}, {x = (width / 10) * 4, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 5, y = 0}, {x = (width / 10) * 5, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 6, y = 0}, {x = (width / 10) * 6, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 7, y = 0}, {x = (width / 10) * 7, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 8, y = 0}, {x = (width / 10) * 8, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },
    {
        action = "line",
        closed = false,
        coordinates = {{x = (width / 10) * 9, y = 0}, {x = (width / 10) * 9, y = height}},
        strokeColor = {red = 1.0},
        strokeWidth = 3,
        type = "segments",
    },

    -- coordinates = { { x = 0, y = height/4 }, { x = width, y = height/4 } },

    {
        frame = {h = 25, w = 25, x = midW, y = midH},
        text = hs.styledtext.new("1", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW, y = midH * 3},
        text = hs.styledtext.new("Q", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW, y = midH * 5},
        text = hs.styledtext.new("A", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW, y = midH * 7},
        text = hs.styledtext.new("Z", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    },

    {
        frame = {h = 25, w = 25, x = midW * 3, y = midH},
        text = hs.styledtext.new("2", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 3, y = midH * 3},
        text = hs.styledtext.new("W", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 3, y = midH * 5},
        text = hs.styledtext.new("S", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 3, y = midH * 7},
        text = hs.styledtext.new("X", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    },

    {
        frame = {h = 25, w = 25, x = midW * 5, y = midH},
        text = hs.styledtext.new("3", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 5, y = midH * 3},
        text = hs.styledtext.new("E", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 5, y = midH * 5},
        text = hs.styledtext.new("D", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 5, y = midH * 7},
        text = hs.styledtext.new("C", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    },

    {
        frame = {h = 25, w = 25, x = midW * 7, y = midH},
        text = hs.styledtext.new("4", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 7, y = midH * 3},
        text = hs.styledtext.new("R", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 7, y = midH * 5},
        text = hs.styledtext.new("F", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 7, y = midH * 7},
        text = hs.styledtext.new("V", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,

    {
        frame = {h = 25, w = 25, x = midW * 9, y = midH},
        text = hs.styledtext.new("5", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 9, y = midH * 3},
        text = hs.styledtext.new("T", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 9, y = midH * 5},
        text = hs.styledtext.new("G", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 9, y = midH * 7},
        text = hs.styledtext.new("B", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,

    {
        frame = {h = 25, w = 25, x = midW * 11, y = midH},
        text = hs.styledtext.new("6", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 11, y = midH * 3},
        text = hs.styledtext.new("Y", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 11, y = midH * 5},
        text = hs.styledtext.new("H", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 11, y = midH * 7},
        text = hs.styledtext.new("N", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,

    {
        frame = {h = 25, w = 25, x = midW * 13, y = midH},
        text = hs.styledtext.new("7", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 13, y = midH * 3},
        text = hs.styledtext.new("U", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 13, y = midH * 5},
        text = hs.styledtext.new("J", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 13, y = midH * 7},
        text = hs.styledtext.new("M", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,

    {
        frame = {h = 25, w = 25, x = midW * 15, y = midH},
        text = hs.styledtext.new("8", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 15, y = midH * 3},
        text = hs.styledtext.new("I", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 15, y = midH * 5},
        text = hs.styledtext.new("K", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 15, y = midH * 7},
        text = hs.styledtext.new("<", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    },

    {
        frame = {h = 25, w = 25, x = midW * 17, y = midH},
        text = hs.styledtext.new("9", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 17, y = midH * 3},
        text = hs.styledtext.new("O", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 17, y = midH * 5},
        text = hs.styledtext.new("L", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 17, y = midH * 7},
        text = hs.styledtext.new(">", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    },

    {
        frame = {h = 25, w = 25, x = midW * 19, y = midH},
        text = hs.styledtext.new("0", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 19, y = midH * 3},
        text = hs.styledtext.new("P", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 19, y = midH * 5},
        text = hs.styledtext.new(";", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }
    ,
    {
        frame = {h = 25, w = 25, x = midW * 19, y = midH * 7},
        text = hs.styledtext.new("/", {
            font = {name = ".AppleSystemUIFont", size = 25},
            paragraphStyle = {alignment = "top"},
            color = {red = 1.0}}),
        type = "text",
    }

    --   , {
        -- -- then we append a circle, but reverse its path, so that the default windingRule of `evenOdd` sees this as a negative region
            --     action = "build", padding = 0, radius = ".3", reversePath = true, type = "circle"
        --   }, {
            -- -- and we end it it with a smaller circle, which should show content
            --     action = "clip", padding = 0, radius = ".1", type = "circle"
        --   }, {
            -- -- now, draw a rectangle in the upper left
            --     action = "fill",
            --     fillColor = { alpha = 0.5, green = 1.0  },
            --     frame = { x = "0", y = "0", h = ".75", w = ".75", },
            --     type = "rectangle",
            --     withShadow = true,
        --   }, {
            -- -- and a circle in the lower right
            --     action = "fill",
            --     center = { x = "0.625", y = "0.625" },
            --     fillColor = { alpha = 0.5, red = 1.0  },
            --     radius = ".375",
            --     type = "circle",
            --     withShadow = true,
        --   }, {
            -- -- reset our clipping changes added with elements 1, 2, and 3
            --     type = "resetClip"
        --   }, {
            -- -- and cover the whole thing with a semi-transparent rectangle
            --     action = "fill",
            --     fillColor = { alpha = 0.25, blue = 0.5, green = 0.5  },
            --     frame = { h = 500.0, w = 500.0, x = 0.0, y = 0.0 },
            --     type = "rectangle",
        --   }
        
        ):show()

-- a:appendElements(
-- {
--     frame = {h = 25, w = 25, x = 0, y = 0},
--     text = hs.styledtext.new(
--         "JJ", {
--             font = {name = ".AppleSystemUIFont", size = 18},
--             backgroundColor = hs.drawing.color.hammerspoon.osx_yellow,
--             paragraphStyle = {alignment = "top"},
--             color = {black = 1.0, alpha = 1.0 }}), 
--     type = "text",
-- }  
-- ):show()

-- render_text(a, "JJ")

print(get_center(54,62,5,16))
local x, y = get_center(54,62,5,16)

print("111111111111111111111111111111111")
print("111111111111111111111111111111111")
print(x,y)
-- render_text(a,"JJ", x, y)
print("111111111111111111111111111111111")
print("111111111111111111111111111111111")
print(listDiagCoords, 'listDiagCoords')
tap:start()

-- hs.alert('maw on')

end)
end
