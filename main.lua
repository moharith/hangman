LETTER_A = 97
LETTER_Z = 122

WINDOW_HEIGHT = 768
WINDOW_WIDTH = 1024

local fontGroot = love.graphics.newFont(30)
local fontZeerGroot = love.graphics.newFont(50)


local ingedrukteToets = key

local streak = 0

local tabel = {}
local alfabet = {}
local woordentabel = {}

local newgame = false


function init()
    tabel = {}
    alfabet = {}
    local levens = 10
    local newgame = false
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
        resizable = true
    })
    love.window.setTitle('Galgje')
    math.randomseed(os.time())
    -- laad alle woorden in
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
            init()
        end
    end

    if string.byte(ingedrukteToets) >= LETTER_A and string.byte(ingedrukteToets) <= LETTER_Z and ingedrukteToets ~= 'return'  then

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

function wow()
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
        love.graphics.printf(string.char(i), x - 40, WINDOW_HEIGHT - 150, 200, "center")
        x = x + 35       

    end
    love.graphics.setColor(1,1,1,1)
end



function love.draw()
    love.graphics.setFont(fontGroot)
    
-- love.graphics.print(woord, 100, 100)

    woordstring()
    wow()
    checkscore()
end

-- laat woord op beeld ontstaan
function woordstring()
    for i = 1, woordlengte do   
        if tabel[i].show == "ja" then
            love.graphics.setColor(1,1,1,1)
            love.graphics.setFont(fontZeerGroot)
            love.graphics.print((string.char(tabel[i].lettercode)), 200 + (45 * i), 400)
        else 
            love.graphics.setColor(0,0,0,0)
        end
    end 
    love.graphics.setFont(fontGroot)
   love.graphics.setColor(1,1,1,1)
end

-- laat score zien
function checkscore()
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
                if max == 0 then 
                    streak = streak + 1
                    levens = levens + 1
                    init()
                end
            end
        end

        if levens <= 0 then
            love.graphics.clear()
            love.graphics.print("Druk op enter om een nieuw potje te spelen", WINDOW_WIDTH / 2 - 200 , WINDOW_HEIGHT /2)
            newgame = true
        end

        love.graphics.print("LEVENS: " .. levens .. "  STREAK  " .. streak,WINDOW_WIDTH - 500,0)
    end


    
function kieswoord()
    woord = woordentabel[math.random(1,#woordentabel)]
    end
    