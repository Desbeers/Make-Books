--[[
    
    Linebreak Lua filter for Pandoc.
      
--]]

function HorizontalRule(el)
    if FORMAT:match 'latex' then
        el = pandoc.RawBlock('latex','\\bigskip')
    elseif FORMAT:match 'epub' then
        el = pandoc.RawBlock('html','<div class="bigskip" />')
    end
    return el
end
