-- ToME - Tales of Maj'Eyal:
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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

newEffect{
	name = "AURASURGE", image = "talents/s_aurasurge.png",
	desc = "Aurasurge",
	long_desc = function(self, eff) return ("Aura has spontaneously intensified, perplexing attackers; +%d Defense, +%d%% chance to evade melee and ranged attacks."):format(eff.defense, eff.chance) end,
	type = "physical",
	subtype = { evade=true	},
	parameters = { chance=10, defense=0 },
	on_gain = function(self, err) return "", "+Aurasurge" end,
	on_lose = function(self, err) return "", "-Aurasurge" end,
	status = "beneficial",
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("evasion", eff.chance)
		eff.pid = self:addTemporaryValue("projectile_evasion", eff.chance)
		eff.defid = self:addTemporaryValue("combat_def", eff.defense)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("evasion", eff.tmpid)
		self:removeTemporaryValue("projectile_evasion", eff.pid)
		self:removeTemporaryValue("combat_def", eff.defid)
	end,
}

newEffect{
	name = "AURASURGE_FIST", image = "talents/s_energy_surged_fists.png",
	desc = "Energized Fists",
	long_desc = function(self, eff) return ("Aurasurge in effect, increasing attack speed by %d%% and adding %d #08FF9E#Phantom#WHITE# damage to all attacks."):format(eff.speed * 100, eff.power) end,
	type = "physical",
	subtype = { evade=true },
	parameters = { speed=0.35, power=1 },
	status = "beneficial",
	activate = function(self, eff)
		eff.spd = self:addTemporaryValue("combat_physspeed", eff.speed)
		eff.dmg = self:addTemporaryValue("melee_project", {[DamageType.PHANTOM] = eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physspeed", eff.spd)
		self:removeTemporaryValue("melee_project", eff.dmg)
	end,
}

newEffect{
	name = "AURIC_COWLING", image = "talents/s_auric_cowling.png",
	desc = "Auric Cowling",
	long_desc = function(self, eff) return ("Aura is imbued within the user's body, increasing all stats by +%d."):format(eff.power * eff.charges) end,
	display_desc = function(self, eff) return "Auric Cowling ("..eff.charges..")" end,
	type = "physical",
	charges = function(self, eff) return eff.charges end,
	subtype = { tactic=true },
	parameters = { power = 1, charges =1, max_charges=3 },
	status = "beneficial",
	on_merge = function(self, old_eff, new_eff)
		-- remove the old value
		self:removeTemporaryValue("inc_stats", old_eff.tmpid)
		
		-- add a charge
		old_eff.charges = math.min(old_eff.charges + 1, new_eff.max_charges)
		
		-- and apply the current values	
		old_eff.tmpid = self:addTemporaryValue("inc_stats",
		{
			[Stats.STAT_STR] = old_eff.power * old_eff.charges,
			[Stats.STAT_DEX] = old_eff.power * old_eff.charges,
			[Stats.STAT_MAG] = old_eff.power * old_eff.charges,
			[Stats.STAT_WIL] = old_eff.power * old_eff.charges,
			[Stats.STAT_CUN] = old_eff.power * old_eff.charges,
			[Stats.STAT_CON] = old_eff.power * old_eff.charges,
		})
		
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats",
		{
			[Stats.STAT_STR] = eff.power * eff.charges,
			[Stats.STAT_DEX] = eff.power * eff.charges,
			[Stats.STAT_MAG] = eff.power * eff.charges,
			[Stats.STAT_WIL] = eff.power * eff.charges,
			[Stats.STAT_CUN] = eff.power * eff.charges,
			[Stats.STAT_CON] = eff.power * eff.charges,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "AURATIC_FLOW", image = "talents/s_auratic_flow.png",
	desc = "Auratic Flow",
	long_desc = function(self, eff) return ("The flow of combat strengthens you, granting +%d Physical power, %0.2f%% conversion to #08FF9E#Phantom#WHITE# damage, and +%0.2f Aura regen."):format(eff.power * eff.charges, eff.convert * eff.charges, eff.regen * eff.charges) end,
	display_desc = function(self, eff) return "Combat Flow ("..eff.charges..")" end,
	type = "physical",
	charges = function(self, eff) return eff.charges end,
	subtype = { tactic=true },
	parameters = { power = 1, regen = 1, convert = 1, charges =1, max_charges=5 },
	status = "beneficial",
	on_merge = function(self, old_eff, new_eff)
		--remove the old value
		self:removeTemporaryValue("combat_dam", old_eff.phys)
		self:removeTemporaryValue("aura_regen", old_eff.reg)
		--self:removeTemporaryValue("all_damage_convert", old_eff.conv)
		self:removeTemporaryValue("all_damage_convert_percent", old_eff.convp)
		
		-- add a charge
		old_eff.charges = math.min(old_eff.charges + 1, new_eff.max_charges)
		
		-- apply the current values	
		old_eff.phys = self:addTemporaryValue("combat_dam", old_eff.power * old_eff.charges)
		old_eff.reg = self:addTemporaryValue("aura_regen", old_eff.regen * old_eff.charges)
		--old_eff.conv = self:addTemporaryValue("all_damage_convert", DamageType.PHANTOM)
		old_eff.convp = self:addTemporaryValue("all_damage_convert_percent", old_eff.convert * old_eff.charges)
		-- return old_eff
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "all_damage_convert", DamageType.PHANTOM)
		eff.phys = self:addTemporaryValue("combat_dam", eff.power * eff.charges)
		eff.reg = self:addTemporaryValue("aura_regen", eff.regen * eff.charges)
		eff.convp = self:addTemporaryValue("all_damage_convert_percent", eff.convert * eff.charges)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.phys)
		self:removeTemporaryValue("aura_regen", eff.reg)
		self:removeTemporaryValue("all_damage_convert_percent", eff.convp)
	end,
}

newEffect{
	name = "COUNTERASSAULT", image = "talents/s_counterassault.png",
	desc = "Lowered Defenses",
	long_desc = function(self, eff) return ("Defenses temporarily negated to lure in unwitting foes!"):format() end,
	type = "other",
	subtype = { evade=true },
	parameters = { threshold = 1, damage_taken = 0, stacks = 0, abpwr = 0, abgen = 0, abcon = 0 },	-- Don't divide by 0.
	status = "detrimental",
	activate = function(self, eff)
		eff.def = self:addTemporaryValue("combat_def", -999)	-- If any character has more than 999 raw defense, well, good jorb
		eff.resists = self:addTemporaryValue("resists", {all = -100})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.def)
		self:removeTemporaryValue("resists", eff.resists)
		
		eff.stacks = eff.stacks + math.floor(eff.damage_taken / eff.threshold)
		if eff.stacks >= 1 then
			for i=1,eff.stacks,1 do
				self:setEffect(self.EFF_AURATIC_FLOW, 5, {power = eff.abpwr, regen = eff.abgen, convert = eff.abcon, charges=1, max_charges=20})
			end
			for i=1,math.min(eff.stacks, 5),1 do
				self:setEffect(self.EFF_COUNTERASSAULT_PRO, 5, {})
			end
			game.logSeen(self, "#08FF9E#%s converts "..math.floor(eff.damage_taken).." points of damage into "..math.min(eff.stacks, 20).." stack(s) of Auratic Flow and "..math.min(eff.stacks, 5).." stack(s) of Counterassault!", self.name:capitalize())
		end
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		eff.damage_taken = eff.damage_taken + dam
	end,
}

newEffect{
	name = "COUNTERASSAULT_PRO", image = "talents/s_counterassault.png",
	desc = "Counterassault",
	long_desc = function(self, eff) return ("Executing counterattack! +20%% to all damage dealt per stack (currently %d stack(s), +%d%% damage)."):format(eff.charges, eff.power * eff.charges) end,
	display_desc = function(self, eff) return "Counterassault ("..eff.charges..")" end,
	type = "physical",
	subtype = { tactic=true },
	charges = function(self, eff) return eff.charges end,
	parameters = { power = 20, charges =1, max_charges=5 },
	status = "beneficial",
	on_merge = function(self, old_eff, new_eff)
		--remove the old value
		self:removeTemporaryValue("inc_damage", old_eff.dam)
		
		-- add a charge
		old_eff.charges = math.min(old_eff.charges + 1, new_eff.max_charges)
		
		-- apply the current values	
		old_eff.dam = self:addTemporaryValue("inc_damage", {all = old_eff.power * old_eff.charges})
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.dam = self:addTemporaryValue("inc_damage", {all = eff.power * eff.charges})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.dam)
	end,
}