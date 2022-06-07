woord = "waterpomp"
woordarray = { }
geradenletters = { } 

local letterkeuzes = string
local letters = string
score = 5

function love.load()
love.window.setMode(1024, 768, {
    vsync = true,
    fullscreen = false,
    resizable = true
})

    woordlengte = string.len(woord)

    for char in string.gmatch(woord, ".") do
        woordarray[#woordarray+1] = char
    end

end

function woordcheck()
    local match 
    for i=1, #woordarray do
        if letterkeuze == geradenletters[i]
            then 
                match = false
        end
    end

    if match == false then
                score = score - 1
    else
return
    end
            match = 0
end

function love.keypressed(key)
    if key and key:match( '%a' ) then character = key 
        local i = 0
        letterkeuze = key
        woordcheck()
        table.insert(geradenletters,letterkeuze)
    end


    

    if key == " return " then
        love.event.quit()
    end
end

function love.update(dt)
    if score == 0 then
        --  love.event.quit()
    end 



end

function love.draw()
love.graphics.print(score, 100, 100 , 100)
    --- print strepen voor letterkeuzes
    for k, v in pairs(woordarray) do
        love.graphics.printf("_", 10 * k, 10, 200)
   --     love.graphics.printf(woordarray[k], 10, 20 * k, 200)

    end


    -- per letter in woord
        for k, letters in pairs(woordarray) do
            -- per geraden letter
            for o, inhoud in pairs(geradenletters) do
                if letters == geradenletters[o] then
                    love.graphics.printf(letters, 10 * k, 10, 200)
                end
            end
        end
     --   x = false
   -- end

end

