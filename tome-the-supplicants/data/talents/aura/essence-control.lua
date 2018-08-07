newTalent{
	-- Adjacent foe loses stats while you gain power and saves.
	name = "Seize Essence", short_name = "S_SEIZE_ESSENCE",
	type = {"aura/essence-control", 1},
	mode = "passive",
	points = 5,
	aura_cost = -20,
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
		return ([[You touch an adjacent enemy, establishing a contact point from which you rip the target's aura from its physical form and infuse it into yours.
		This hypercharges you while leaving your opponent a shadow of its former self (leech power = X + the target's rank, rounded up).
		You gain stacks of Essence Infusion and the enemy is inflicted with stacks of Degeneration (bypassing saves) equal to leech power, lasting XX turns. Both effects have max 10 charges.
		Essence Infusion grants +XX to all powers and saves per stack.
		Degeneration reduces all stats by XX per stack.]]):
        format()
	end,
}

newTalent{
	-- Gain turns based on beneficial stacks. Enemies lose turns.
	name = "Tempauratic Invocation", short_name = "S_TEMPAURATIC_INVOCATION",
	type = {"aura/essence-control", 1},
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
		return ([[Newly-ripped auras are notoriously volatile, and sudden shaping of such material can have time-affecting consequences.
		Gain XX of a turn for each stack of Essence Infusion on yourself, consuming all stacks in the process.
		All enemies in sight lose XX of a turn for each stack of Degeneration on them, consuming all stacks in the process.]]):
        format()
	end,
}

newTalent{
	-- When you take damage the linked target does as well.
	name = "Redirective Link", short_name = "S_REDIRECTIVE_LINK",
	type = {"aura/essence-control", 1},
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
		return ([[You establish a link with a target currently suffering from Degeneration for XX turns.
		While in effect 50%% of all damage you take is also dealt as Phantom damage to the linked target.
		Does not reduce incoming damage.]]):
        format()
	end,
}

newTalent{
	-- Seize from further away, and seize more at once.
	name = "Essence Manipulation Mastery", short_name = "S_ESSENCE_MANIPULATION_MASTERY",
	type = {"aura/essence-control", 1},
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
		return ([[Your mastery over aura manipulation has reached such great levels that it allows you to manipulate the aura of those not in physical contact.
		Seize Essence's range is extended to XX.
		At talent level 5, Seize Essence now affects an area, radius 1.]]):
        format()
	end,
}