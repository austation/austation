/datum/reagent/medicine/earthsblood/on_mob_life(mob/living/carbon/M)
  M.adjustBruteLoss(-3 * REM, 0)
  M.adjustFireLoss(-3 * REM, 0)
  M.adjustOxyLoss(-15 * REM, 0)
  M.adjustToxLoss(-3 * REM, 0)
  M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5 * REM, 150) //This does, after all, come from ambrosia, and the most powerful ambrosia in existence, at that!
  M.adjustCloneLoss(-1 * REM, 0)
  M.adjustStaminaLoss(-30 * REM, 0)
  M.jitteriness = min(max(0, M.jitteriness + 3), 30)
  current_cycle++
  holder.remove_reagent(type, metabolization_rate / M.metabolism_efficiency)

/datum/reagent/medicine/radioactive_disinfectant
	name = "Radioactive Disinfectant"
	description = "Removes irradiation in synthetics."
	color = "#806F42"
	taste_description = "metallic"
	process_flags = SYNTHETIC

/datum/reagent/medicine/radioactive_disinfectant/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(M.radiation > 0)
		M.radiation -= min(M.radiation, 8)
	..()
