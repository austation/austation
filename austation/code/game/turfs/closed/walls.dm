/turf/closed/wall/hvp_act(obj/item/projectile/hvp/PJ, severe = FALSE)
	if(severe)
		ScrapeAway()
	else
		dismantle_wall(1,1)
	return TRUE
