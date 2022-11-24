--[[

WARNING: place this file into the same folder as the exedit.auf (mainly plugins folder or scripts folder)


this file is part of ChangeColor.anm, which is developed by Aodaruma.
mainly used for color space interpolation.
if you want to use this file, please keep the header and follow the license of ChangeColor.anm script.

by Aodaruma (twitter: @Aodaruma_)
]]

-------------------------------------------------------------------------------
-- converting functions from one color space to another
-------------------------------------------------------------------------------

local function RGB2CMYK(rgb, cmyk)
    local k = 1 - math.max(rgb[1], rgb[2], rgb[3])
    local c = (1 - rgb[1] - k) / (1 - k)
    local m = (1 - rgb[2] - k) / (1 - k)
    local y = (1 - rgb[3] - k) / (1 - k)
    cmyk[1] = c
    cmyk[2] = m
    cmyk[3] = y
    cmyk[4] = k
end

local function CMYK2RGB(cmyk, rgb)
    local c = cmyk[1]
    local m = cmyk[2]
    local y = cmyk[3]
    local k = cmyk[4]
    rgb[1] = 1 - c * (1 - k) - k
    rgb[2] = 1 - m * (1 - k) - k
    rgb[3] = 1 - y * (1 - k) - k
end

local function RGB2YUV(rgb, yuv)
    local mat = {
        { 0.299, 0.587, 0.114 },
        { -0.14713, -0.28886, 0.436 },
        { 0.615, -0.51499, -0.10001 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            yuv[i] = yuv[i] + mat[i][j] * rgb[j]
        end
    end
end

local function YUV2RGB(yuv, rgb)
    local mat = {
        { 1, 0, 1.13983 },
        { 1, -0.39465, -0.58060 },
        { 1, 2.03211, 0 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            rgb[i] = rgb[i] + mat[i][j] * yuv[j]
        end
    end
end

local function RGB2YCbCr(rgb, ycbcr)
    local mat = {
        { 0.299, 0.587, 0.114 },
        { -0.168736, -0.331264, 0.5 },
        { 0.5, -0.418688, -0.081312 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            ycbcr[i] = ycbcr[i] + mat[i][j] * rgb[j]
        end
    end
end

local function YCbCr2RGB(ycbcr, rgb)
    local mat = {
        { 1, 0, 1.402 },
        { 1, -0.344136, -0.714136 },
        { 1, 1.772, 0 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            rgb[i] = rgb[i] + mat[i][j] * ycbcr[j]
        end
    end
end

local function RGB2YIQ(rgb, yiq)
    local mat = {
        { 0.299, 0.587, 0.114 },
        { 0.596, -0.274, -0.322 },
        { 0.211, -0.523, 0.312 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            yiq[i] = yiq[i] + mat[i][j] * rgb[j]
        end
    end
end

local function YIQ2RGB(yiq, rgb)
    local mat = {
        { 1, 0.956, 0.621 },
        { 1, -0.272, -0.647 },
        { 1, -1.105, 1.702 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            rgb[i] = rgb[i] + mat[i][j] * yiq[j]
        end
    end
end

local function RGB2XYZ(rgb, xyz)
    local mat = {
        { 0.412453, 0.357580, 0.180423 },
        { 0.212671, 0.715160, 0.072169 },
        { 0.019334, 0.119193, 0.950227 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            xyz[i] = xyz[i] + mat[i][j] * rgb[j]
        end
    end
end

local function XYZ2RGB(xyz, rgb)
    local mat = {
        { 3.240479, -1.537150, -0.498535 },
        { -0.969256, 1.875992, 0.041556 },
        { 0.055648, -0.204043, 1.057311 }
    }
    for i = 1, 3 do
        for j = 1, 3 do
            rgb[i] = rgb[i] + mat[i][j] * xyz[j]
        end
    end
end

local function XYZ2CIELAB(xyz, lab)
    local x = xyz[1] / 95.047
    local y = xyz[2] / 100.000
    local z = xyz[3] / 108.883

    local function f(t)
        if t > 0.008856 then
            return t ^ (1 / 3)
        else
            return 7.787 * t + 16 / 116
        end
    end

    x = f(x)
    y = f(y)
    z = f(z)

    lab[1] = 116 * y - 16
    lab[2] = 500 * (x - y)
    lab[3] = 200 * (y - z)
end

local function CIELAB2XYZ(lab, xyz)
    local y = (lab[1] + 16) / 116
    local x = lab[2] / 500 + y
    local z = y - lab[3] / 200

    local function f(t)
        if t ^ 3 > 0.008856 then
            return t ^ 3
        else
            return (t - 16 / 116) / 7.787
        end
    end

    x = f(x) * 95.047
    y = f(y) * 100.000
    z = f(z) * 108.883

    xyz[1] = x
    xyz[2] = y
    xyz[3] = z
end

local function XYZ2Oklab(xyz, oklab)
    -- referenced: https://bottosson.github.io/posts/oklab/
    local l = 0.4122214708 * xyz[1] + 0.5363325363 * xyz[2] + 0.0514459929 * xyz[3]
    local m = 0.2119034982 * xyz[1] + 0.6806995451 * xyz[2] + 0.1073969566 * xyz[3]
    local s = 0.0883024619 * xyz[1] + 0.2817188376 * xyz[2] + 0.6299787005 * xyz[3]

    local function f(t)
        if t > 0.2068965517 then
            return t ^ (1 / 3)
        else
            return 7.787037037 * t + 16 / 116
        end
    end

    l = f(l)
    m = f(m)
    s = f(s)

    oklab[1] = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
    oklab[2] = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
    oklab[3] = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
end

local function Oklab2XYZ(oklab, xyz)
    -- referenced: https://bottosson.github.io/posts/oklab/
    local l = 0.9999999984 * oklab[1] + 0.3963377774 * oklab[2] + 0.2158037573 * oklab[3]
    local m = 0.9999999989 * oklab[1] - 0.1055613458 * oklab[2] - 0.0638541728 * oklab[3]
    local s = 0.9999999982 * oklab[1] - 0.0894841775 * oklab[2] - 1.2914855480 * oklab[3]

    local function f(t)
        if t ^ 3 > 0.0088564516 then
            return t ^ 3
        else
            return (t - 16 / 116) / 7.787037037
        end
    end

    l = f(l)
    m = f(m)
    s = f(s)

    xyz[1] = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    xyz[2] = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    xyz[3] = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

local function RGB2HCT(rgb, hct, ipType)
    --referenced: https://material.io/blog/science-of-color-design
    local yiq = { 0, 0, 0 }
    RGB2YIQ(rgb, yiq)
    local lab = { 0, 0, 0 }
    XYZ2CIELAB(yiq, lab)
    local oklab = { 0, 0, 0 }
    XYZ2Oklab(lab, oklab)

    local l = oklab[1]
    local a = oklab[2]
    local b = oklab[3]

    local c = math.sqrt(a * a + b * b)
    local h = math.atan2(b, a) / math.pi * 180

    hct[1] = h
    hct[2] = c
    hct[3] = l
end

local function HCT2RGB(hct, rgb)
    -- referenced: https://material.io/blog/science-of-color-design
    local h = hct[1]
    local c = hct[2]
    local l = hct[3]

    local a = math.cos(h / 180 * math.pi) * c
    local b = math.sin(h / 180 * math.pi) * c

    local oklab = { l, a, b }
    local lab = { 0, 0, 0 }
    Oklab2XYZ(oklab, lab)
    local yiq = { 0, 0, 0 }
    CIELAB2XYZ(lab, yiq)
    RGB2YIQ(yiq, rgb)
end

-------------------------------------------------------------------------------
-- some varidation test functions
-------------------------------------------------------------------------------

local function checkValidCode(code)
    if type(code) ~= "number" then
        error("checkValidCodeError: code is not a number")
    end
    if code < 0x000000 or code > 0xffffff then
        error(("checkValidCodeError: invalid code, code should be in [0x000000, 0xffffff]; but got 0x%x").format(code))
    end
end

local function checkAF(af, num)
    if type(af) ~= "table" then
        error(("checkAFerror: af is not a table; got %s"):format(type(af)))
    end
    if #af ~= num then
        error("checkAFerror: element number is not " .. num)
    end

    for i = 1, num do
        if type(af[i]) ~= "number" then
            error(("checkAFerror: element %d is not a number; got %s"):format(i, type(af[i])))
        end
        if af[i] < 0 or af[i] > 1 then
            error(("checkAFerror: element %d is not in [0, 1]; got %f"):format(i, af[i]))
        end
    end
end

local function checkIpType(ipType)
    if type(ipType) ~= "number" then
        error(("checkIpTypeError: ipType is not a number; got %s"):format(type(ipType)))
    end
end

-------------------------------------------------------------------------------
-- color code interpolation functions
-------------------------------------------------------------------------------
local function iRGB(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)

    local r = r1 + (r2 - r1) * af[1]
    local g = g1 + (g2 - g1) * af[2]
    local b = b1 + (b2 - b1) * af[3]
    return RGB(r, g, b)
end

local function iHSV(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local h1, s1, v1 = HSV(code1)
    local h2, s2, v2 = HSV(code2)

    local h
    local s = s1 + (s2 - s1) * af[2]
    local v = v1 + (v2 - v1) * af[3]

    if ipType == 1 then
        -- farthest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 2 then
        -- clockwise
        if h2 - h1 < 0 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 3 then
        -- counterclockwise
        if h2 - h1 > 0 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    else
        -- nearest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    end
    return HSV(h, s, v)
end

local function iHSL(code1, code2, af, ipType)
    local h1, s1, v1 = HSV(code1)
    local h2, s2, v2 = HSV(code2)
    local l1, l2 = (2 - v1) * s1 / 2, (2 - v2) * s2 / 2

    local h
    local l = l1 + (l2 - l1) * af[2]
    local s = s1 + (s2 - s1) * af[3]

    if ipType == 1 then
        -- farthest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 2 then
        -- clockwise
        if h2 - h1 < 0 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 3 then
        -- counterclockwise
        if h2 - h1 > 0 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    else
        -- nearest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    end
    local v = (l + s) / 2
    return HSV(h, s, v)
end

local function iYUV(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local yuv1, yuv2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2YUV({ r1, g1, b1 }, yuv1)
    RGB2YUV({ r2, g2, b2 }, yuv2)

    local y = yuv1[1] + (yuv2[1] - yuv1[1]) * af[1]
    local u = yuv1[2] + (yuv2[2] - yuv1[2]) * af[2]
    local v = yuv1[3] + (yuv2[3] - yuv1[3]) * af[3]

    local rgb = { 0, 0, 0 }
    YUV2RGB({ y, u, v }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iYCbCr(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local ycbcr1, ycbcr2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2YCbCr({ r1, g1, b1 }, ycbcr1)
    RGB2YCbCr({ r2, g2, b2 }, ycbcr2)

    local y = ycbcr1[1] + (ycbcr2[1] - ycbcr1[1]) * af[1]
    local cb = ycbcr1[2] + (ycbcr2[2] - ycbcr1[2]) * af[2]
    local cr = ycbcr1[3] + (ycbcr2[3] - ycbcr1[3]) * af[3]

    local rgb = { 0, 0, 0 }
    YCbCr2RGB({ y, cb, cr }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iXYZ(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local xyz1, xyz2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2XYZ({ r1, g1, b1 }, xyz1)
    RGB2XYZ({ r2, g2, b2 }, xyz2)

    local x = xyz1[1] + (xyz2[1] - xyz1[1]) * af[1]
    local y = xyz1[2] + (xyz2[2] - xyz1[2]) * af[2]
    local z = xyz1[3] + (xyz2[3] - xyz1[3]) * af[3]

    local rgb = { 0, 0, 0 }
    XYZ2RGB({ x, y, z }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iCIELAB(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local xyz1, xyz2 = { 0, 0, 0 }, { 0, 0, 0 }
    local lab1, lab2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2XYZ({ r1, g1, b1 }, xyz1)
    RGB2XYZ({ r2, g2, b2 }, xyz2)
    XYZ2CIELAB(xyz1, lab1)
    XYZ2CIELAB(xyz2, lab2)

    local l = lab1[1] + (lab2[1] - lab1[1]) * af[1]
    local a = lab1[2] + (lab2[2] - lab1[2]) * af[2]
    local b = lab1[3] + (lab2[3] - lab1[3]) * af[3]

    local xyz = { 0, 0, 0 }
    local rgb = { 0, 0, 0 }
    CIELAB2XYZ({ l, a, b }, xyz)
    XYZ2RGB(xyz, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iOklab(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local xyz1, xyz2 = { 0, 0, 0 }, { 0, 0, 0 }
    local lab1, lab2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2XYZ({ r1, g1, b1 }, xyz1)
    RGB2XYZ({ r2, g2, b2 }, xyz2)
    XYZ2Oklab(xyz1, lab1)
    XYZ2Oklab(xyz2, lab2)

    local l = lab1[1] + (lab2[1] - lab1[1]) * af[1]
    local a = lab1[2] + (lab2[2] - lab1[2]) * af[2]
    local b = lab1[3] + (lab2[3] - lab1[3]) * af[3]

    local xyz = { 0, 0, 0 }
    local rgb = { 0, 0, 0 }
    Oklab2XYZ({ l, a, b }, xyz)
    XYZ2RGB(xyz, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iYIQ(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local yiq1, yiq2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2YIQ({ r1, g1, b1 }, yiq1)
    RGB2YIQ({ r2, g2, b2 }, yiq2)

    local y = yiq1[1] + (yiq2[1] - yiq1[1]) * af[1]
    local i = yiq1[2] + (yiq2[2] - yiq1[2]) * af[2]
    local q = yiq1[3] + (yiq2[3] - yiq1[3]) * af[3]

    local rgb = { 0, 0, 0 }
    YIQ2RGB({ y, i, q }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iCMYK(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 4
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local cmyk1, cmyk2 = { 0, 0, 0, 0 }, { 0, 0, 0, 0 }
    RGB2CMYK({ r1, g1, b1 }, cmyk1)
    RGB2CMYK({ r2, g2, b2 }, cmyk2)

    local c = cmyk1[1] + (cmyk2[1] - cmyk1[1]) * af[1]
    local m = cmyk1[2] + (cmyk2[2] - cmyk1[2]) * af[2]
    local y = cmyk1[3] + (cmyk2[3] - cmyk1[3]) * af[3]
    local k = cmyk1[4] + (cmyk2[4] - cmyk1[4]) * af[4]

    local rgb = { 0, 0, 0 }
    CMYK2RGB({ c, m, y, k }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

local function iHCT(code1, code2, af, ipType)
    local CS_VARIABLE_NUM = 3
    checkValidCode(code1)
    checkValidCode(code2)
    checkAF(af, CS_VARIABLE_NUM)
    checkIpType(ipType)

    local r1, g1, b1 = RGB(code1)
    local r2, g2, b2 = RGB(code2)
    local hct1, hct2 = { 0, 0, 0 }, { 0, 0, 0 }
    RGB2HCT({ r1, g1, b1 }, hct1)
    RGB2HCT({ r2, g2, b2 }, hct2)

    local h
    local c = hct1[2] + (hct2[2] - hct1[2]) * af[2]
    local t = hct1[3] + (hct2[3] - hct1[3]) * af[3]

    local h1, h2 = hct1[1], hct2[1]
    if ipType == 1 then
        -- farthest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 2 then
        -- clockwise
        if h2 - h1 < 0 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    elseif ipType == 3 then
        -- counterclockwise
        if h2 - h1 > 0 then
            h = h1 + (h2 - h1 - 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    else
        -- nearest
        if h2 - h1 > 180 then
            h = h1 + (h2 - h1 - 360) * af[1]
        elseif h2 - h1 < -180 then
            h = h1 + (h2 - h1 + 360) * af[1]
        else
            h = h1 + (h2 - h1) * af[1]
        end
    end

    local rgb = { 0, 0, 0 }
    HCT2RGB({ h, c, t }, rgb)
    return RGB(rgb[1], rgb[2], rgb[3])
end

--------------------------------------------------------------------------------

return {
    converters = {
        -- fromRGB
        RGB2YUV = RGB2YUV,
        RGB2YCbCr = RGB2YCbCr,
        RGB2XYZ = RGB2XYZ,
        RGB2YIQ = RGB2YIQ,
        RGB2CMYK = RGB2CMYK,
        RGB2HCT = RGB2HCT,
        -- toRGB
        YUV2RGB = YUV2RGB,
        YCbCr2RGB = YCbCr2RGB,
        XYZ2RGB = XYZ2RGB,
        YIQ2RGB = YIQ2RGB,
        CMYK2RGB = CMYK2RGB,
        HCT2RGB = HCT2RGB,

        -- fromXYZ
        XYZ2CIELAB = XYZ2CIELAB,
        XYZ2Oklab = XYZ2Oklab,
        -- toXYZ
        CIELAB2XYZ = CIELAB2XYZ,
        Oklab2XYZ = Oklab2XYZ,
    },

    interpolators = {
        RGB = { iRGB, 3 },
        CMYK = { iCMYK, 4 },
        HSL = { iHSL, 3 },
        HSV = { iHSV, 3 },
        YUV = { iYUV, 3 },
        YCbCr = { iYCbCr, 3 },
        YIQ = { iYIQ, 3 },
        XYZ = { iXYZ, 3 },
        CIELAB = { iCIELAB, 3 },
        Oklab = { iOklab, 3 },
        HCT = { iHCT, 3 },
    },
}
