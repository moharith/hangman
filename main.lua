-- constants
LETTER_A = 97
LETTER_Z = 122
WINDOW_HEIGHT = 768
WINDOW_WIDTH = 1024

local anim8 = require 'Libraries/anim8'

require("Libraries/Init")


local ingedrukteToets = key

local tabel = {}
local alfabet = {}
local woordentabel = {}

local newgame = false
local streak = 0


gSound['backgroundMusic']:setLooping( true )
gSound['backgroundMusic']:play()

--[[ 
    ANIMATIE
]]

spriteSheet = love.graphics.newImage('Libraries/skelet.png')
grid = anim8.newGrid(50,50,spriteSheet:getWidth(),spriteSheet:getHeight())
animatie = anim8.newAnimation(grid('1-4',1 ),0.2)




function init()
    tabel = {}
    alfabet = {}

    newgame = false
    kieswoord()
    woordlengte = string.len(woord)

    for i = LETTER_A, LETTER_Z do
        table.insert(alfabet, {letter = i, status = "neutraal"})
    end

    for i = 1, woordlengte do
        i = string.sub(woord, i, i) 
        ichar = string.byte(i)
        table.insert(tabel, { lettercode = ichar, show="nee"})
    end

end

function love.load()
    --
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false
    })
    love.window.setTitle('Galgje')
    math.randomseed(os.time())
    -- laad alle woorden in
    for line in love.filesystem.lines("wordlist.txt") do
        table.insert(woordentabel,line)
    end
    init()

end

function love.update(dt)
    animatie:update(dt)
end


function love.keypressed(key, scancode)
    ingedrukteToets = tostring(key)
    if key == 'escape' then
        love.event.quit()
    end

    if newgame then
        if key == 'return' then
            streak = 0
            init()
        end
    end

    if wongame then
        if key == 'return' then
            wongame = false
            streak = streak + 1
            init()
        end
    end

    if string.byte(ingedrukteToets) >= LETTER_A and string.byte(ingedrukteToets) <= LETTER_Z and ingedrukteToets ~= 'return'  then

        gSound['Blip']:stop()
        gSound['Blip']:play()

        for i = 1, woordlengte do 
            if string.byte(ingedrukteToets) ~= tabel[i].lettercode  then
                for k, v in pairs(alfabet) do
                    if alfabet[k].letter == string.byte(ingedrukteToets) then
                    alfabet[k].status = "fout"
                    end
                end
            end
        end

        for i = 1, woordlengte do 
            if string.byte(ingedrukteToets) == tabel[i].lettercode then
                tabel[i].show = "ja"
                for k, v in pairs(alfabet) do
                    
                    if alfabet[k].letter == tabel[i].lettercode  then
                    --  love.graphics.setColor(0,1,0,1)
                    alfabet[k].status = "goed"
                    end

                end
            end
        end
    end


end

function PrintAlfabet()
    local x = 0
    local n = 0

    for i = LETTER_A, LETTER_Z do
        n = n + 1

        if alfabet[n].status == "neutraal" then
            love.graphics.setColor(0,0,0,0)
        end
        if alfabet[n].status == "goed" then
            love.graphics.setColor(0,1,0,1)
        end
        if alfabet[n].status == "fout" then
            love.graphics.setColor(1,0,0,1)
        end        
        love.graphics.printf(string.char(i), x - 40, WINDOW_HEIGHT - 100, 200, "center")
        x = x + 35       

    end
    love.graphics.setColor(1,1,1,1)
end



function love.draw()
    love.graphics.setFont(gFont['fontGroot'])
    checkscore()  

    woordstring() -- woord op beeld
    PrintAlfabet() -- alfebet op beeld
    tekengalg()
-- 
end

-- laat woord op beeld ontstaan
function woordstring()
    for i = 1, woordlengte do   
        love.graphics.setFont(gFont['fontGroot'])
        love.graphics.printf((i), 0 + (45 * i), 600, 200, "center") 
        love.graphics.setFont(gFont['fontZeerGroot'])

 
        if tabel[i].show == "ja" then
            love.graphics.setColor(1,1,1,1)

            love.graphics.printf((string.char(tabel[i].lettercode)), 0 + (45 * i), 550, 200, "center")
        else
            love.graphics.printf(("_"), 0 + (45 * i), 550, 200, "center")
        
            -- love.graphics.setColor(0,0,0,0)
        end
    end 
    love.graphics.setFont(gFont['fontGroot'])
   love.graphics.setColor(1,1,1,1)
end

-- laat score zien
function checkscore(levens)
    local max = woordlengte
    local levens = 10

        for k = 1, #alfabet do
            if alfabet[k].letter ~= ingedrukteToets and alfabet[k].status == "fout"  then
                levens = levens - 1
            end
        end

        for k = 1, woordlengte do
            if tabel[k].show == "ja" then 
                max = max - 1
            end
        end

        if max == 0  then

            levens = levens + 1
            love.graphics.setFont(gFont['fontZeerGroot'])
            love.graphics.setColor(0,1,0,1)    -- groen
            love.graphics.printf("Gewonnen!", WINDOW_WIDTH / 3 , WINDOW_HEIGHT / 4, 300, 'center')            
            love.graphics.setColor(1,1,1,1)  
            love.graphics.setFont(gFont['fontGroot'])
            love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /3)
           -- max = max -1
            wongame = true


        end

        if levens <= 0 then
            -- love.graphics.clear()
            love.graphics.setFont(gFont['fontGroot'])
                love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /4)
                love.graphics.print("Het woord was ... ", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /3)
                love.graphics.setFont(gFont['fontZeerGroot'])
            for i = 1, woordlengte do   
                
                if tabel[i].show == "nee" then
                love.graphics.setColor(1,0,0,1)
                love.graphics.printf((string.char(tabel[i].lettercode)), 0 + (45 * i), 550, 200, "center") 

                
                end  
                love.graphics.setColor(1,1,1,1)    
            end

            newgame = true
        end

        love.graphics.print("LEVENS: " .. levens .. "  STREAK  " .. streak,WINDOW_WIDTH - 500,0)
        return(levens)
end

function tekengalg()
    love.graphics.setColor(1,1,1,1)
    animatie:draw(spriteSheet, 950, 600)

    if checkscore(levens) <= 9 then
        love.graphics.setLineWidth(10)
        love.graphics.line(700,450, 900, 450) -- angle -- y lengte
    end
    if checkscore(levens) <= 8 then
        love.graphics.setLineWidth(10)
        love.graphics.line(700,450, 700, 200) -- angle -- y lengte
    end
    -- if checkscore(levens) <= 7 then
    --     love.graphics.setLineWidth(10)
    --     love.graphics.line(700,450, 700, 350) -- angle -- y lengte
    -- end
end

    
function kieswoord()
    woord = woordentabel[math.random(1,#woordentabel)]
    end
    