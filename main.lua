-- constants
LETTER_A = 97
LETTER_Z = 122
WINDOW_HEIGHT = 768
WINDOW_WIDTH = 1024


-- initialize local vars and tables
local ingedrukteToets = key

local tabel = {}
local alfabet = {}
local woordentabel = {}

local newgame = false
local streak = 0


-- Font and Soundtables
gFont = { 
    ['fontGroot'] = love.graphics.newFont("alagard.ttf", 30),
    ['fontZeerGroot'] = love.graphics.newFont("alagard.ttf", 50)
}

gSound = {
    ['backgroundMusic'] = love.audio.newSource('Libraries/Music/Exploration.mp3', 'stream'),
    ['Blip'] = love.audio.newSource('Libraries/Sound/Blip.wav', 'static')
}



gSound['backgroundMusic']:setLooping( true )
gSound['backgroundMusic']:play()



function init()
    -- reset tables
    tabel = {}
    alfabet = {}
    newgame = false -- reset newgame
    kieswoord() -- select a random word 

    woordlengte = string.len(woord)

    -- create alfabet table and flag ''neutraal''
    for i = LETTER_A, LETTER_Z do
        table.insert(alfabet, {letter = i, status = "neutraal"})
    end

    -- create word (char) table, and flag ''nee'
    for i = 1, woordlengte do
        i = string.sub(woord, i, i) 
        ichar = string.byte(i)
        table.insert(tabel, { lettercode = ichar, show="nee"})
    end

end

function love.load()
    -- Could run the push lub, but fine for now.
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false
    })
    love.window.setTitle('Galgje')
    -- randomize
    math.randomseed(os.time())
    -- readln from txt to table ( maybe categorize later (BUG: ö , ä , ë ))
    for line in love.filesystem.lines("wordlist.txt") do
        table.insert(woordentabel,line)
    end
    init()

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

    -- main loop to check for correct chars ( can fix bug to allow chars outside of A - Z)
    if string.byte(ingedrukteToets) >= LETTER_A and string.byte(ingedrukteToets) <= LETTER_Z and ingedrukteToets ~= 'return'  then

        gSound['Blip']:stop()
        gSound['Blip']:play()

        -- If key does not corresponds with letters from word , then label false
        for i = 1, woordlengte do 
            if string.byte(ingedrukteToets) ~= tabel[i].lettercode  then
                for k, v in pairs(alfabet) do
                    if alfabet[k].letter == string.byte(ingedrukteToets) then
                    alfabet[k].status = "fout"
                    end
                end
            end
        end

        -- if key does corresponds then label good

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

    -- draw afabet on screen and color flags

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
    woordstring() 
    PrintAlfabet() 
    tekengalg()
-- 
end

-- laat woord op beeld ontstaan
function woordstring()
    for i = 1, woordlengte do   
        love.graphics.setFont(gFont['fontGroot'])
        love.graphics.printf((i), 0 + (45 * i), 600, 200, "center") 
        love.graphics.setFont(gFont['fontZeerGroot'])

        -- print word or _ _ _ _ _ 
 
        if tabel[i].show == "ja" then
            love.graphics.setColor(1,1,1,1)

            love.graphics.printf((string.char(tabel[i].lettercode)), 0 + (45 * i), 550, 200, "center")
        else
            love.graphics.printf(("_"), 0 + (45 * i), 550, 200, "center")

        end
    end 
    love.graphics.setFont(gFont['fontGroot'])
   love.graphics.setColor(1,1,1,1)
end

-- laat score zien
function checkscore(levens)

    local max = woordlengte
    local levens = 10

        -- if error then life -1
        for k = 1, #alfabet do
            if alfabet[k].letter ~= ingedrukteToets and alfabet[k].status == "fout"  then
                levens = levens - 1
            end
        end

        -- for loop to check for complete word

        for k = 1, woordlengte do
            if tabel[k].show == "ja" then 
                max = max - 1
            end
        end

        -- if max = 0 then word is completed
        if max == 0  then

            -- give an extra life BUG --> life is declared local, now resets to 10 every time, rather want it local on top, but then the counter keeps increasing.

            levens = levens + 1
            love.graphics.setFont(gFont['fontZeerGroot'])
            love.graphics.setColor(0,1,0,1)    
            love.graphics.printf("Gewonnen!", WINDOW_WIDTH / 3 , WINDOW_HEIGHT / 4, 300, 'center')            
            love.graphics.setColor(1,1,1,1)  
            love.graphics.setFont(gFont['fontGroot'])
            love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /3)
           -- max = max -1
            wongame = true


        end

<<<<<<< HEAD
        if levens <= 0 then
            -- love.graphics.clear()
            love.graphics.setFont(gFont['fontGroot'])
                love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /4)
                love.graphics.print("Het woord was ... ", WINDOW_WIDTH / 2 - 300 , WINDOW_HEIGHT /3)
=======
        -- if not alive then show word in red

        if levens <= 0 then
            love.graphics.setFont(gFont['fontGroot'])

            love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 400 , WINDOW_HEIGHT /4)
            love.graphics.print("Het woord was ... ", WINDOW_WIDTH / 2 - 400 , WINDOW_HEIGHT /3)
            for i = 1, woordlengte do   
>>>>>>> 6264a61a7ff2ab482a73ba1cc5d72bbff79f527e
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


-- draw the gallow

function tekengalg()
    love.graphics.setColor(1,1,1,1)
<<<<<<< HEAD
    animatie:draw(spriteSheet, 950, 600)
=======
    love.graphics.setLineWidth(10)
>>>>>>> 6264a61a7ff2ab482a73ba1cc5d72bbff79f527e

    if checkscore(levens) <= 9 then
        love.graphics.line(700,500, 900, 500) -- angle -- y lengte
    end
    if checkscore(levens) <= 8 then
        love.graphics.line(700,500, 700, 200) -- angle -- y lengte
    end
    if checkscore(levens) <= 7 then
        love.graphics.line(700,200, 850, 200) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 6 then
        love.graphics.line(850,200, 850, 250) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 5 then
        love.graphics.circle("line",850, 275, 25) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 4 then
        love.graphics.line(850,300, 850, 400) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 3 then
        love.graphics.line(850,300, 900, 350) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 2 then
        love.graphics.line(800,350, 850, 300) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 1 then
        love.graphics.line(850,400, 900, 450) -- x1 y1 x2 y2
    end
    if checkscore(levens) <= 0 then
        love.graphics.line(800,450, 850, 400) -- x1 y1 x2 y2
    end
    love.graphics.setLineWidth(1)
end

-- pick a random word from the table
function kieswoord()
    woord = woordentabel[math.random(1,#woordentabel)]
    end
    