local T, C, L = select(2, ...):unpack()

local Framework = select(2, ...)
local oUF = oUF or Framework.oUF

oUF.colors.tapped = {
	0.55, 0.57, 0.61
}

oUF.colors.disconnected = {
	0.84, 0.75, 0.65
}

oUF.colors.power = {
	["MANA"] = {0.31, 0.45, 0.63},
	["RAGE"] = {0.69, 0.31, 0.31},
	["FOCUS"] = {0.71, 0.43, 0.27},
	["ENERGY"] = {0.65, 0.63, 0.35},
	["RUNES"] = {0.55, 0.57, 0.61},
	["RUNIC_POWER"] = {0, 0.82, 1},
	["AMMOSLOT"] = {0.8, 0.6, 0},
	["FUEL"] = {0, 0.55, 0.5},
	["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
	["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
}

oUF.colors.runes = {
	[1] = {0.69, 0.31, 0.31}, -- blood
	[2] = {0.33, 0.59, 0.33}, -- unholy
	[3] = {0.31, 0.45, 0.63}, -- frost
	[4] = {0.84, 0.75, 0.65}, -- death
}

oUF.colors.totems = {
	[1] = {0.58, 0.23, 0.10}, -- fire
	[2] = {0.23, 0.45, 0.13}, -- earth
	[3] = {0.19, 0.48, 0.60}, -- water
	[4] = {0.42, 0.18, 0.74}, -- air
}

oUF.colors.reaction = {
	[1] = { 222/255, 95/255,  95/255 }, -- Hated
	[2] = { 222/255, 95/255,  95/255 }, -- Hostile
	[3] = { 222/255, 95/255,  95/255 }, -- Unfriendly
	[4] = { 218/255, 197/255, 92/255 }, -- Neutral
	[5] = { 75/255,  175/255, 76/255 }, -- Friendly
	[6] = { 75/255,  175/255, 76/255 }, -- Honored
	[7] = { 75/255,  175/255, 76/255 }, -- Revered
	[8] = { 75/255,  175/255, 76/255 }, -- Exalted	
}

oUF.colors.class = {
	["DEATHKNIGHT"] = { 196/255,  30/255,  60/255 },
	["DRUID"]       = { 255/255, 125/255,  10/255 },
	["HUNTER"]      = { 171/255, 214/255, 116/255 },
	["MAGE"]        = { 104/255, 205/255, 255/255 },
	["PALADIN"]     = { 245/255, 140/255, 186/255 },
	["PRIEST"]      = { 212/255, 212/255, 212/255 },
	["ROGUE"]       = { 255/255, 243/255,  82/255 },
	["SHAMAN"]      = {  41/255,  79/255, 155/255 },
	["WARLOCK"]     = { 148/255, 130/255, 201/255 },
	["WARRIOR"]     = { 199/255, 156/255, 110/255 },
	["MONK"]        = { 0/255, 255/255, 150/255   },
}

T["Colors"] = oUF.colors