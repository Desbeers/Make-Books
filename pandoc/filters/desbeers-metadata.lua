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
    -- Cheap and dirty "date to year".
    if meta['date'] then
      meta['year'] = string.sub(pandoc.utils.stringify(meta['date']),1, 4)
    end
    if meta['group-position'] then
      meta.series =  pandoc.utils.stringify(meta['belongs-to-collection']) .. " " ..
          pandoc.utils.to_roman_numeral(pandoc.utils.stringify(meta['group-position']))
    end
    return meta
end
