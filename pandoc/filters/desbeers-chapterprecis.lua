--[[
    
    chapter précis Lua filter for Pandoc.

   Only for ePub output. LaTeX sees it as 'subparagraph'.
      
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
    return el
end

-- debug
function dump(t,indent)
    local names = {}
    if not indent then indent = "" end
    for n,g in pairs(t) do
        table.insert(names,n)
    end
    table.sort(names)
    for i,n in pairs(names) do
        local v = t[n]
        if type(v) == "table" then
            if(v==t) then -- prevent endless loop if table contains reference to itself
                print(indent..tostring(n)..": <-")
            else
                print(indent..tostring(n)..":")
                dump(v,indent.."   ")
            end
        else
            if type(v) == "function" then
                print(indent..tostring(n).."()")
            else
                print(indent..tostring(n)..": "..tostring(v))
            end
        end
    end
end