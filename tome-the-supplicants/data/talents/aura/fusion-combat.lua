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
		Auratic Flow: Shatters the target's concentration, removing up to XX mental sustain(s) per stack.
		Essence Infusion: Shatters the target's mental capabilties, removing up to XX magical sustain(s) per stack.
		Effects are still removed if the attack misses.]]):
		format()
	end,
}

newTalent{
	-- Instant shield!
	name = "Manifest Barrier", short_name = "S_MANIFEST_BARRIER",
	type = {"aura/fusion-combat", 2},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Redirect all positive energies into your aura, hypercharging it to such levels that it forms a protective barrier around you.
		Removes all stacks of Auric Cowling, Essence Infusion, and Auratic Flow from the user to form a damage shield that lasts XX turns.
		Auric Cowling: +XX shield/stack.
		Auratic Flow: +XX shield/stack.
		Essence Infusion: +XX shield/stack.]]):
		format()
	end,
}

newTalent{
	-- Low-power strike that inflicts status effects.
	name = "Incisive Strike", short_name = "S_INCISIVE_STRIKE",
	type = {"aura/fusion-combat", 3},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[You decisively strike your foe at a critical point, dealing 50%% damage.
		You force all extraneous auric energy through this contact point, consuming Auric Cowling, Essence Infusion, and Auratic Flow (where applicable) stacks to add additional effects.
		Auric Cowling: At 1/2/3 stack(s) the target will be dazed/dazed/stunned for XX/XX/XX turns.
		Auratic Flow: The target will be confused (power 25%% + XX/stack) for XX turns.
		Essence Infusion: ]]):
		format()
	end,
}

newTalent{
	-- Attack which consumes stacks to gain big power.
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
		Consumes all stacks of Auric Cowling/Auratic Flow/Essence Infusion to increase dealt damage by +XX/XX/XX, respectively.
		If this attack kills the target then all consumed stacks are refunded.]]):
		format()
	end,
}