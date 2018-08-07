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
	-- Randomly gain a signficant Defense and evasion boost.
	name = "Aurasurge", short_name = "S_AURASURGE",
	type = {"aura/aurasurge", 1},
	mode = "passive",
	points = 5,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	getChanceDef = function(self, t) return self:combatTalentLimit(t, 50, 15, 30), self:combatTalentScale(t, 25, 60) end,
	callbackOnActBase = function(self, t)
		if rng.percent(6) then
			local chance, def = t.getChanceDef(self, t)
			game.logSeen(self, "#08FF9E#%s's aura surges with energy!", self.name:capitalize())
			self:setEffect(self.EFF_AURASURGE, t.getDur(self, t), {chance=chance, defense=def})
			game:playSoundNear(self, "talents/heal")
		end
	end,
	info = function(self, t)
		local chance, def = t.getChanceDef(self, t)
		return ([[Your aura's energy is so great that portions of it randomly manifest, becoming visible to the naked eye as a sort of 'afterimage.'
		While manifested, attackers are perplexed as they cannot discern where to attack.
		Every turn there is an 6%% chance for your aura to supercharge and affect reality, granting Aurasurge for %d turns (or refreshing its duration).
		Aurasurge confers +%d Defense and gives you an %d%% chance to dodge incoming melee and ranged attacks.]]):
		format(t.getDur(self, t), def, chance)
	end,
}

newTalent{
	-- While Aurasurge is active increase attack speed and add damage to each hit.
	name = "Energy-Surged Fists", short_name = "S_ENERGY_SURGED_FISTS",
	type = {"aura/aurasurge", 2},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	getPhantom = function(self, t) return self:combatTalentScale(t, 3, 21) end,	-- Effectively +42 damage on basic strikes (assuming a brawler dual strikes) before upscaling.
	callbackOnTemporaryEffectAdd = function(self, t, eff_id, e, p)
		if eff_id == self.EFF_AURASURGE then
			self:setEffect(self.EFF_AURASURGE_FIST, p.dur, {speed = 0.35, power = t.getPhantom(self, t)})
		end
	end,
	info = function(self, t)
		return ([[Whenever Aurasurge is active, your fists become infused with raw auric energy.
		This increases attack speed by 35%% and adds %d #08FF9E#Phantom#WHITE# damage to every melee attack.]]):
		format(t.getPhantom(self, t))
	end,
}

newTalent{
	-- Consume Aurasurge and summon allies.
	name = "Form Afterimages", short_name = "S_FORM_AFTERIMAGES",
	type = {"aura/aurasurge", 3},
	mode = "passive",
	points = 5,
	require = techs_str_req1,
	info = function(self, t)
		return ([[Whenever Aurasurge is active, you can focus your boosted aura to form 2 auric clones of yourself for XX turns, based on the number of turns remaining on your Aurasurge effect.
		These clones share all your talents, but have life equal to XX of your max life and are fragile (-20%% resist all), and only deal XX damage with all attacks.
		Activating Form Afterimages will remove your Aurasurge effect.]]):
		format()
	end,
}

newTalent{
	-- While Aurasurge is active fatal blows are redirected!
	name = "Phantom Imagery", short_name = "S_PHANTOM_IMAGERY",
	type = {"aura/aurasurge", 4},
	mode = "sustained",
	sustain_aura = 100,
	points = 5,
	require = techs_str_req1,
	getChance = function(self, t) return math.max(math.floor(self:getTalentLevel(t) / 2), 1) end,
	activate = function(self, t)
		return true
	end,
	deactivate = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[While empowered, your aura reaches such heights of energy that it will automatically form a phantom afterimage to absorb any incoming fatal blow.
		This negates the blow, and you teleport randomly in a range of XX tiles.
		The activation of this talent will remove your Aurasurge effect.
		
		Passively increases the chance for Aurasurge to trigger each turn by +XX.]]):
		format()
	end,
}