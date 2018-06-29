local ActorResource = require "engine.interface.ActorResource"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local Birther = require "engine.Birther"
local DamageType = require "engine.DamageType"


ActorResource:defineResource("Aura", "aura","T_AURA_POOL", "aura_regen", "Aura manifests itself around all sentient beings. It naturally regenerates, given time.\n\nThe manipulation of aura is made exceedingly difficult while wearing any fatigue-increasing armor (+8% cost / point of fatigue).", nil, nil, {
	color = "#08FF9E#",
	shader_params = {name = "resources", require_shader=4, delay_load=true, color={0x7b/255, 0xff/255, 0xcb/255}, speed=1000, distort={0.4,0.4}},
	cost_factor = function(self, t) return (100 + 8 * self:combatFatigue()) / 100 end,	-- 1 point of fatigue increases costs by 8%.
	wait_on_rest = true,
	randomboss_enhanced = true
})

class:bindHook("ToME:load", function(self, data)
    ActorTalents:loadDefinition("/data-supplicants/talents/aura/aura.lua")
	ActorTemporaryEffects:loadDefinition("/data-supplicants/timed-effects.lua")
    Birther:loadDefinition("/data-supplicants/birth/classes/supplicants.lua")
	DamageType:loadDefinition("/data-supplicants/damage-types.lua")
end)