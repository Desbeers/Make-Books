--[[
    
    Image Lua filter for Pandoc.
      
--]]

function Image (el)
    -- Default width is 92%
    if not el['attributes']['width'] then
        el['attributes']['width'] = "92%"
    end
    if not el["caption"][1] then
        --- This Image will not be treated as a Figure so we do it here
        if FORMAT:match 'latex' then
            local theimage
            theimage = '\\medskip\n'
            theimage = theimage .. '\\begin{figure}[H]\n'
            theimage = theimage .. '\\centering\n'
            theimage = theimage .. string.format('\\includegraphics[width=%s\\textwidth]',
                (string.gsub(el['attributes']['width'],'%%','') / 100))
            theimage = theimage .. string.format('{%s}\n', el["src"])
            theimage = theimage .. '\\end{figure}\n'
            return pandoc.RawInline('latex',theimage)
        end
    end
    return el
end
