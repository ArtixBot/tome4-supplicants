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
	-- Pure Phantom damage. Not much else.
	name = "Cruel Dynasty", short_name = "S_CRUEL_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Those in Auratic Form gain skills powered by sources beyond galactic comprehension. When a symbol of The One acts, things change, no matter how much some may try to resist.
		This talent performs a malevolent gesture against an adjacent target, dealing XX #08FF9E#Phantom#WHITE# damage.]]):
		format()
	end,
}

newTalent{
	-- Negate the next incoming attack and teleport to a random location.
	-- Short cooldown.
	name = "Conniving Dynasty", short_name = "S_CONNIVING_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with protective motive to guard your frail form for XX turns.
		The next incoming attack that would hit is instead negated, removing this effect and teleporting you to a random location within XX tiles.]]):
		format()
	end,
}

newTalent{
	-- Pins, silences, and disarms a target, bypassing resistances.
	-- Pretty decent cooldown.
	name = "Malefic Dynasty", short_name = "S_MALEFIC_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with malefic motive, subjecting the target to mental assault.
		The target is pinned to the ground, disarmed, and silenced for XX turns, bypassing saves, resistances, and immunities.]]):
		format()
	end,
}

newTalent{
	-- Boosts Defense and grants a chance to ignore critical hits.
	name = "Precognitive Dynasty", short_name = "S_PRECOGNITIVE_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with predictive motive, allowing you to more easily dodge incoming attacks.
		Defense is increased by +XX and gain a XX chance to ignore incoming critical hits for XX turns.]]):
		format()
	end,
}

newTalent{
	-- Instant teleport or swap teleport, bypassing immunities!
	-- Pretty long cooldown.
	name = "Swap Dynasty", short_name = "S_SWAP_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with erratic motive, manipulating reality to transpose locations.
		Instantly teleport to a directed point in range XX. If a unit is on the targeted tile you swap locations, ignoring immunities on the target.]]):
		format()
	end,
}

newTalent{
	-- Heavy Phantom damage + strong bleed.
	-- Long cooldown.
	name = "Ruptured Dynasty", short_name = "S_RUPTURED_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with torturous motive, imploding all of a target's internal organs.
		Target in range XX takes XX #08FF9E#Phantom#WHITE# damage and bleeds for XX damage over XX turns.]]):
		format()
	end,
}

newTalent{
	-- Phantom damage based on missing health on target.
	-- Very long cooldown.
	name = "Obliterate Dynasty", short_name = "S_OBLITERATE_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with absolving motive, assaulting an adjacent enemy with auratic forces.
		Deal XX #08FF9E#Phantom#WHITE# damage for every XX of health the target is missing (divided based on target rank).
		Killing the target refunds this talents' aura cost.]]):
		format()
	end,
}

newTalent{
	-- AoE Phantom nova around self.
	-- Very long cooldown.
	name = "Penultimate Dynasty", short_name = "S_PENULTIMATE_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with pure motive, emitting a wave of volatile auratic force in radius XX around yourself.
		All units in the area of effect take XX #08FF9E#Phantom#WHITE# damage.]]):
		format()
	end,
}

newTalent{
	-- AoE Phantom nova around self.
	name = "Alter Dynasty", short_name = "S_ALTER_DYNASTY",
	type = {"aura/dynasty", 1},
	info = function(self, t)
		return ([[Act with pure motive, emitting a wave of volatile auratic force in radius XX around yourself.
		All units in the area of effect take XX #08FF9E#Phantom#WHITE# damage.]]):
		format()
	end,
}