--[[
    
    Quotes Lua filter for Pandoc.
      
--]]

function Quoted(el)
    el.quotetype = 'DoubleQuote'
    for i in pairs(el.content) do
        if el.content[i].quotetype then
            el.content[i].quotetype = 'SingleQuote'
        end
    end
    return el
end

