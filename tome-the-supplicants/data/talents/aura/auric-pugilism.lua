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

local function getFusionCombat(self, dam)
	local dam = 0
	if self:isTalentActive(self.T_S_FUSION_COMBAT) then
		local t = self:getTalentFromId(self.T_S_FUSION_COMBAT)
		dam = t.getMult(self, t)
	end
	return dam / 100
end

local function getFusionCombatReduction(self, red)
	local red = 0
	if self:isTalentActive(self.T_S_FUSION_COMBAT) then
		local t = self:getTalentFromId(self.T_S_FUSION_COMBAT)
		red = t.getReduce(self, t)
	end
	return red
end

newTalent{
	-- Punch harder.
	name = "Harmonized Pugilism", short_name = "S_HARMONIZED_PUGILISM",
	type = {"aura/auric-pugilism", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Unarmed attacks now scale based off of 60%% Dex/Wil, instead of Strength, Dexterity, and Cunning.
		Increases Physical Power by XX, and increases all unarmed damage by XX.
		Note that brawlers naturally gain 0.5 Physical Power per character level while unarmed (current brawler physical power bonus: %0.1f) and attack 20%% faster while unarmed.]]):
		format(self.level * 0.5)
	end,
}

newTalent{
	-- Double Strike equivalent for Phantasms.
	name = "Phantom Jab", short_name = "S_PHANTOM_JAB",
	type = {"aura/auric-pugilism", 2},
	require = techs_dex_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 4,
	tactical = { ATTACK = { weapon = 2 } },
	requires_target = true,
	is_melee = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	range = 1,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 0.8) + getFusionCombat(self, dam) end,
	getPDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.25, 0.4) + getFusionCombat(self, dam) end,
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
	-- Phantasm version of brawler leap finisher.
	name = "Phantom Leap", short_name = "S_PHANTOM_LEAP",
	type = {"aura/auric-pugilism", 3},
	aura = 15,
	cooldown = function(self, t) return 15 - getFusionCombatReduction(self, red) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	radius = 1,
	points = 5,
	tactical = { ATTACKAREA = { weapon = 2 }, CLOSEIN = 1 },
	require = techs_str_req1,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.65, 1.15) + getFusionCombat(self, dam) end,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), nolock = true}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		if game.level.map(x, y, Map.ACTOR) then
			x, y = util.findFreeGrid(x, y, 1, true, {[Map.ACTOR]=true})
			if not x then return end
		end

		if game.level.map:checkAllEntities(x, y, "block_move") then return end

		local ox, oy = self.x, self.y
		self:move(x, y, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				local hit = self:attackTarget(target, DamageType.PHANTOM, t.getDamage(self, t), true)
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "butterfly_kick", {radius=tg.radius})
		return true
	end,
	info = function(self, t)
		return ([[Focus your aura towards your legs before forcing it into the ground, flinging you into the air.
		This allows you to land towards a targeted area (if occupied, randomly adjacent to that tile).
		Landing causes a seismic impact that causes your aura to lash out against all adjacent units, dealing %d%% #08FF9E#Phantom#WHITE# damage.]]):
		format(t.getDamage(self, t) * 100)
	end,
}

newTalent{
	-- Beat the crap out of someone (or thing).
	name = "Phantom Assault", short_name = "S_PHANTOM_ASSAULT",
	type = {"aura/auric-pugilism", 4},
	aura = 35,
	cooldown = function(self, t) return 24 - getFusionCombatReduction(self, red) end,
	range = 1,
	points = 5,
	require = techs_str_req1,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.15, 0.31) + (getFusionCombat(self, dam) / 4) end,
	getPDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.06, 0.12) + (getFusionCombat(self, dam) / 4) end,
	getUDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.12, 1.33) + (getFusionCombat(self, dam) / 4) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local attacks_hit = 0
		for i=0,5,1 do
			hit = self:attackTarget(target, nil, t.getDamage(self, t), true)
			if hit then
				attacks_hit = attacks_hit + 1
				self:attackTarget(target, DamageType.PHANTOM, t.getPDamage(self, t), true)
			end
		end

		if attacks_hit == 6 then
			uppercut = self:attackTarget(target, DamageType.PHANTOM, t.getUDamage(self, t), true)
			if uppercut then
				target:setEffect(target.EFF_STUNNED, 4, {})
			end
		end

		return true
	end,
	info = function(self, t)
		local plus = getFusionCombat(self, dam)
		local plusDam = getFusionCombat(self, dam) / 4
		return ([[Assault an enemy, striking #{italic}#six#{normal}# times. Each strike deals %d%% damage.
		Each blow that hits is instanteously followed up by an aura-formulated jab, dealing %d%% #08FF9E#Phantom#WHITE# damage.
		If all six attacks hit, you focus the remnants of your aura into your arm, performing an uppercut that deals %d%% #08FF9E#Phantom#WHITE# damage and stuns the target for 4 turns on hit.
		
		Fusion Combat's damage multiplier is only 25%% effective for this skill (only %d%%; normally %d%%).]]):
		format(t.getDamage(self, t) * 100, t.getPDamage(self, t) * 100, t.getUDamage(self, t) * 100, plusDam * 100, plus * 100)
	end,
}