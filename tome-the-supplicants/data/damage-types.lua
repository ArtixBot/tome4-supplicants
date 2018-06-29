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

local initState = engine.DamageType.initState
local useImplicitCrit = engine.DamageType.useImplicitCrit

-- Resistance-piercing element.
-- Pretty powerful, trivialises certain enemies. Any talent which uses this better make sure that the Phantom damage dealt is low.
newDamageType{
	name = "phantom", type = "PHANTOM", text_color = "#08FF9E#",
	projector = function(src, x, y, type, dam, state)
		state = initState(state)
		useImplicitCrit(src, state)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		state = initState(state)
		if target and not state[target] then
			local penstore = src.resists_pen
			
			src.resists_pen = nil
			src.resists_pen = {all = 100}
			
			-- Still does Phantom damage but setting the first value to Phantom causes a stack overflow (understandably).
			DamageType:get(DamageType.FIRE).projector(src, x, y, DamageType.PHANTOM, dam, state)
			
			src.resists_pen = nil
			src.resists_pen = penstore
		end
		return dam
	end,
}