/datum/status_effect/regenerative_core/on_apply()
	if(!HAS_TRAIT(owner, TRAIT_NECROPOLIS_INFECTED))
		to_chat(owner, "<span class='userdanger'>Tendrils of vile corruption knit your flesh together and strengthen your sinew.</span>")
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "legion_core_trait")
	if(owner.z == 5)
		power = 2
	owner.adjustBruteLoss(-50 * power)
	owner.adjustFireLoss(-50 * power)
	owner.cure_nearsighted()
	owner.ExtinguishMob()
	owner.fire_stacks = 0
	owner.set_blindness(0)
	owner.set_blurriness(0)
	owner.restore_blood()
	owner.bodytemperature = BODYTEMP_NORMAL
	owner.restoreEars()
	duration = rand(150, 450) * power
	return TRUE
