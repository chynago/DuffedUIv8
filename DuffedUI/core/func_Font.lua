local D, C, L = unpack(select(2, ...))

if D.Client == "zhTW" then
	C["media"].font = C["media"].tw_font
	C["media"].dmgfont = C["media"].tw_dmgfont
elseif D.Client == "zhCN" then
	C["media"].font = C["media"].cn_font
	C["media"].dmgfont = C["media"].cn_dmgfont
end

local duffed = CreateFont("DuffedUI")
duffed:SetFont(C["media"].font, 11, "THINOUTLINE")

local duffed_alt = CreateFont("DuffedUI_Alt")
duffed_alt:SetFont(C["media"].font2, 12, "THINOUTLINE")

local pixel = CreateFont("PixelFont")
pixel:SetFont(C["media"].pixelfont, 12, "MONOCHROMEOUTLINE")

local MakeFont = {
	["DuffedUI"] = "DuffedUI",
	["Pixel Font"] = "PixelFont",
	["DuffedUI Alternativ"] = "DuffedUI_Alt",
}

D.Font = function(value)
	if MakeFont[value] then
		return MakeFont[value]
	else
		return MakeFont["DuffedUI"]
	end
end