local T, C, L = select(2, ...):unpack()

if (not C.Chat.Enable) then
	return
end

local TukuiChat = T["Chat"]
local gsub = gsub
local strsub = strsub
local Color = T.RGBToHex(unpack(C.Chat.LinkColor)) or "FFFF00"
local UseBracket = C.Chat.LinkBrackets
local UseColor = true

function TukuiChat:PrintURL(url)
	if UseColor then
		if UseBracket then
			url = Color.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = Color.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if UseBracket then
			url = "|Hurl:"..url.."|h["..url.."]|h "
		else
			url = "|Hurl:"..url.."|h"..url.."|h "
		end
	end
	
	return url
end

function TukuiChat:FindURL(event, msg, ...)
	local NewMsg, Found = gsub(msg, "(%a+)://(%S+)%s?", TukuiChat:PrintURL("%1://%2"))
	
	if (Found > 0) then
		return false, NewMsg, ...
	end
	
	NewMsg, Found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", TukuiChat:PrintURL("www.%1.%2"))
	
	if (Found > 0) then
		return false, NewMsg, ...
	end

	NewMsg, Found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", TukuiChat:PrintURL("%1@%2%3%4"))
	
	if (Found > 0) then
		return false, NewMsg, ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", TukuiChat.FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", TukuiChat.FindURL)

local CurrentLink = nil
local ChatFrame_OnHyperlinkShow_Original = ChatFrame_OnHyperlinkShow

ChatFrame_OnHyperlinkShow = function(self, link, ...)
	if (strsub(link, 1, 3) == "url") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		
		CurrentLink = (link):sub(5)
		
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		
		ChatFrameEditBox:Insert(CurrentLink)
		ChatFrameEditBox:HighlightText()
		CurrentLink = nil
		return
	end
	
	ChatFrame_OnHyperlinkShow_Original(self, link, ...)
end