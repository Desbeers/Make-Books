--[[
    
    Header Lua filter for Pandoc.
      
--]]

function Meta(m)
  
end

function Pandoc(doc)
    local next = next 
    local myblocks = {}
    havebooks = false
    haveparts = false
    ischapter = false
    chaptercount = 0
    for i,el in pairs(doc.blocks) do
        if (el.tag == 'Header') and el.level then
            -- Give it an ID. This kills automatic internal hyperlinks,
            -- but this avoids duplicated ID's when combining Markdown files.
            el.identifier = 'bookid-' .. i
            -- Always start H1 on a new page in Word documents.
            if FORMAT:match 'docx' and el.level == 1 then
                table.insert(myblocks,pandoc.RawBlock('openxml',
                    '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'))
            end
            if (FORMAT:match 'html' or FORMAT:match 'epub' or FORMAT:match 'docx') then            
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
                if (FORMAT:match 'html' or FORMAT:match 'epub') then
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
            end
        end
        table.insert(myblocks, el)
    end
    return pandoc.Pandoc(myblocks, doc.meta)
end

