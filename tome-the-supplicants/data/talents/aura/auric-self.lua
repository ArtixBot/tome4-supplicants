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
	-- Not dead yet.
	-- Get kills to revive and survive!
	name = "Tethered Body", short_name = "S_TETHERED_BODY",
	type = {"aura/auric-self", 1},
	mode = "passive",
	no_unlearn_last = true,
	getDuration = function(self, t) return math.ceil(25 + self:combatTalentLimit(t, 25, 10, 20)) end,
	getHealth = function(self, t) return self:combatTalentLimit(t, 1, 0.5, 0.8) end, -- Limit to < 100% health of summoner
	getHealPerKill = function(self, t) return self:combatTalentLimit(t, 10, 1, 5) end,	-- Limit 10% HP / kill.
	points = 5,
	callbackOnDeath = function(self, t, src, death_note)
		local m = self:cloneFull{
			shader = "shadow_simulacrum",
			shader_args = { color = {0.031, 1.0, 1.0}, base = 0.5, time_factor = 500 },
			no_drops = true, keep_inven_on_death = false,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			name = "Auratic Form of "..self.name,
			desc = [[A husk of some sentient being currently being kept 'alive' by its aura.]],
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil

		m.energy.value = 0
		m.player = nil
		m.max_life = m.max_life * t.getHealth(self, t)
		m.life = util.bound(m.life, 0, m.max_life)
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = function(self) self:removeEffect(self.EFF_ARCANE_EYE,true) end
		m.on_acquire_target = nil
		m.seen_by = nil
		m.puuid = nil
		m.on_takehit = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		m.exp_worth = 0
		m.no_inventory_access = true
		m.no_levelup_access = true
		
		
		-- The clone has a unique set of talents, but since it's a clone and starts with access to all the user's abilties we need to remove its access to those first.
		for tid, _ in pairs(m.talents) do
			local t = m:getTalentFromId(tid)
			if t then
				m:unlearnTalentFull(tid)
			end
		end
		
		m:learnTalent(m.T_S_CRUEL_DYNASTY,m:getTalentLevelRaw(m.T_S_TETHERED_BODY))
		m:learnTalent(m.T_S_CONNIVING_DYNASTY,m:getTalentLevelRaw(m.T_S_TETHERED_BODY))
		m:learnTalent(m.T_S_MALEFIC_DYNASTY,m:getTalentLevelRaw(m.T_S_TETHERED_BODY))
		m:learnTalent(m.T_S_PRECOGNITIVE_DYNASTY,m:getTalentLevelRaw(m.T_S_AURIC_COWLING))
		m:learnTalent(m.T_S_SWAP_DYNASTY,m:getTalentLevelRaw(m.T_S_AURIC_COWLING))
		m:learnTalent(m.T_S_RUPTURED_DYNASTY,m:getTalentLevelRaw(m.T_S_EXPUNGED_FORCE))
		m:learnTalent(m.T_S_OBLITERATE_DYNASTY,m:getTalentLevelRaw(m.T_S_EXPUNGED_FORCE))
		
		m.remove_from_party_on_death = true
		m.resists.all = -20
		
		game.zone:addEntity(game.level, m, "actor", self.x, self.y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="full",
				type="shadow",
				title="Auratic Form of "..self.name,
				temporary_level=1,
				orders = {target=true},
				on_control = function(self)
					self.summoner.ambuscade_ai = self.summoner.ai
					self.summoner.ai = "none"
				end,
				on_uncontrol = function(self)
					self.summoner.ai = self.summoner.ambuscade_ai
					game:onTickEnd(function() game.party:removeMember(self) self:removeEffect(self.EFF_ARCANE_EYE, true) self:disappear() end)
				end,
			})
		end
		game:onTickEnd(function() game.party:setPlayer(m) end)

		game:playSoundNear(self, "talents/spell_generic2")
		game.logSeen(self, "#08FF9E#Auratic energy surges into the husk of %s!", self.name:capitalize())
	end,
	info = function(self, t)
		return ([[#{bold}#The One#{normal}# has strengthened your ties to the earthly planes.
		When you would die, your aura surges into your corpse, causing you to enter Auratic Form for %d turns.
		You are fragile while in Auratic Form (-20%% resist all), with only %d%% of your max health. In this form, your talents are replaced with new talents: Cruel Dynasty, Conniving Dynasty, and Malefic Dynasty (talent level %d).
		
		Once your Auratic Form expires, your aura forces all of its harvested life energy to your body, restoring you to life and healing you for %d%% of your max health for each enemy killed in Auratic Form.
		Dying or killing nothing while in Auratic Form will kill you permanently!
		This talent can only trigger once per zone level.]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, self:getTalentLevelRaw(t), t.getHealPerKill(self, t))
	end,
}

newTalent{
	name = "Auric Cowling", short_name = "S_AURIC_COWLING",
	type = {"aura/auric-self", 2},
	mode = "passive",
	points = 5,
	getStat = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 5)) end,
	callbackOnTalentPost = function(self, t,  ab)
		if ab.type[1]:find("^aura/") and not ab.no_energy then
			if self.turn_procs.auric_cowling then return end
			self:setEffect(self.EFF_AURIC_COWLING, t.getDuration(self, t), {power = t.getStat(self, t), charges=1, max_charges=3})
			self.turn_procs.auric_cowling = true
		end
	end,
	info = function(self, t)
		return ([[Your body is attuned to its aura, and your aura responds in kind.
		Activating a non-instant aura talent increases all your stats by +%d for %d turns, stacking up to 3 times (but applying only once per turn).
		
		Additionally, your Auratic Form learns the talents Precognitive Dynasty and Swap Dynasty (talent level %d).]]):
		format(t.getStat(self, t), t.getDuration(self, t), self:getTalentLevelRaw(t))
	end,
}

newTalent{
	name = "Expunged Force", short_name = "S_EXPUNGED_FORCE",
	type = {"aura/auric-self", 3},
	mode = "passive",
	points = 5,
	getReduce = function(self, t) return self:combatTalentScale(t, 0.19, 0.32) end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		if rng.percent(20) then
			if self.turn_procs.expunged_force then return end
			game.logSeen(self, "#08FF9E#%s's aura redirects incoming damage!", self.name:capitalize())
			local total_dam = dam
			local absorbable_dam = t.getReduce(self,t) * total_dam
			local guaranteed_dam = total_dam - absorbable_dam
			
			-- Probably bugs out with poison effects.
			if src and src ~= self then DamageType:get(DamageType.PHANTOM).projector(src, src.x, src.y, DamageType.PHANTOM, absorbable_dam) end
			self.turn_procs.expunged_force = true
			return {dam=guaranteed_dam}
		end
	end,
	info = function(self, t)
		return ([[You instinctively focus you aura towards vital locations whenever hit, providing additional resilience.
		Every time you take damage, you have a 20%% chance to reduce the incoming damage by %d%%. The damage reduced by this ability is then sent back to the attacker (if applicable) as #08FF9E#Phantom#WHITE# damage.
		This talent can trigger at most once per turn.
		
		Additionally, your Auratic Form learns the talents Ruptured Dynasty and Obliterate Dynasty (talent level XX).]]):
		format(t.getReduce(self, t) * 100)
	end,
}

newTalent{
	name = "Induce Catalepsy", short_name = "S_INDUCE_CATALEPSY",
	type = {"aura/auric-self", 4},
	points = 5,
	aura = 10,
	cooldown = 4,
	tactical = { HEAL = 2 },
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(500, self)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
		end
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[Voluntarily and instantaneously sacrifice yourself to summon your Auratic Form. Doing so increases the duration of your Auratic Form by +XX.
		Inducing your Auratic Form empowers it, giving it access to three new talents: Penultimate Dynasty, Alter Dynasty, and Reverse Dynasty (talent level XX).
		Using this talent does not count against your passively-induced Auratic Form, but this talent can only be used once per zone.
		
		Note that if you are killed or get no kills in empowered Auratic Form you will still die, and dying while in empowered Auratic Form will not induce the passive Auratic Form effect!]]):
		format()
	end,
}