--[[
    
    'chapter précis' Lua filter for Pandoc.

    Only for ePub output. LaTeX is smarter, it is a 'subparagraph' and I can style it as I like.
      
--]]

function Header(el)
    if FORMAT:match 'epub' then
        content = pandoc.utils.stringify(el.content)
        if el.level == 2 then
            el = pandoc.RawBlock('html',string.format('<div class="section">%s</div>',content))
        end
        if el.level == 3 then
            el = pandoc.RawBlock('html',string.format('<div class="subsection">%s</div>',content))
        end
        if el.level == 4 then
            el = pandoc.RawBlock('html',string.format('<div class="subsubsection">%s</div>',content))
        end
        if el.level == 6 then
            el = pandoc.RawBlock('html',string.format('<div class="subparagraph">%s</div>',content))
        end
    end
    return el
end
