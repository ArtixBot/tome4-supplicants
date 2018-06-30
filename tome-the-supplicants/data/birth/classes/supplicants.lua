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

local Particles = require "engine.Particles"

-- Add Supplicants to all campaigns that can do Defilers
for i, bdata in ipairs(Birther.birth_descriptor_def.world) do
	if bdata.descriptor_choices and bdata.descriptor_choices.class and bdata.descriptor_choices.class.Defiler == "allow" then
		bdata.descriptor_choices.class.Supplicants = "allow"
	end
end

newBirthDescriptor{
	type = "class",
	name = "Supplicants",
	desc = {
		"The One demands fealty to only one tenement: purge Maj'Eyal of chaos and restore the continent to a state of harmonic balance.",
		"We will carry out The One's will!"
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			['Phantasm'] = "allow",
		},
	},
	copy = {
		aura_regen = 0.5,
		aura_rating = 5,
	},
}
newBirthDescriptor{
	type = "subclass",
	name = "Phantasm",
	desc = {
		"Phantasms have trained their aura-manipulating abilities granted to them by #{bold}#The One#{normal}# to absolute perfection.",
		"Their tethers to the mortal realm are so strong that death simply presents an opportunity to strike back.",
		"In combat, Phantasms utilize aura to execute instantaneous phantom strikes, disorient foes, and augment movement.",
		"Such power does not come without sacrifice, of course; Phantasms can only effectively fight in the lightest of armor, and go unarmed.",
		"Their most important stats are: Dexterity and Willpower.",
		"#GOLD#Stat modifiers:",
		"#LIGHT_BLUE# * +0 Strength, +4 Dexterity, +0 Constitution",
		"#LIGHT_BLUE# * +0 Magic, +5 Willpower, +0 Cunning",
		"#GOLD#Life per level:#LIGHT_BLUE# -1",
	},
	stats = { dex=4, wil=5 },
	talents_types = {
		-- Class skills.
		["aura/auric-self"]={true, 0.3},
		["aura/auric-pugilism"]={true, 0.3},
		["aura/combat-flow"]={true, 0.3},
		["aura/aurasurge"]={true, 0.3},
		["aura/fusion-combat"]={true, 0.3},
		
		-- Generic skills.
		["technique/combat-training"]={true, 0.3},
		["aura/resilience"]={true, 0.3},
		["aura/one-commandants"] = {true, 0.3},
	},
	talents = {
		[ActorTalents.T_AURA_POOL] = 1,
		[ActorTalents.T_S_HARMONIZED_PUGILISM] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		resolvers.equip{ id=true,
			{type="armor", subtype="hands", name="iron gauntlets", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000, ego_chance=-1000},			
		},
	},
	copy_add = {
		life_rating = -1,
	},
}
