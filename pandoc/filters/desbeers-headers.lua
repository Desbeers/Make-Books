--[[
    
    Header Lua filter for Pandoc.

    Only used for ePub output.
      
--]]

if FORMAT:match 'epub' then

    function Pandoc(doc)
        local myblocks = {}
        havebooks = false
        haveparts = false
        ischapter = false
        chaptercount = 0
        for i,el in pairs(doc.blocks) do
            if (el.tag == 'Header') and el.level then
                -- Mark chapters as chapters
                if el.level == 1 and next(el.classes) == nil and not ischapter then
                    ischapter = true
                    chaptercount = 1
                end
                -- Preserve header level in a class
                table.insert(el.classes, string.format('header%s',el.level))
                -- Custum class to get a \backmatter after all books
                if el.classes:find('backcollection') then
                    haveparts = false
                    havebooks = false
                    ischapter = false
                end
                -- When we have books; shift the headers inside those parts.
                if el.classes:find('book') then
                    havebooks = true
                    haveparts = false
                    ischapter = false
                end
                if havebooks and not el.classes:find('book') then
                    table.insert(el.classes, 'inbook')
                    el.level = el.level + 1
                end
                -- Backmatter is never in a part
                if el.classes:find('backmatter') then
                    haveparts = false
                    ischapter = false
                end
                -- When we have parts; shift the headers inside those parts.
                if el.classes:find('part') then
                    haveparts = true
                    chaptercount = 1
                end
                if haveparts and not el.classes:find('part') then
                    table.insert(el.classes, 'inpart')
                    el.level = el.level + 1
                end
                 -- Smart stuff that I don't understand myself...
                if ischapter and el.classes:find('header1') and not el.classes:find('book') and not el.classes:find('part') then
                    table.insert(el.classes, 'chapter')
                    if (doc.meta['chapter-style']) then
                        table.insert(el.classes, 'chapter-' .. doc.meta['chapter-style'][1]['text'])
                    end
                    table.insert(el.content,1,pandoc.RawInline('html','<span class="counter">' .. 
                        chaptercount .. '</span><span class="counterspacer">.&nbsp;</span>'))
                    chaptercount = chaptercount + 1
                end
            end
            table.insert(myblocks, el)
        end
        return pandoc.Pandoc(myblocks, doc.meta)
    end

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
