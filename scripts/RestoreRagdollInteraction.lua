--[[
    Author: Igromanru
    Date: 29.11.2024
    Mod Name: Restore Ragdoll Interaction
	Version: 1.0.0
]]
local mod = get_mod("RestoreRagdollInteraction")
local SettingNames = mod:io_dofile("RestoreRagdollInteraction/scripts/setting_names")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local Breed = require("scripts/utilities/breed")

local attack_results = AttackSettings.attack_results
local damage_efficiencies = AttackSettings.damage_efficiencies

local VALID_HIT_ZONES = {
	center_mass = true,
	head = true,
	lower_left_arm = true,
	lower_left_leg = true,
	lower_right_arm = true,
	lower_right_leg = true,
	lower_tail = true,
	torso = true,
	upper_left_arm = true,
	upper_left_leg = true,
	upper_right_arm = true,
	upper_right_leg = true,
	upper_tail = true,
}

local function _push_ragdoll(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, herding_template_or_nil)
	local minion_death_manager = Managers.state.minion_death
	local minion_ragdoll = minion_death_manager:minion_ragdoll()
	local on_dead_ragdoll = true

	minion_ragdoll:push_ragdoll(ragdoll_unit, attack_direction, damage_profile, hit_zone_name, herding_template_or_nil, on_dead_ragdoll)
end

local function _find_random_hitzone(ragdoll_unit, optional_is_critical_strike)
	local breed = Breed.unit_breed_or_nil(ragdoll_unit)
	local breed_hit_zones = breed.hit_zones
	local num_breed_hit_zones = #breed_hit_zones
	local hit_zone_name
	local num_iterations = 0

	if not optional_is_critical_strike then
		repeat
			local random_hit_zone_name = breed_hit_zones[math.random(1, num_breed_hit_zones)].name

			if VALID_HIT_ZONES[random_hit_zone_name] then
				hit_zone_name = random_hit_zone_name
			end

			num_iterations = num_iterations + 1
		until hit_zone_name ~= nil or num_breed_hit_zones <= num_iterations
	end

	return hit_zone_name or "center_mass"
end

local function _gib(ragdoll_unit, hit_zone_name_or_nil, attack_direction, damage_profile, is_critical_strike_or_nil)
	local should_gib = true

	if should_gib then
		if damage_profile.random_gib_hitzone then
			hit_zone_name_or_nil = _find_random_hitzone(ragdoll_unit, is_critical_strike_or_nil)
		end

		local visual_loadout_extension = ScriptUnit.extension(ragdoll_unit, "visual_loadout_system")

		if visual_loadout_extension:can_gib(hit_zone_name_or_nil) then
			visual_loadout_extension:gib(hit_zone_name_or_nil, attack_direction, damage_profile, is_critical_strike_or_nil)
		end
	end
end

mod:hook_require("scripts/utilities/minion_death", function(instance)
	mod:hook_origin(instance, "attack_ragdoll", function(ragdoll_unit, attack_direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_world_position_or_nil, attacking_unit_or_nil, hit_actor_or_nil, herding_template_or_nil, critical_strike_or_nil)
		if not mod:get(SettingNames.EnableMod) then return end

        local hit_zone_name = hit_zone_name_or_nil or "center_mass"

		_push_ragdoll(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, herding_template_or_nil)
		_gib(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, critical_strike_or_nil)

		local damage = 1
		local attack_result = attack_results.damaged
		local hit_normal
		local attack_was_stopped = false
		local damage_efficiency = damage_efficiencies.full

		ImpactEffect.play(ragdoll_unit, hit_actor_or_nil, damage, damage_type, hit_zone_name, attack_result, hit_world_position_or_nil, hit_normal, attack_direction, attacking_unit_or_nil, IMPACT_FX_DATA, attack_was_stopped, nil, damage_efficiency, nil)
    end)
end)