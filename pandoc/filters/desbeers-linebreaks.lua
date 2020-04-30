--[[
    
    Linebreak Lua filter for Pandoc.
      
--]]

function HorizontalRule(el)
    if FORMAT:match 'latex' then
        el = pandoc.RawBlock('latex','\\bigskip')
    elseif FORMAT:match 'html' or FORMAT:match 'epub' then
        el = pandoc.RawBlock('html','<div class="bigskip" />')
    elseif FORMAT:match 'docx' then
        el = pandoc.RawBlock('openxml','<w:p><w:br /><w:br /></w:p>')
    end
    return el
end
