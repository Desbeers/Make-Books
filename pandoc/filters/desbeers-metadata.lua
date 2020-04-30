-- Pandoc Lua init file
-- --------------------
-- Set default values if not set in the metadata files.

function Meta(meta)
    if not meta['papersize'] then
      meta['papersize'] = meta['defaultpaper']
    end
    if not meta['fontsize'] then
      meta['fontsize'] = meta['defaultfont']
    end
    return meta
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