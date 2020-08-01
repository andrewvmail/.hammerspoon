-- WIP

function dump(o)
 if type(o) == 'table' then
  local s = '{ '
    for k,v in pairs(o) do
     if type(k) ~= 'number' then k = '"'..k..'"' end
     s = s .. '['..k..'] = ' .. dump(v) .. ','
   end
 return s .. '} '
else
  return tostring(o)
end
end

screens = hs.screen.allScreens()

print(screens)
return function(tmod, tkey)


hs.hotkey.bind(tmod, tkey, nil, function(event)

  print(dump(screens[1]:currentMode()))
  screen = screens[1]:currentMode()
  width = screen["w"]
  height = screen["h"]

  if a then 
    a:hide()
    a = nil
    return
  end




  c = require("hs.canvas")

  midH = (height/4)/2
  midW = (width/10)/2

  H = height/4
  W = width/10

  a = c.new{x=0,y=0,h=height,w=width}:appendElements( {
    -- first we start with a rectangle that covers the full canvas
    action = "fill", padding = 0, type = "rectangle", withShadow = true, 
    fillColor = { alpha = 0.3, black = 1.0  },
  }



  ,

  {
    action = "line",
    closed = false,
    coordinates = { { x = 0, y = height/4 }, { x = width, y = height/4 } },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = 0, y = (height/4) *2 }, { x = width, y = (height/4) *2 } },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = 0, y = (height/4) *3 }, { x = width, y = (height/4) *3 } },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },




  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 1, y = 0 }, { x = (width/10) * 1, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },


  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 2, y = 0 }, { x = (width/10) * 2, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },

  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 3, y = 0 }, { x = (width/10) * 3, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 4, y = 0 }, { x = (width/10) * 4, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 5, y = 0 }, { x = (width/10) * 5, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 6, y = 0 }, { x = (width/10) * 6, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 7, y = 0 }, { x = (width/10) * 7, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 8, y = 0 }, { x = (width/10) * 8, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },
  {
    action = "line",
    closed = false,
    coordinates = { { x = (width/10) * 9, y = 0 }, { x = (width/10) * 9, y = height} },
    strokeColor = { red = 1.0 },
    strokeWidth = 3,
    type = "segments",
  },


















  -- coordinates = { { x = 0, y = height/4 }, { x = width, y = height/4 } },





  {
    frame = { h = 25, w = 25, x = midW, y = midH },
    text = hs.styledtext.new("1", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW, y = midH * 3 },
    text = hs.styledtext.new("Q", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW, y = midH * 5  },
    text = hs.styledtext.new("A", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW, y = midH * 7 },
    text = hs.styledtext.new("Z", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  },





    {
    frame = { h = 25, w = 25, x = midW * 3, y = midH },
    text = hs.styledtext.new("2", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 3, y = midH * 3 },
    text = hs.styledtext.new("W", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 3, y = midH * 5  },
    text = hs.styledtext.new("S", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 3, y = midH * 7 },
    text = hs.styledtext.new("X", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  },





    {
    frame = { h = 25, w = 25, x = midW * 5, y = midH },
    text = hs.styledtext.new("3", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 5, y = midH * 3 },
    text = hs.styledtext.new("E", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 5, y = midH * 5  },
    text = hs.styledtext.new("D", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 5, y = midH * 7 },
    text = hs.styledtext.new("C", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  },


    {
    frame = { h = 25, w = 25, x = midW * 7, y = midH },
    text = hs.styledtext.new("4", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 7, y = midH * 3 },
    text = hs.styledtext.new("R", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 7, y = midH * 5  },
    text = hs.styledtext.new("F", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 7, y = midH * 7 },
    text = hs.styledtext.new("V", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,



    {
    frame = { h = 25, w = 25, x = midW * 9, y = midH },
    text = hs.styledtext.new("5", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 9, y = midH * 3 },
    text = hs.styledtext.new("T", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 9, y = midH * 5  },
    text = hs.styledtext.new("G", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 9, y = midH * 7 },
    text = hs.styledtext.new("B", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,





    {
    frame = { h = 25, w = 25, x = midW * 11, y = midH },
    text = hs.styledtext.new("6", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 11, y = midH * 3 },
    text = hs.styledtext.new("Y", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 11, y = midH * 5  },
    text = hs.styledtext.new("H", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 11, y = midH * 7 },
    text = hs.styledtext.new("N", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,

    {
    frame = { h = 25, w = 25, x = midW * 13, y = midH },
    text = hs.styledtext.new("7", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 13, y = midH * 3 },
    text = hs.styledtext.new("U", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 13, y = midH * 5  },
    text = hs.styledtext.new("J", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 13, y = midH * 7 },
    text = hs.styledtext.new("M", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,

      {
    frame = { h = 25, w = 25, x = midW * 15, y = midH },
    text = hs.styledtext.new("8", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 15, y = midH * 3 },
    text = hs.styledtext.new("I", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 15, y = midH * 5  },
    text = hs.styledtext.new("K", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 15, y = midH * 7 },
    text = hs.styledtext.new("<", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  },




       {
    frame = { h = 25, w = 25, x = midW * 17, y = midH },
    text = hs.styledtext.new("9", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 17, y = midH * 3 },
    text = hs.styledtext.new("O", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 17, y = midH * 5  },
    text = hs.styledtext.new("L", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 17, y = midH * 7 },
    text = hs.styledtext.new(">", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  },

         {
    frame = { h = 25, w = 25, x = midW * 19, y = midH },
    text = hs.styledtext.new("0", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 19, y = midH * 3 },
    text = hs.styledtext.new("P", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 19, y = midH * 5  },
    text = hs.styledtext.new(";", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
    type = "text",
  }
  ,
  {
    frame = { h = 25, w = 25, x = midW * 19, y = midH * 7 },
    text = hs.styledtext.new("/", {
      font = { name = ".AppleSystemUIFont", size = 25 },
      paragraphStyle = { alignment = "top" },
      color = { red = 1.0 }
    }),
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





hs.alert('maw on')

end)
end