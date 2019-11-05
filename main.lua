local octopait = {
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2019 Chris / Systemlogoff

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],
}
--[[ Notes ]]-------------------------------------------------------------------
-- Load libraries and media
gui = {}
gui.pixels = require 'pixels'
gui.pixels:load(4)

local image = nil
local preview_image = false
local adj_level = 0.5
local function bitnum(table)
if #table ~= 8 then return 0 end
local num = 0
if table[1] == 1 then num = num + 128 end
if table[2] == 1 then num = num + 64 end
if table[3] == 1 then num = num + 32 end
if table[4] == 1 then num = num + 16 end
if table[5] == 1 then num = num + 8 end
if table[6] == 1 then num = num + 4 end
if table[7] == 1 then num = num + 2 end
if table[8] == 1 then num = num + 1 end
return num
end

local startup_menu = love.graphics.newImage("res/menu.png")

local superchip = true

--[[ Notes ]]-------------------------------------------------------------------
-- Run once items.
function love.load()

end

--[[ Notes ]]-------------------------------------------------------------------
-- Draw behind all hump gamestates
function love.draw() -- This is the main love.draw if no draws are being done in your class, should never be noticed.
  love.graphics.setColor(1,1,1,1)
  gui.pixels:drawGameArea()

  if image then
    local dem = {image:getWidth(), image:getHeight()}
      local width = 64
      local height = 32
      if superchip then
        width = 128
        height = 64
      end
      love.graphics.rectangle("fill", 0, 0, 128, 64)

      if dem[1] > 128 then
        if dem[1] > dem[2] then
          love.graphics.draw(image,0,0,0,1/(dem[1]/width))--,1/(dem[2]/64))
        else
          love.graphics.draw(image,0,0,0,1/(dem[2]/height),1/(dem[2]/height))
        end
      else
        love.graphics.draw(image)
      end
  else
   love.graphics.draw(startup_menu)
  end

  if preview_image then
    love.graphics.rectangle("fill", 0, 0, 128, 64)
    love.graphics.setColor(0,0,0,1)
    local cx = 0; local cy = 0
    for i=1, #imagetable do
      if imagetable[i] == 1 then
        love.graphics.rectangle("fill", cx, cy, 1, 1)
      end
      cx = cx + 1
      if i % 128 == 0 then
        cx = 0
        cy = cy + 1
      end
    end
    love.graphics.setColor(1,1,1,1)
  end

  gui.pixels:endDrawGameArea()
end

--[[ Notes ]]-------------------------------------------------------------------
-- Global Hotkeys
function love.keypressed(key, scancode, isrepeat)
  if key == "c" then
    if image then
      preview_image = false
      window_convert()
    else
      window_noimage()
    end
  end
  if key == "d" then
    image = nil
  end
  if key == "m" then
    window_adjust()
  end
  if key == "p" then
    if image then
      convertimage()
      preview_image = not preview_image
    else
      window_noimage()
    end
  end
  if key == "escape" or key == "q" then
    window_quit()
  end
end

--[[ Notes ]]-------------------------------------------------------------------
function love.update(dt)
  gui.pixels:update(dt)
end

function love.filedropped(file)
  local title = "Image Type"
  local message = "What mode are you making your Chip8 game in?"
  local buttons = {"Schip. (128x64)", "Std. (64x32)", escapebutton = 1}

  local pressedbutton = love.window.showMessageBox(title, message, buttons)
  if pressedbutton == 1 then
    superchip = true
  elseif pressedbutton == 2 then
    superchip = false
  end
	file:open("r")
	data2 = file:read()
	print("Content of " .. file:getFilename() .. ' is')
	--print(data2)
	print("End of file")
  data = love.filesystem.newFileData( data2, "img.png", "file" )
  image = love.graphics.newImage( data )
  file:close()
end

function window_convert()
  local title = "Convert This Image?"
  local message = "Convert this image and send the conversion to your clipboard?"
  local buttons = {"Schip. (128x64)", "Std. (64x32)", "Cancel", escapebutton = 1}

  local pressedbutton = love.window.showMessageBox(title, message, buttons)
  if pressedbutton == 1 then
      print("SCHIP")
      convertimage()
      to_clipboard()
  elseif pressedbutton == 2 then
      print("Standard")
      convertimage_std()
      to_clipboard()
  elseif pressedbutton == 3 then
      print("Canceled!")
  end
end

function window_adjust()
  local title = "Adjust Black/White Levels"
  local message = "Adjust the limit of how grey a color has to be to be black.\nNot really needed if you already have drawn your image with only black/white colors."
  local buttons = {"10%","20%","30%","40%","50% (Default)","60%","70%","80%","90%", escapebutton = 5}

  local pressedbutton = love.window.showMessageBox(title, message, buttons)
  if pressedbutton == 1 then
    adj_level = 0.1
  elseif pressedbutton == 2 then
    adj_level = 0.2
  elseif pressedbutton == 3 then
    adj_level = 0.3
  elseif pressedbutton == 4 then
    adj_level = 0.4
  elseif pressedbutton == 5 then
    adj_level = 0.5
  elseif pressedbutton == 6 then
  adj_level = 0.6
  elseif pressedbutton == 7 then
    adj_level = 0.7
  elseif pressedbutton == 8 then
    adj_level = 0.8
  elseif pressedbutton == 9 then
    adj_level = 0.9
  end
end

function window_quit()
    if love.window.getFullscreen() == true then
      love.window.setFullscreen(false)
    end
    local title = "Exit?"
    local message = "Do you want to exit the program?"
    local buttons = {"No", "Yes", escapebutton = 2}

    local pressedbutton = love.window.showMessageBox(title, message, buttons, "warning", true)
    if pressedbutton == 2 then
      love.event.quit( )
    elseif pressedbutton == 1 then
      print("No")
    end
end

function window_noimage()
  local errortitle = "WARNING - No Image Loaded"
  local errormessage = "There is no image loaded. Please load an image by dropping a file on the main window."

      love.window.showMessageBox(errortitle, errormessage, "error")

end



function convertimage()
  capture = gui.pixels.canvas:newImageData( 1, 1, 0, 0, 128, 64 ) -- Capture the displayed image

  imagetable = {} -- create a table to hold it
  local i = 1
  for y=0, 64-1 do
  for x=0, 128-1 do -- Loop though all the pixels in the frame
      r, g, b, a = capture:getPixel( x,y )
      --print(r, g, b, a)
      imagetable[#imagetable+1] = ((r+b+g)/3) -- store as the average color
    end
  end
  --print(#imagetable, imagetable[3]) -- Display count


  for i=1, #imagetable do -- Convert the image to 0/1 depending on how grey it is.
    local blackorwhite = 0
    if imagetable[i] <= adj_level then
      blackorwhite = 1
    end
    imagetable[i] = blackorwhite
  end

  -- Sanity Test
  local string=""
  for i=1, #imagetable do
    string = string .. imagetable[i]
    if i % 128 == 0 then
      string = string .. "\n"
    end
  end
  --print(string)

  clip = ""
  for tile=0, 127 do
  string = ""
  for i=1, 8 do
    ox = (i-1) * 128
    tj = math.floor(tile/16) * (7*128)

  local lineseg = {
    imagetable[(1+tj+(8*tile))+ox],
    imagetable[(2+tj+(8*tile))+ox],
    imagetable[(3+tj+(8*tile))+ox],
    imagetable[(4+tj+(8*tile))+ox],
    imagetable[(5+tj+(8*tile))+ox],
    imagetable[(6+tj+(8*tile))+ox],
    imagetable[(7+tj+(8*tile))+ox],
    imagetable[(8+tj+(8*tile))+ox],
    --print("Derp", (8+tj+(8*tile))+ox)
  }
  string = string .. bitnum(lineseg) .. " "

  end
  --print(": tile_" .. tile)
  --print(string)
  clip = clip .. string .. "\n"
  --print(tile, (math.floor(tile / 16)))
  end
end

function convertimage_std()
  capture = gui.pixels.canvas:newImageData( 1, 1, 0, 0, 128, 64 ) -- Capture the displayed image

  imagetable = {} -- create a table to hold it
  local i = 1
  for y=0, 32-1 do
  for x=0, 64-1 do -- Loop though all the pixels in the frame
      r, g, b, a = capture:getPixel( x,y )
      --print(r, g, b, a)
      imagetable[#imagetable+1] = ((r+b+g)/3) -- store as the average color
    end
  end
  --print(#imagetable, imagetable[3]) -- Display count


  for i=1, #imagetable do -- Convert the image to 0/1 depending on how grey it is.
    local blackorwhite = 0
    if imagetable[i] <= adj_level then
      blackorwhite = 1
    end
    imagetable[i] = blackorwhite
  end

  -- Sanity Test
  local string=""
  for i=1, #imagetable do
    string = string .. imagetable[i]
    if i % 64 == 0 then
      string = string .. "\n"
    end
  end
  print(string)

  clip = ""
  for tile=0, 31 do
  string = ""
  for i=1, 8 do
    ox = (i-1) * 64
    tj = math.floor(tile/8) * (7*64)

  local lineseg = {
    imagetable[(1+tj+(8*tile))+ox],
    imagetable[(2+tj+(8*tile))+ox],
    imagetable[(3+tj+(8*tile))+ox],
    imagetable[(4+tj+(8*tile))+ox],
    imagetable[(5+tj+(8*tile))+ox],
    imagetable[(6+tj+(8*tile))+ox],
    imagetable[(7+tj+(8*tile))+ox],
    imagetable[(8+tj+(8*tile))+ox],
    --print("Derp", (8+tj+(8*tile))+ox)
  }
  string = string .. bitnum(lineseg) .. " "

  end
  --print(": tile_" .. tile)
  --print(string)
  clip = clip .. string .. "\n"
  --print(tile, (math.floor(tile / 16)))
  end
end

function to_clipboard()
love.system.setClipboardText( tostring(clip) )
end
