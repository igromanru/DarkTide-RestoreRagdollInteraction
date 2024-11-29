return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`RestoreRagdollInteraction` encountered an error loading the Darktide Mod Framework.")

		new_mod("RestoreRagdollInteraction", {
			mod_script       = "RestoreRagdollInteraction/scripts/RestoreRagdollInteraction",
			mod_data         = "RestoreRagdollInteraction/scripts/RestoreRagdollInteraction_data",
			mod_localization = "RestoreRagdollInteraction/scripts/RestoreRagdollInteraction_localization",
		})
	end,
	packages = {},
}
