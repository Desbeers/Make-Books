--[[

    Native Lua filter for Pandoc.

    Only used for Pandoc native output.

--]]

if FORMAT:match 'native' then

    function Pandoc(doc)
        local myblocks = {}
        havebooks = false
        haveparts = false
        ischapter = false
        chaptercount = 0
        for i,el in pairs(doc.blocks) do
            if (el.tag == 'Header') and el.level then
                -- Make sure all headers have an unique ID
                el.identifier = 'bookid-' .. i
            end
            table.insert(myblocks, el)
        end
        return pandoc.Pandoc(myblocks, doc.meta)
    end

end
