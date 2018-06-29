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
	-- Not dead yet!
	name = "Harmonized Pugilism", short_name = "S_HARMONIZED_PUGILISM",
	type = {"aura/auric-pugilism", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Unarmed attacks now scale based off of Dexterity and Willpower, instead of Strength, Dexterity, and Cunning.
		Increases Physical Power by XX, and increases all unarmed damage by XX.
		Note that brawlers naturally gain 0.5 Physical Power per character level while unarmed (current brawler physical power bonus: %0.1f) and attack 20%% faster while unarmed.]]):
		format(self.level * 0.5)
	end,
}

newTalent{
	name = "Phantom Jab", short_name = "S_PHANTOM_JAB",
	type = {"aura/auric-pugilism", 2},
	require = techs_dex_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 3,
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	aura = 5,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 0.8) end,
	getPDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.25, 0.4) end,
	can_alternate_attack = function(self, t)
		return not self:isTalentCoolingDown(t)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end
		
		hit1 = self:attackTarget(target, nil, t.getDamage(self, t), true)
		hit2 = self:attackTarget(target, DamageType.PHANTOM, t.getPDamage(self, t), true)
		
		if self:isTalentActive(self.T_S_FUSION_COMBAT) and hit1 and hit2 then
			local af = self:getTalentFromId(self.T_S_FUSION_COMBAT)
			local ab = self:getTalentFromId(self.T_S_AURATIC_FLOW)
			self:setEffect(self.EFF_AURATIC_FLOW, 5, {power = ab.getPower(self, ab), regen = ab.getRegen(self, ab), convert = ab.getConversion(self, ab), charges = 1, max_charges = 20})
			if rng.percent(af.getPercentDaze(self, t)) then
				target:setEffect(target.EFF_DAZED, 3, {})
			end
		end
		
		return true
	end,
	info = function(self, t)
		return ([[Strike at an enemy with a swift punch, dealing %d%% damage, and focus your aura to deliver a secondary spectral jab dealing %d%% #08FF9E#Phantom#WHITE# damage.
		#08FF9E#Phantom#WHITE# damage ignores all resistances.
		This talent will automatically replace your normal attacks (when off cooldown).]]):
		format(t.getDamage(self, t) * 100, t.getPDamage(self, t) * 100)
	end,
}

newTalent{
	name = "Phantom Leap", short_name = "S_PHANTOM_LEAP",
	type = {"aura/auric-pugilism", 3},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Focus your aura towards your legs before forcing it into the ground, flinging you into the air.
		This allows you to land towards an unoccupied tile within XX tiles of you.
		Landing causes a seismic impact that forces your aura to lash out against all adjacent units, dealing XX #08FF9E#Phantom#WHITE# damage.]]):
		format()
	end,
}

newTalent{
	name = "Phantom Assault", short_name = "S_PHANTOM_ASSAULT",
	type = {"aura/auric-pugilism", 4},
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
		return ([[Assault an enemy, striking #{italic}#six#{normal}# times. Each strike deals %d%% damage.
		Each blow that hits is instanteously followed up by an aura-formulated jab which cannot miss, dealing %d%% #08FF9E#Phantom#WHITE# damage.
		
		If all six attacks hit, you focus the remnants of your aura into your arm, performing an uppercut that deals XX #08FF9E#Phantom#WHITE# damage and stuns the target for XX turns.]]):
		format(t.getDamage(self, t) * 100, t.getPDamage(self, t) * 100)
	end,
}