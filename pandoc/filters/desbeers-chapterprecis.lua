--[[
    
    chapter précis Lua filter for Pandoc.

    \chapterprecis = in body and TOC
    \chapterprecishere = only in body
    \chapterprecistoc = only in TOC
      
--]]

function Header(el)
    content = pandoc.utils.stringify(el.content)
    if el.level == 2 then
        if FORMAT:match 'html' or FORMAT:match 'epub' then
            el = pandoc.RawBlock('html',string.format('<div class="section">%s</div>',content))
        end
    end
    if el.level == 3 then
        if FORMAT:match 'html' or FORMAT:match 'epub' then
            el = pandoc.RawBlock('html',string.format('<div class="subsection">%s</div>',content))
        end
    end
    if el.level == 4 then
        if FORMAT:match 'html' or FORMAT:match 'epub' then
            el = pandoc.RawBlock('html',string.format('<div class="subsubsection">%s</div>',content))
        end
    end
    if el.level == 6 then
        if FORMAT:match 'latex' then
            el = pandoc.RawBlock('latex',string.format('\\chapterprecishere{%s}',content))
        elseif FORMAT:match 'html' or FORMAT:match 'epub' then
            el = pandoc.RawBlock('html',string.format('<div class="chapterprecis">%s</div>',content))
        end
    end
    return el
end
