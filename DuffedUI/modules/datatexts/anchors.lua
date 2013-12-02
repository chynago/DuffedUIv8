local T, C = select(2, ...):unpack()

-- Local values
local MenuFrame = CreateFrame("Frame", "DataTextToggleDropDown", UIParent, "UIDropDownMenuTemplate")
local TukuiDT = T["DataTexts"]
local Anchors = TukuiDT.Anchors
local Menu = TukuiDT.Menu
local Active = false
local CurrentFrame

TukuiDT.Toggle = function(self, object)
	CurrentFrame:SetData(object)
end

TukuiDT.Remove = function()
	CurrentFrame:RemoveData()
end

-- Add a remove button
tinsert(Menu, {text = "|cffFF0000"..REMOVE.."|r", notCheckable = true, func = TukuiDT.Remove})

local OnMouseDown = function(self)
	CurrentFrame = self
	EasyMenu(Menu, DataTextToggleDropDown, "cursor", 0, 5, "MENU", 2)
end

function TukuiDT:ToggleDataPositions()
	if Active then
		for i = 1, self.NumAnchors do
			local Frame = Anchors[i]
			
			Frame:EnableMouse(false)
			Frame.Tex:SetTexture(0.2, 1, 0.2, 0)
		end
		
		Active = false
	else
		for i = 1, self.NumAnchors do
			local Frame = Anchors[i]
			
			Frame:EnableMouse(true)
			Frame.Tex:SetTexture(0.2, 1, 0.2, 0.2)
			Frame:SetScript("OnMouseDown", OnMouseDown)
		end
		
		Active = true
	end
end

-- Color stuff, move me later
local DataColor1, DataColor2
local Hex = T.RGBToHex

if TukuiDataPerChar then
	TukuiDT.NameColor = TukuiDataPerChar.DTNameColor
	TukuiDT.ValueColor = TukuiDataPerChar.DTValueColor
else
	-- Default to the colors defined by media
	DataColor1 = C["Medias"].PrimaryDataTextColor or {1, 1, 1}
	DataColor2 = C["Medias"].SecondaryDataTextColor or {1, 1, 1}
	
	TukuiDT.NameColor = Hex(unpack(DataColor1))
	TukuiDT.ValueColor = Hex(unpack(DataColor2))
end

local Color -- Not sure if this is needed, should be able to get around it
local ActiveInfo

local ColorInfo1 = {}
local ColorInfo2 = {}

local Callback = function(cancel)
	local R, G, B
	
	if cancel then
		R, G, B = unpack(cancel)
	else
		R, G, B = ColorPickerFrame:GetColorRGB()
	end

	TukuiDT[Color] = Hex(R, G, B)
	ActiveInfo.colorCode = Hex(R, G, B)
	ActiveInfo.r = R
	ActiveInfo.g = G
	ActiveInfo.b = B
	
	TukuiDT:ForceUpdate()
end

local InitColorPicker = function(r, g, b)
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.previousValues = {r, g, b}
	ColorPickerFrame.func = Callback
	ColorPickerFrame.cancelFunc = Callback
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

local OnClick = function(self, info)
	Color = info.Name
	ActiveInfo = info
	InitColorPicker(info.r, info.g, info.b)
end

-- Color table properties
ColorInfo1.text = COLOR .. " 1"
ColorInfo1.func = OnClick
ColorInfo1.arg1 = ColorInfo1
ColorInfo1.notCheckable = true
ColorInfo1.colorCode = TukuiDT.NameColor
ColorInfo1.r = DataColor1[1]
ColorInfo1.g = DataColor1[2]
ColorInfo1.b = DataColor1[3]
ColorInfo1.Name = "NameColor"

ColorInfo2.text = COLOR .. " 2"
ColorInfo2.func = OnClick
ColorInfo2.arg1 = ColorInfo2
ColorInfo2.notCheckable = true
ColorInfo2.colorCode = TukuiDT.ValueColor
ColorInfo2.r = DataColor2[1]
ColorInfo2.g = DataColor2[2]
ColorInfo2.b = DataColor2[3]
ColorInfo2.Name = "ValueColor"

-- Insert them into the menu
tinsert(Menu, {text = "", notCheckable = true})
tinsert(Menu, ColorInfo1)
tinsert(Menu, ColorInfo2)