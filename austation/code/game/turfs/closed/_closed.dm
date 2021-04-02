/turf/closed/indestructible/hvp_act(obj/item/projectile/hvp/PJ, severe = FALSE)
	if(prob(50))
		PJ.gameover()
	return FALSE
