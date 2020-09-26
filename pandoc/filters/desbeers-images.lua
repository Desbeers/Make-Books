--[[
    
    Image Lua filter for Pandoc.
      
--]]

-- REWRITE FIGURE for LaTeX
--
-- \begin{figure}[htbp]
-- \centering
-- \includegraphics{Image Source}
-- \caption*{Image Title}
-- \end{figure}

function Image (el)
    if FORMAT:match 'latex' then
        local theimage
        theimage = '\\medskip\n'
        theimage = theimage .. '\\begin{figure}[H]\n'
        theimage = theimage .. '\\centering\n'
        theimage = theimage .. '\\captionsetup{width=.92\\linewidth}\n'
        if el['attributes']['width'] then
            theimage = theimage .. string.format('\\includegraphics[width=%s\\textwidth]',(
                string.gsub(el['attributes']['width'],'%%','') / 100))
        else
            theimage = theimage .. '\\includegraphics[width=0.92\\textwidth]'        
        end 
        theimage = theimage .. string.format('{%s}\n', el["src"])
        if el["caption"][1] then
            theimage = theimage .. string.format('\\caption*{%s}\n' , pandoc.utils.stringify(el["caption"]))
        end
        theimage = theimage .. '\\end{figure}\n'
        return pandoc.RawInline('latex',theimage)
    else
        -- Default with is 80%
        if not el['attributes']['width'] then
            el['attributes']['width'] = "92%"
        end
    end
    return el
end

