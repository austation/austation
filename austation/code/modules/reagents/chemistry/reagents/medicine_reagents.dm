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

/datum/reagent/medicine/morphine
	description = "A painkiller that allows the patient to move at full speed even while severely wounded. Overdose will cause a variety of effects, ranging from minor to lethal."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25
	addiction_threshold = 30

/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/L)
  ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)

/datum/reagent/medicine/morphine/on_mob_life(mob/living/carbon/M)
  current_cycle++
  holder.remove_reagent(type, metabolization_rate / M.metabolism_efficiency)

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/L)
  REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
