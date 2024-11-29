--[[
    Author: Igromanru
    Date: 29.11.2024
    Mod Name: Restore Ragdoll Interaction
]]
local mod = get_mod("RestoreRagdollInteraction")
local SettingNames = mod:io_dofile("RestoreRagdollInteraction/scripts/setting_names")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	allow_rehooking = true,
	options = {
		widgets = {
			{
				setting_id = SettingNames.EnableMod,
				type = "checkbox",
				default_value = true
			},
		}
	},
}
