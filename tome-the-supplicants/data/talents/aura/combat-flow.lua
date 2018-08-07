newTalent{
	-- Each attack builds physical power, regen, and damage conversion.
	name = "Auratic Flow", short_name = "S_AURATIC_FLOW",
	type = {"aura/combat-flow", 1},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	getPower = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, 0.75)) end,
	getConversion = function(self, t) return self:combatTalentScale(t, 0.5, 1.3) end,
	getRegen = function(self, t) return 0.10 + self:combatTalentScale(t, 0.00, 0.08) end,
	callbackOnMeleeAttack = function(self, t, target, hitted, crit, weapon, damtype, mult, dam)
		if self.turn_procs.auratic_flow or not hitted then return end
		self:setEffect(self.EFF_AURATIC_FLOW, 5, {power = t.getPower(self, t), regen = t.getRegen(self, t), convert = t.getConversion(self, t), charges=1, max_charges=20})
		self.turn_procs.auratic_flow = true
	end,
	info = function(self, t)
		return ([[Your skill in infusing auric manipulation with close-quarters combat is unparalleled.
		Every time you hit with a melee attack you gain a stack of Auratic Flow (max 20 stacks).
		Only one stack can normally be gained per turn (though some abiltiies may grant additional stacks per turn).
		Stacks last 5 turns. Each stack confers +%d Physical power, %0.2f%% #08FF9E#Phantom#WHITE# damage conversion, and +%0.2f Aura regen.]]):
		format(t.getPower(self, t), t.getConversion(self, t), t.getRegen(self, t))
	end,
}

newTalent{
	-- Instant low-damage attack that builds stacks.
	name = "Sleek Strike", short_name = "S_SLEEK_STRIKE",
	type = {"aura/combat-flow", 2},
	no_energy = true,
	points = 5,
	aura = 10,
	range = 1,
	cooldown = 16,
	require = techs_str_req1,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.33, 0.55) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not target or not self:canProject(tg, x, y) then return nil end

		local hit1 = false

		-- This itself is a melee attack and thus builds Auratic Flow.
		hit1 = self:attackTarget(target, DamageType.PHANTOM, t.getDamage(self, t), true)
		
		if hit1 then
			local ab = self:getTalentFromId(self.T_S_AURATIC_FLOW)
			if self:getTalentLevel(t) >= 5 then
				target:setEffect(target.EFF_DAZED, 3, {})
				self:setEffect(self.EFF_AURATIC_FLOW, 5, {power = ab.getPower(self, ab), regen = ab.getRegen(self, ab), convert = ab.getConversion(self, ab), charges = 1, max_charges = 20})
			end
		end
		
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[Infuse your arm with auric energy to jab an enemy at breakneck speed, instantly dealing %d%% unarmed damage as #08FF9E#Phantom#WHITE# damage and granting you a stack of Auratic Flow if it hits.
		At talent level 5 the target will be dazed for 3 turns, and this talent will grant an additional stack of Auratic Flow.]]):
		format(damage)
	end,
}

newTalent{
	-- Generate a whole lotta stacks and damage provided you don't get killed from this...
	name = "Counterassault", short_name = "S_COUNTERASSAULT",
	type = {"aura/combat-flow", 3},
	aura = 10,
	points = 5,
	require = techs_str_req1,
	-- Every level increases the threshold by 3 points. Every 2 points in Willpower reduces the threshold by 1 point.
	getThreshold = function(self, t) return math.max(20, math.ceil(self:combatTalentScale(t, 50, 10) + (3 * self.level) - (self:getWil()/2))) end,	-- Minimum 20.
	action = function(self, t)
		local ab = self:getTalentFromId(self.T_S_AURATIC_FLOW)
		game:onTickEnd(function() self:setEffect(self.EFF_COUNTERASSAULT, 1, {threshold = t.getThreshold(self, t), abpwr = ab.getPower(self, ab), abgen = ab.getRegen(self, ab), abcon = ab.getConversion(self, ab)}) end)
		return true
	end,
	info = function(self, t)
		return ([[Perform a risky manuever to bait enemies into hastily attacking you. For one turn, you take double damage and your defense is set to 0!
		At the end of this turn, for every %d points of damage you took, you gain a stack of Auratic Flow and a stack of Counterassault.
		Counterassault stacks up to 5 times, with each stack providing +20%% to all damage dealt. Stacks disappear after 5 turns.
		The damage threshold for Counterassault increases as you level up (making it harder to generate stacks), but decreases with Willpower.]]):
		format(t.getThreshold(self, t))
	end,
}

newTalent{
	-- While active all pugilism talents get a power boost.
	-- Boost is minor, but since most pugilism attacks are multihit having too much would be OP.
	name = "Fusion Combat", short_name = "S_FUSION_COMBAT",
	type = {"aura/combat-flow", 4},
	mode = "sustained",
	sustain_aura = 15,
	points = 5,
	require = techs_str_req1,
	getMult = function(self, t) return self:combatStatScale("wil", 4, 16) end,	-- +16% damage to striking talents at 100 Willpower.
	getPercentDaze = function(self, t) return math.floor(self:combatTalentScale(t, 20, 65)) end,
	getReduce = function(self, t) return math.floor(self:combatTalentLimit(t, 6, 1, 5)) end,
	activate = function(self, t)
		return true
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Adopt a fluid stance which emphasizes the flowing motions of hand-to-hand combat.
		While active, the damage multiplier of all Auric Pugilism talents is increased by %d%%.
		Additionally, Phantom Jab has a %d%% chance to daze the target for 3 turns if both attacks hit, and Phantom Leap and Phantom Assault's cooldowns are reduced by %d.
		The damage multiplier increases with Willpower.]]):
		format(t.getMult(self, t), t.getPercentDaze(self, t), t.getReduce(self, t))
	end,
} 