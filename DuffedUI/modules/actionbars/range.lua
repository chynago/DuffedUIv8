local T, C, L = select(2, ...):unpack()

local _G = _G
local unpack = unpack
local TukuiActionBars = T["ActionBars"]
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local HasAction = HasAction

function TukuiActionBars:RangeOnUpdate(elapsed)
	if not self.rangeTimer then
		return
	end
	
	TukuiActionBars.RangeUpdate(self)
end

function TukuiActionBars:RangeUpdateBackdrop(IsUsable, NotEnoughMana, OutOfRange)
	if not self.Backdrop then
		return
	end
	
	local Backdrop = self.Backdrop
	local Action = self.action
	
	if (IsUsable and OutOfRange) or (NotEnoughMana and OutOfRange) then
		Backdrop:SetBackdropBorderColor(1, 0, 0)
	elseif (not HasAction(Action)) or (IsUsable) then
		Backdrop:SetBackdropBorderColor(unpack(C.Medias.BorderColor))
	elseif (NotEnoughMana) then
		Backdrop:SetBackdropBorderColor(0.1, 0.1, 1)
	else
		Backdrop:SetBackdropBorderColor(0.3, 0.3, 0.3)
	end
end

function TukuiActionBars:RangeUpdate()
	local Name = self:GetName()
	local Icon = _G[Name.."Icon"]
	local Backdrop = self.Backdrop
	local Action = self.action
	local IsUsable, NotEnoughMana = IsUsableAction(Action)
	local OutOfRange = (IsActionInRange(Action) == 0)
	
	if (IsUsable and OutOfRange) or (NotEnoughMana and OutOfRange) then
		Icon:SetVertexColor(1, 0, 0)
		Icon:SetDesaturated(false)
	elseif (IsUsable) then
		Icon:SetVertexColor(1, 1, 1)
		Icon:SetDesaturated(false)
	elseif (NotEnoughMana) then
		Icon:SetVertexColor(0.1, 0.1, 1)
		Icon:SetDesaturated(false)
	else
		Icon:SetVertexColor(0.3, 0.3, 0.3)
		Icon:SetDesaturated(true)
	end
	
	TukuiActionBars.RangeUpdateBackdrop(self, IsUsable, NotEnoughMana, OutOfRange)
end


function TukuiActionBars:RangeUpdateWatchFrame(elapsed)
	-- to be completed
end


hooksecurefunc("ActionButton_OnUpdate", TukuiActionBars.RangeOnUpdate)
hooksecurefunc("ActionButton_Update", TukuiActionBars.RangeUpdateBackdrop)
hooksecurefunc("ActionButton_UpdateUsable", TukuiActionBars.RangeUpdate)
hooksecurefunc("WatchFrameItem_OnUpdate", TukuiActionBars.RangeUpdateWatchFrame)