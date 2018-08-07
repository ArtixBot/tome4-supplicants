-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newTalent{
	name = "Aura Pool",
	type = {"base/class", 1},
	mode = "passive",
	hide = "always",
	no_unlearn_last = true,
	info = function(self, t) return "The One has enlightened you, allowing you to view auras of sentient beings... and manipulate them." end,
}

newTalentType{ allow_random=true, type="aura/auric-self", name = "auric body", description = "Master manipulation of the aura around yourself." }
newTalentType{ is_unarmed=true, allow_random=true, type="aura/auric-pugilism", name = "auric pugilism", description = "Aura-infused unarmed techniques." }
newTalentType{ is_unarmed=true, allow_random=true, type="aura/combat-flow", name = "combat flow", description = "Build up deadly force as combat continues." }
newTalentType{ is_unarmed=true, allow_random=true, type="aura/fusion-combat", name = "fusion combat", description = "Convert all details of auratic combat into seismic finishers." }
newTalentType{ allow_random=true, type="aura/aurasurge", name = "aurasurge", description = "Your aura constantly distorts the area around you, and even manifests itself in the eyes of non-followers." }
newTalentType{ allow_random=true, type="aura/essence-control", name = "essence control", description = "Dedicated followers of The One are capable of shaping the auras of sentient beings around them."}
newTalentType{ allow_random=true, type="aura/dynasty", name = "dynasty", description = "When heralds of The One act, things change." }
newTalentType{ allow_random=true, generic=true, type="aura/resilience", name = "resilience", description = "Crippling effects only push you towards greater achievement!" }
newTalentType{ allow_random=true, generic=true, type="aura/one-commandants", name = "commandants", description = "Sacrifice for The One!" }

-- Generic requires for spells based on talent level
dementedreq1 = {
	stat = { mag=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
dementedreq2 = {
	stat = { mag=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
dementedreq3 = {
	stat = { mag=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
dementedreq4 = {
	stat = { mag=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
dementedreq5 = {
	stat = { mag=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}
dementedreq_high1 = {
	stat = { mag=function(level) return 22 + (level-1) * 2 end },
	level = function(level) return 10 + (level-1)  end,
}
dementedreq_high2 = {
	stat = { mag=function(level) return 30 + (level-1) * 2 end },
	level = function(level) return 14 + (level-1)  end,
}
dementedreq_high3 = {
	stat = { mag=function(level) return 38 + (level-1) * 2 end },
	level = function(level) return 18 + (level-1)  end,
}
dementedreq_high4 = {
	stat = { mag=function(level) return 46 + (level-1) * 2 end },
	level = function(level) return 22 + (level-1)  end,
}
dementedreq_high5 = {
	stat = { mag=function(level) return 54 + (level-1) * 2 end },
	level = function(level) return 26 + (level-1)  end,
}
-- Load alternate attack mechanism.
load("/data-supplicants/talents/aura/alter-attack.lua")

load("/data-supplicants/talents/aura/auric-self.lua")
load("/data-supplicants/talents/aura/auric-pugilism.lua")
load("/data-supplicants/talents/aura/combat-flow.lua")
load("/data-supplicants/talents/aura/essence-control.lua")
load("/data-supplicants/talents/aura/fusion-combat.lua")
load("/data-supplicants/talents/aura/aurasurge.lua")
load("/data-supplicants/talents/aura/dynasty.lua")

load("/data-supplicants/talents/aura/resilience.lua")
load("/data-supplicants/talents/aura/one-commandants.lua")