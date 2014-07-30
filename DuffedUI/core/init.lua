----------------------------------------------------------------
-- Initiation of DuffedUI engine
----------------------------------------------------------------

-- [[ Build the engine ]] --
local addon, engine = ...
engine[1] = {}
engine[2] = {}
engine[3] = {}

function engine:unpack()
	return self[1], self[2], self[3]
end

engine[1].Resolution = GetCVar("gxResolution")
engine[1].ScreenHeight = tonumber(string.match(engine[1].Resolution, "%d+x(%d+)"))
engine[1].ScreenWidth = tonumber(string.match(engine[1].Resolution, "(%d+)x+%d"))
engine[1].MyClass = select(2, UnitClass("player"))
engine[1].MyLevel = UnitLevel("player")
engine[1].MyName = select(1, UnitName("player"))
engine[1].Version = GetAddOnMetadata("DuffedUI", "Version")
engine[1].VersionNumber = tonumber(engine[1].Version)
engine[1].Dummy = function() return end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

DuffedUI = engine