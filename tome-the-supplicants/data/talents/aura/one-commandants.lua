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
	name = "Sacrifice Constitution", short_name = "S_SACRIFICE_CONSTITUTION",
	type = {"aura/one-commandants", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
        return ([[Offer your body's resilience to The One.
		#RED#Sacrifice:#WHITE# Life rating reduced by 4. This is retroactive!
		#GOLD#Reward:#WHITE# +1 Favor point.]]):
		format()
	end,
}

newTalent{
	name = "Sacrifice Mastery", short_name = "S_SACRIFICE_MASTERY",
	type = {"aura/one-commandants", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
        return ([[Offer your mastery of talents to The One.
		#RED#Sacrifice:#WHITE# Mastery rating of Auric Self, Auric Pugilism, and Combat Techniques trees reduced by 0.3.
		#GOLD#Reward:#WHITE# +1 Favor point.]]):
		format()
	end,
}

newTalent{
	name = "Sacrifice Rationality", short_name = "S_SACRIFICE_RATIONALITY",
	type = {"aura/one-commandants", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
        return ([[Offer your mental stability to The One.
		#RED#Sacrifice:#WHITE# There is a 4%% chance each turn to be inflicted with a random negative status effect: Dazed, Stunned, Confusion (25%% power), or Pinned for 3 turns.
		Effects inflicted via this method bypass save checks and immunities.
		This negative effect can be applied at worst once every 10 turns.
		#GOLD#Reward:#WHITE# +1 Favor point.]]):
		format()
	end,
}

newTalent{
	name = "Sacrifice Lower Body", short_name = "S_SACRIFICE_LOWER_BODY",
	type = {"aura/one-commandants", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Offer your lower body to The One.
		#RED#Sacrifice:#WHITE# Permanently lose access to your boots slot, and -15%% movement speed.
		#GOLD#Reward:#WHITE# +1 Favor point.]]):
		format()
	end,
}

newTalent{
	name = "Sacrifice Knowledge", short_name = "S_SACRIFICE_KNOWLEDGE",
	type = {"aura/one-commandants", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Offer your current burdens of knowledge to The One.
		#RED#Sacrifice:#WHITE# You completely forget all points invested in 3 talents (chosen randomly).
		You can still invest points into the talent (you just lose all points invested in them).
		#GOLD#Reward:#WHITE# +1 Favor point.]]):
		format()
	end,
}