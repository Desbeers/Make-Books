--[[
    
    Dropcaps Lua filter for Pandoc.
            
--]]

function Pandoc(doc)
    local myblocks = {}
    for i,el in pairs(doc.blocks) do
        if (el.tag == 'Header') and (el.level == 1) then
            firstpara = true            
        elseif (el.tag == 'Para' and firstpara) then
            el = Dropcap(el)
            firstpara = false        
        end
        table.insert(myblocks, el)
    end
    return pandoc.Pandoc(myblocks, doc.meta)
end

function Dropcap(el)
    --Letterine for the first word in a paragraph.
    if el.content[1]['text'] then
        -- The first word is just normal
        if FORMAT:match 'latex' then
            el.content[1] = pandoc.RawInline('latex',
                string.format('\\lettrine{%s}{%s}', string.sub(el.content[1]['text'],1,1),
                    string.sub(el.content[1]['text'],2)))
        elseif FORMAT:match 'epub' then
            el.content[1] = pandoc.RawInline('html',
                string.format('<span class="dropcap dropcap-%s">%s</span><span class="smallcaps">%s</span>',
                string.lower(string.sub(el.content[1]["text"],1,1)), string.sub(el.content[1]["text"],1,1), string.sub(el.content[1]["text"],2)))
        end
    elseif el.content[1]['quotetype'] then
        -- The first word starts with a quote so it needs a smelly hacking
        local words = {}
        words[1], words[2] = (pandoc.utils.stringify(el.content[1]['content'])):match("(%S+)(.+)")
        -- print (words[1])
        -- print (words[2])
        if FORMAT:match 'latex' then
            el.content[1] = pandoc.RawInline('latex',
                string.format('\\lettrine[ante=``]{%s}{%s}',
                    string.sub(words[1],1,1), string.sub(words[1],2))..words[2].."''")
        elseif FORMAT:match 'epub' then
            el.content[1] = pandoc.RawInline('html',
                string.format('<span class="dropante">“</span><span class="dropcap dropcap-%s">%s</span><span class="smallcaps">%s</span>',
                string.lower(string.sub(words[1],1,1)), string.sub(words[1],1,1), string.sub(words[1],2))..words[2].."”")
        end
        -- TODO: this script doesn't like '...' in the quote if it is after the first word...
        -- It also doesn't like a single word in a quote.
        -- dump(el.content[1])
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
