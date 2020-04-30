--[[
    
    Matter Lua filter for Pandoc.

    Only used for LaTeX output.
      
--]]

if FORMAT:match 'latex' then

    function Pandoc(doc)
        local next = next 
        local myblocks = {}
        havebooks = false
        haveparts = false
        havemain = false
        for i,el in pairs(doc.blocks) do
            if (el.tag == 'Header') and el.level then
                -- Make \mainmatter if needed; I don't write them in the markdown files.
                if el.level == 1 then
                    if next(el.classes) == nil and not havemain then
                        table.insert(el.classes, 'mainmatter')
                    end
                    if el.classes:find('part') and not havemain and not haveparts then
                        table.insert(el.classes, 'mainmatter')
                    end            
                end
                -- Clear the part page
                if haveparts then
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\cleardoublepage'))
                    haveparts=false
                end
                -- \mainmatter
                --
                -- My template starts with '\openright'. I like that for the \frontmatter,
                -- however, for the \mainmatter it should be \openany.
                --
                -- Above there is a \cleardoublepage to open new parts on the right again.
                --
                -- mainmatter can be combined with either book or part.
                if el.classes:find('mainmatter') then
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\openany'))
                    if havebooks then
                        -- It's \mainmatter inside a \book
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\mainmatter*'))
                    else
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\mainmatter'))
                    end
                    havemain = true
                end
                -- \book
                if el.classes:find('book') then
                    -- Reset the toc back to normal. We might have changed it below.
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{0}}'))
                    -- Check if it is the first book
                    if not havebooks then
                        -- Start with mainmatter before opening the first book
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\mainmatter'))
                        havebooks = true
                        havemain = true
                    else
                        -- Set  the counter back that we might have changed with \backmatter
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\setcounter{secnumdepth}{1}'))               
                    end
                    -- Open \frontmatter* as well when starting a book. The * is needed
                    -- for the correct page count. The \cleardoublepage makes sure
                    -- the book starts on a recto page.
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\cleardoublepage'))
                    table.insert(myblocks,pandoc.RawBlock('latex',
                        string.format('\\hypertarget{%s}{%%\n\\book{%s}\\label{%s}}',
                            el.identifier,pandoc.utils.stringify(el.content),el.identifier)))
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\frontmatter*'))
                    -- Clear el
                    el = nil
                    haveparts = false
                    havemain = false
                -- \part
                elseif el.classes:find('part') then
                    -- No subpages in TOC when have a Part in a Book; it's too much.
                    if havebooks then
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{-1}}'))
                    end
                
                    el = pandoc.RawBlock('latex',
                        string.format('\\hypertarget{%s}{%%\n\\part{%s}\\label{%s}}',
                            el.identifier,pandoc.utils.stringify(el.content),el.identifier))
                    haveparts = true
                -- \backmatter
                --
                -- Backmatter can't be inside a book so we fake it a bit.
                --
                -- Cleardoublepage to start them on the right.
                elseif el.classes:find('backmatter') then
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\cleardoublepage'))
                    if havebooks then
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\setcounter{secnumdepth}{-10}'))
                    else
                        -- Reset TOC index or else it will still be a part of the \part.
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\bookmarksetup{startatroot}'))
                        table.insert(myblocks,pandoc.RawBlock('latex', '\\backmatter'))
                    end
                -- Custum class to get a \backmatter after all books
                elseif el.classes:find('backcollection') then                
                    -- Reset TOC index
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\addtocontents{toc}{\\protect\\setcounter{tocdepth}{0}}'))
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\bookmarksetup{startatroot}'))
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\cleardoublepage'))
                    table.insert(myblocks,pandoc.RawBlock('latex', '\\backmatter'))
                    haveparts = false
                    havebooks = false
                end
            end
            table.insert(myblocks, el)
        end
        return pandoc.Pandoc(myblocks, doc.meta)
    end

end
