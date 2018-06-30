-- ToME - Tales of Maj'Eyal:
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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
	-- Sustain destruction!
	name = "Siphonic Impact", short_name = "S_SIPHONIC_IMPACT",
	type = {"aura/fusion-combat", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Redirect all positive energies into your fist before striking an adjacent foe, dealing XX damage.
		If you have the following positive effects they are removed to empower the strike, adding additional effects to the attack:
		Auric Cowling: Shatters the target's internal organs, removing up to XX physical sustain(s) per stack.
		Aurasurge: Shatters the target's arcane faculties, removing up to XX magical sustain(s).
		Auratic Flow: Shatters the target's concentration, removing up to XX mental sustain(s) per stack.
		Effects are still removed if the attack misses.]]):
		format()
	end,
}

newTalent{
	-- 
	name = "Manifest Barrier", short_name = "S_MANIFEST_BARRIER",
	type = {"aura/fusion-combat", 2},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Redirect all positive energies into your aura, hypercharging it to such levels that it forms a protective barrier around you.
		Removes all stacks of Auric Cowling, Aurasurge, and Auratic Flow from the user to form a damage shield that lasts XX turns.
		Auric Cowling: +XX shield/stack.
		Aurasurge: +XX shield.
		Auratic Flow: +XX shield/stack.]]):
		format()
	end,
}

newTalent{
	name = "Incisive Strike", short_name = "S_INCISIVE_STRIKE",
	type = {"aura/fusion-combat", 3},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Perform a strike against a target's pressure points, crippling it so much that you manage to overwhelm the target's aura with yours to energize it.
		Deals XX damage to the target.
		If you have points invested in the Auric Cowling/Auratic Flow/Aurasurge talents you gain XX stacks of Auric Cowling/Auratic Flow/the Aurasurge effect.]]):
		format()
	end,
}

newTalent{
	name = "Redline", short_name = "S_REDLINE",
	type = {"aura/fusion-combat", 4},
	mode = "sustained",
	sustain_aura = 100,
	points = 5,
	require = techs_str_req1,
	getDamage = function(self, t) return self:combatTalentScale(t, 0.22, 0.31) end,
	getPDamage = function(self, t) return self:combatTalentScale(t, 0.08, 0.12) end,
	activate = function(self, t)
		return true
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Execute a foe with killing intent, dealing XX damage.
		Consumes all stacks of Auric Cowling/Auratic Flow/Aurasurge to increase dealt damage by +XX/XX/XX, respectively.
		If this attack kills the target then all consumed stacks are refunded.]]):
		format()
	end,
}