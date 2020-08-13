/mob/living/carbon/attack_tk(mob/living/carbon/owner)
	src.help_shake_act(owner)
	owner.changeNext_move(CLICK_CD_MELEE)
