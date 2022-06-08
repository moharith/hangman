LETTER_A = 97
LETTER_Z = 122

WINDOW_HEIGHT = 768
WINDOW_WIDTH = 1024

local fontGroot = love.graphics.newFont(30)
local ingedrukteToets = key


local woord = "boomkever"
local woordlengte = string.len(woord)

local tabel = {}
local alfabet = {}



function love.load()
    --
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Galgje')

    for i = LETTER_A, LETTER_Z do
        table.insert(alfabet, {letter = i, status = "neutraal"})
    end
end

function love.keypressed(key, scancode)
    ingedrukteToets = tostring(key)
    if key == 'escape' then
        love.event.quit()
    end




    for i = 1, woordlengte do 
        if string.byte(ingedrukteToets) ~= tabel[i].lettercode then
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
  

    love.graphics.print(string.byte(tostring(ingedrukteToets)))
    love.graphics.print(alfabet[2].letter, 70, 70)

    for i = 1, woordlengte do
        i = string.sub(woord, i, i) 
        ichar = string.byte(i)
        table.insert(tabel, { lettercode = ichar, show="nee"})
    end




    woordstring()

    -- for i = 1, woordlengte do
    --     if string.byte(ingedrukteToets) == tabel
    -- end

end

function woordstring()
    for i = 1, woordlengte do   
        if tabel[i].show == "ja" then
            love.graphics.setColor(1,1,1,1)
            love.graphics.print((string.char(tabel[i].lettercode)), 200 + (35 * i), 400)
        else 
            love.graphics.setColor(0,0,0,0)
        end
    end

    wow()
   love.graphics.setColor(1,1,1,1)
end