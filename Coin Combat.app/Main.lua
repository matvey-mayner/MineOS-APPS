local image = require("Image")
local fs = require("filesystem")
local event = require("event")
local GUI = require("GUI")
local system = require("System")
local OE = require("opengames")
local gamepath = string.gsub(system.getCurrentScript(),"/Main.lua","")
game = fs.readTable(gamepath.."/Game.dat")
game.localization=system.getCurrentScriptLocalization()
local wk,win,menu = system.addWindow(GUI.filledWindow(1,1,game.window.width,game.window.height,0x989898))
win:removeChildren()
local BG = win:addChild(GUI.panel(1,1,game.window.width,game.window.height,game.window.color)) 
local TITLE = win:addChild(GUI.text(math.floor(game.window.width/2-#game.window.title/2),1,game.window.titleColor,game.window.title))
for i = 1,#game.screen do
 if game.screen[i].type == "animation" then
 game.screen[i].tick = function(anim)     anim.stage = anim.stage + 1    if anim.atlas:getImage(tostring(anim.stage)) then       anim.raw.image = anim.atlas:getImage(tostring(anim.stage))      return true, "next"    else       anim.stage = 1      anim.raw.image = anim.atlas:getImage(tostring(anim.stage))       return true, "new"    end    end    game.screen[i].checkNext = function(anim)     local tmp = anim.stage + 1    if anim.atlas:getImage(tostring(tmp)) then      return "next"    else      return "new"    end		 end local path = gamepath.."/Animation_data/"..game.screen[i].name.."/Atlas.pic"
game.screen[i].atlas = require("imageAtlas").init(path,string.gsub(path,"Atlas.pic","Config.cfg"))
end
end
OE.init({gamePath = gamepath, editor = false,game = game, container = win})
OE.draw()
 for i = 1,#game.scripts do
 if game.scripts[i].autoload == true then
 system.execute(game.scripts[i].path)
 end
 end
