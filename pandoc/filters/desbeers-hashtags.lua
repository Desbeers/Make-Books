--[[
    
    Hashtags Lua filter for Pandoc.
            
--]]

function Para(el)
    if (el.content[1]['text']) then
        if string.sub(el.content[1]["text"],1,1) == '#' then
            el = {}
        end
    end
    return el
end
