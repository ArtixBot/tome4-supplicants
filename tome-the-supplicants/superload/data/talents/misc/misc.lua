local _M = loadPrevious(...)

-- Update default melee attack so that it now accepts Phantom Jab as an alternate attack.
newTalent{
	name = "Attack",
	type = {"base/class", 1},
	no_energy = "fake",
	hide = "always",
	innate = true,
	points = 1,
	range = 1,
	message = false,
	no_break_stealth = true, -- stealth is broken in attackTarget
	requires_target = true,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t)} end,
	tactical = { ATTACK = { PHYSICAL = 1 } },
	no_unlearn_last = true,
	ignored_by_hotkeyautotalents = true,
	alternate_attacks = {'T_DOUBLE_STRIKE', 'T_S_PHANTOM_JAB'},
	speed = 'weapon',
	is_melee = true,
	action = function(self, t)
		if self:attr("never_attack") then return end
		local swap = not self:attr("disarmed") and (self:attr("warden_swap") and doWardenWeaponSwap(self, t, "blade"))
	
		local tg = self:getTalentTarget(t)
		local _, x, y = self:canProject(tg, self:getTarget(tg))
		local target = game.level.map(x, y, game.level.map.ACTOR)
		if not target then
			if swap then doWardenWeaponSwap(self, t, "bow") end
			return true -- Make sure this is done if an NPC attacks an empty grid.
		end

		local did_alternate = false
		for _, alt_t in ipairs(t.alternate_attacks) do
			if self:knowTalent(alt_t) and self:callTalent(alt_t, 'can_alternate_attack') then
				self:forceUseTalent(alt_t, {force_target = target})
				did_alternate = true
				break
			end
		end

		if not did_alternate then self:attackTarget(target) end

		if config.settings.tome.smooth_move > 0 and config.settings.tome.twitch_move then
			self:setMoveAnim(self.x, self.y, config.settings.tome.smooth_move, blur, util.getDir(x, y, self.x, self.y), 0.2)
		end

		return true
	end,
	info = function(self, t)
		return ([[Hack and slash, baby!]])
	end,
}

return _M
return _M