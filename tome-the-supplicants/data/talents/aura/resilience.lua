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
	-- Debuffs aren't all bad now!
	name = "Shatter Limitations", short_name = "S_SHATTER_LIMITATIONS",
	type = {"aura/resilience", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Many who face adversity end up dead, paranoid, or insane. For you, however, limitations are only a barrier to be broken. You fight through all pain, no matter how terrible.
		Activate this talent to begin regenerating life over 5 turns, with regenerative power based on the number of negative effects on you (XX HP/effect, currently: XX).
		Passively, for every negative effect on you, gain +XX resist all and +XX to all powers.]]):
		format()
	end,
}

newTalent{
	-- Instantly add negative effects to the user (thus giving a way for the player to proc Shatter Limitations).
	name = "Self-Imposed Challenge", short_name = "S_SELF_IMPOSED_CHALLENGE",
	type = {"aura/resilience", 2},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	getPhantom = function(self, t) return self:combatTalentScale(t, 8, 30) end,
	info = function(self, t)
		return ([[Merely waiting for adversity is not enough; indeed, self-imposed challenges can provide the motivated with a new goal.
		Instantly apply XX "negative effects" to the user for XX turns. These negative effects cannot be resisted, but have no actual impact on the user.]]):
		format()
	end,
}

newTalent{
	name = "Vigorous", short_name = "S_VIGOROUS",
	type = {"aura/resilience", 3},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Your body's vigour has positive implications for your survivability.
		Increases mental and physical saves by XXm health regen by XX, and healing mod by XX.]]):
		format()
	end,
}

newTalent{
	name = "Turn The Tide", short_name = "S_TURN_THE_TIDE",
	type = {"aura/resilience", 4},
	mode = "sustained",
	sustain_aura = 100,
	points = 5,
	require = techs_str_req1,
	activate = function(self, t)
		return true
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[The greatest feats come from those under the most duress.
		While this talent is in effect, uou cannot be reduced below 1 HP and gain +40%% to all damage dealt.
		The duration of this talent is dependent on the number of negative effects on you at activation time: each negative effect increases this talent's duration by XX, rounded down.]]):
		format()
	end,
} 