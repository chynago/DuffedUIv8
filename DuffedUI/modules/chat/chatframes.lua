local D, C, L = select(2, ...):unpack()

-- Tukz Note from Hydra Last Commit :
	-- I deleted FramePosition function, we will only run it once after install and will not force users to always have chat at default position.
	-- Added a note below where the install function is located.
	-- PLAYER_ENTERING_WORLD event on DuffedUIChat will not be needed anymore when we will create the install process.
	-- find the event which randomly move chat position from default and unregister it.

if (not C["chat"].Enable) then
	return
end

local _G = _G
local format = format
local Noop = function() end
local Toast = BNToastFrame
local ToastCloseButton = BNToastFrameCloseButton
local DataTextLeft = D["Panels"].DataTextLeft
local LeftChatBackground = D["Panels"].LeftChatBackground
local RightChatBackground = D["Panels"].RightChatBackground
local CubeLeft = D["Panels"].CubeLeft
local DuffedUIChat = CreateFrame("Frame")

-- Update editbox border color
function DuffedUIChat:UpdateEditBoxColor()
	local EditBox = ChatEdit_ChooseBoxForSend()	
	local ChatType = EditBox:GetAttribute("chatType")
	local Backdrop = EditBox.Backdrop

	if Backdrop then
		if (ChatType == "CHANNEL") then
			local ID = GetChannelName(EditBox:GetAttribute("channelTarget"))
			
			if (ID == 0) then
				--Backdrop:SetBackdropBorderColor(unpack(C["medias"].BorderColor)) -- [[ NOTE! Just leaving these here for now if you decide you don't like this feature. Will remove them up if you do. ]]
				D.GradientFrame(Backdrop, "Border", 0, 0.5, unpack(C["medias"].BorderColor))
			else
				--Backdrop:SetBackdropBorderColor(ChatTypeInfo[ChatType..ID].r,ChatTypeInfo[ChatType..ID].g,ChatTypeInfo[ChatType..ID].b)
				D.GradientFrame(Backdrop, "Border", 0, 0.5, ChatTypeInfo[ChatType..ID].r, ChatTypeInfo[ChatType..ID].g, ChatTypeInfo[ChatType..ID].b)
			end
		else
			--Backdrop:SetBackdropBorderColor(ChatTypeInfo[ChatType].r,ChatTypeInfo[ChatType].g,ChatTypeInfo[ChatType].b)
			D.GradientFrame(Backdrop, "Border", 0, 0.5, ChatTypeInfo[ChatType].r, ChatTypeInfo[ChatType].g, ChatTypeInfo[ChatType].b)
		end
	end
end

function DuffedUIChat:StyleFrame(frame)
	if frame.IsSkinned then
		return
	end
	
	local Frame = frame
	local ID = frame:GetID()
	local FrameName = frame:GetName()
	local Tab = _G[FrameName.."Tab"]
	local TabText = _G[FrameName.."TabText"]
	local EditBox = _G[FrameName.."EditBox"]

	if Tab.conversationIcon then
		Tab.conversationIcon:Kill()
	end
	
	-- Hide editbox every time we click on a tab
	Tab:HookScript("OnClick", function()
		EditBox:Hide()
	end)

	-- Change tab font
	TabText:SetShadowColor(0, 0, 0)
	TabText:SetShadowOffset(1.25, -1.25)
	
	Frame:SetClampRectInsets(0, 0, 0, 0)
	Frame:SetClampedToScreen(false)
	Frame:SetFading(C["chat"].Fade)

	-- Move the edit box
	EditBox:ClearAllPoints()
	EditBox:Point("TOPLEFT", LeftChatTab or DataTextLeft, 2, -2)
	EditBox:Point("BOTTOMRIGHT", LeftChatTab or DataTextLeft, -2, 2)
	
	-- Disable alt key usage
	EditBox:SetAltArrowKeyMode(false)
	
	-- Hide editbox on login
	EditBox:Hide()
	
	-- Hide editbox instead of fading
	EditBox:HookScript("OnEditFocusLost", function(self)
		self:Hide()
	end)
	
	-- create our own texture for edit box
	EditBox:CreateBackdrop()
	EditBox.Backdrop:ClearAllPoints()
	if C["chat"].lBackground then EditBox.Backdrop:SetAllPoints(LeftChatTab) else EditBox.Backdrop:SetAllPoints(DataTextLeft) end
	EditBox.Backdrop:SetFrameStrata("LOW")
	EditBox.Backdrop:SetFrameLevel(1)
	EditBox.Backdrop:SetBackdropColor(unpack(C["medias"].BackdropColor))
	
	-- Hide textures
	for i = 1, #CHAT_FRAME_TEXTURES do
		_G[FrameName..CHAT_FRAME_TEXTURES[i]]:SetTexture(nil)
	end

	-- Remove default chatframe tab textures				
	_G[format("ChatFrame%sTabLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabRight", ID)]:Kill()

	_G[format("ChatFrame%sTabSelectedLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", ID)]:Kill()
	
	_G[format("ChatFrame%sTabHighlightLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabHighlightMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabHighlightRight", ID)]:Kill()

	_G[format("ChatFrame%sTabSelectedLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", ID)]:Kill()

	_G[format("ChatFrame%sButtonFrameUpButton", ID)]:Kill()
	_G[format("ChatFrame%sButtonFrameDownButton", ID)]:Kill()
	_G[format("ChatFrame%sButtonFrameBottomButton", ID)]:Kill()
	_G[format("ChatFrame%sButtonFrameMinimizeButton", ID)]:Kill()
	_G[format("ChatFrame%sButtonFrame", ID)]:Kill()

	_G[format("ChatFrame%sEditBoxFocusLeft", ID)]:Kill()
	_G[format("ChatFrame%sEditBoxFocusMid", ID)]:Kill()
	_G[format("ChatFrame%sEditBoxFocusRight", ID)]:Kill()

	-- Kill off editbox artwork
	local A, B, C = select(6, EditBox:GetRegions())
	A:Kill()
	B:Kill()
	C:Kill()

	Frame.IsSkinned = true
end

function DuffedUIChat:KillPetBattleCombatLog(Frame)
	if (_G[Frame:GetName().."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG)) then
		return FCF_Close(Frame)
	end
end

function DuffedUIChat:StyleTempFrame()
	local Frame = FCF_GetCurrentChatFrame()

	DuffedUIChat:KillPetBattleCombatLog(Frame)

	-- Make sure it's not skinned already
	if Frame.IsSkinned then
		return
	end

	-- Pass it on
	DuffedUIChat:StyleFrame(Frame)
end

function DuffedUIChat:SkinToastFrame()
	Toast:ClearAllPoints()
	Toast:SetPoint("TOPLEFT", UIParent, 3, -3)
	Toast:SetTemplate("Transparent")
	Toast:CreateShadow()
	ToastCloseButton:SkinCloseButton()
end

function DuffedUIChat:SetDefaultChatFramesPositions()
	if not DuffedUIDataPerChar.Chat then DuffedUIDataPerChar.Chat = {} end
	
	local Width = DataTextLeft:GetWidth()

	for i = 1, NUM_CHAT_WINDOWS do
		local Frame = _G["ChatFrame"..i]
		local ID = Frame:GetID()
		
		-- Set font size and chat frame size
		Frame:Size(Width, 116)
		
		-- Set default chat frame position
		if (ID == 1) then
			Frame:ClearAllPoints()
			if C["chat"].lBackground then
				Frame:Point("BOTTOMLEFT", LeftChatBackground, "BOTTOMLEFT", 7, 9)
			else
				Frame:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 5)
			end
		elseif (C["chat"].LootFrame and ID == 4) then
			if (not Frame.isDocked) then
				Frame:ClearAllPoints()
				if C["chat"].rBackground then
					Frame:Point("BOTTOMRIGHT", RightChatBackground, "BOTTOMRIGHT", -13, 9)
				else
					Frame:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5)
				end
				Frame:SetJustifyH("RIGHT")
			end
		end
		
		if (ID == 1) then
			FCF_SetWindowName(Frame, "G, S & W")
		end
		
		if (ID == 2) then
			FCF_SetWindowName(Frame, "Log")
		end
		
		if (ID == 3) then
			FCF_SetWindowName(Frame, "Whisper")
		end		
		
		if (not Frame.isLocked) then
			FCF_SetLocked(Frame, 1)
		end
		
		-- Save chat frame settings
		local a1, p, a2, x, y = Frame:GetPoint()
		DuffedUIDataPerChar.Chat["Frame" .. i] = {a1, a2, x, y, Width, 111}
	end
end

function DuffedUIChat:SetChatFramePosition()
	if not DuffedUIDataPerChar.Chat then
		return
	end

	local Frame = self
	local ID = self:GetID()
	local Settings = DuffedUIDataPerChar.Chat["Frame" .. ID]
	
	if Settings then
		local a1, a2, x, y, w, h = unpack(Settings)

		Frame:SetUserPlaced(true)
		Frame:ClearAllPoints()
		Frame:SetPoint(a1, UIParent, a2, x, y)
		Frame:SetSize(w, h)
	end
end

-- Hydra Note:
-- We don't have an install process yet, so it's here for now. (Only handling position for now, not channels/groups)

-- Tukz Note:
-- It's better like this anyway, because we will call TukuiChat:Install() in the Installation of Tukui. You are free to complete this function.
-- I prefer like this because I would like everything chat frames related to be include in chat module folder. Same for others modules we will write.
function DuffedUIChat:Install()
	-- Create our custom chatframes
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_OpenNewWindow(GENERAL)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)

	if C["chat"].LootFrame then
		FCF_OpenNewWindow(LOOT)
		FCF_UnDockFrame(ChatFrame4)
		ChatFrame4:Show()
	end
	
	-- Set more chat groups
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, TRADE)
	ChatFrame_RemoveChannel(ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(ChatFrame1, "LocalDefense") -- Don't forget to localize me, There's no global strings for these but i'll keep looking for another method maybe.
	ChatFrame_RemoveChannel(ChatFrame1, "GuildRecruitment")
	ChatFrame_RemoveChannel(ChatFrame1, "LookingForGroup")
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	
	-- Setup the whisper chat frame
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "BN_CONVERSATION")
	
	-- Setup the right chat
	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddChannel(ChatFrame4, TRADE)
	ChatFrame_AddChannel(ChatFrame4, GENERAL)
	ChatFrame_AddChannel(ChatFrame4, "LocalDefense") -- Don't forget to localize me
	ChatFrame_AddChannel(ChatFrame4, "GuildRecruitment")
	ChatFrame_AddChannel(ChatFrame4, "LookingForGroup")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame4, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame4, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame4, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame4, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame4, "IGNORED")
	
	-- Enable Classcolor
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
	
	DEFAULT_CHAT_FRAME:SetUserPlaced(true)
	
	if (not C["chat"].LootFrame) then
		if (FCF_GetChatWindowInfo(ChatFrame4:GetID()) == LOOT) then
			FCF_Close(ChatFrame4)
		end
	end
	
	self:SetDefaultChatFramesPositions()
end

function DuffedUIChat:Setup()
	for i = 1, NUM_CHAT_WINDOWS do
		local Frame = _G["ChatFrame"..i]
		
		self:StyleFrame(Frame)
		FCFTab_UpdateAlpha(Frame)
	end
	
	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	
	-- Tabs Alpha Settings
	CHAT_TAB_SHOW_DELAY = 0.2
	CHAT_TAB_HIDE_DELAY = 2
	CHAT_FRAME_FADE_TIME = 0.15
	CHAT_FRAME_FADE_OUT_TIME = 2.0
	CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0.2

	CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1.0
	CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1.0
	CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.4
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	
	CubeLeft:SetScript("OnMouseDown", function(self, Button)
		local ChatMenu = ChatMenu
		
		if (Button == "LeftButton") then	
			ToggleFrame(ChatMenu)
		end
	end)
end

-- Kill stuff
ChatConfigFrameDefaultButton:Kill()
ChatFrameMenuButton:Kill()
FriendsMicroButton:Kill()

DuffedUIChat:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIChat:RegisterEvent("ADDON_LOADED")
DuffedUIChat:SetScript("OnEvent", function(self, event, addon)
	if (event == "PLAYER_ENTERING_WORLD") then
		self:CreateCopyFrame()
		self:CreateCopyButtons()
		self:UnregisterEvent(event)
	elseif (addon == "Blizzard_CombatLog") then
		self:Setup()
		self:SkinToastFrame()
		self:UnregisterEvent(event)
	end
end)

hooksecurefunc("ChatEdit_UpdateHeader", DuffedUIChat.UpdateEditBoxColor)
hooksecurefunc("FCF_OpenTemporaryWindow", DuffedUIChat.StyleTempFrame)
hooksecurefunc("FCF_RestorePositionAndDimensions", DuffedUIChat.SetChatFramePosition)

D["Chat"] = DuffedUIChat