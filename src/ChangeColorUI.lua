--[[

WARNING: place this file into the same folder as the exedit.auf (mainly plugins folder or scripts folder)


this file is part of ChangeColor.anm, which is developed by Aodaruma.
mainly used for color space interpolation.
if you want to use this file, please keep the header and follow the license of ChangeColor.anm script.

by Aodaruma (twitter: @Aodaruma_)
]]

-- font set func
local function setFontAriel(size, isBold, isItalic)
    isBold = isBold or false
    isItalic = isItalic or false
    local fontname = "Arial"
    if isBold then
        fontname = fontname .. " Bold"
    end
    if isItalic then
        fontname = fontname .. " Italic"
    end
    obj.setfont(fontname, size)
end

local function setFontCourier(size, isBold, isItalic)
    isBold = isBold or false
    isItalic = isItalic or false
    local fontname = "Courier New"
    if isBold then
        fontname = fontname .. " Bold"
    end
    if isItalic then
        fontname = fontname .. " Italic"
    end
    obj.setfont(fontname, size)
end
