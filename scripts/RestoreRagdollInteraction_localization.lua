--[[
    Author: Igromanru
    Date: 29.11.2024
    Mod Name: Restore Ragdoll Interaction
]]
local mod = get_mod("RestoreRagdollInteraction")

local SettingNames = mod:io_dofile("RestoreRagdollInteraction/scripts/setting_names")

return {
  mod_name =
  {
    en = "Restore Ragdoll Interaction",
  },
  mod_description =
  {
    en = "Restores Ragdoll Interaction feature",
  },
  [SettingNames.EnableMod] = {
    en = "Ragdoll Interaction"
  },
}
