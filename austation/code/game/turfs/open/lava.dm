/turf/open/lava/super_hot
	name = "super hot lava"
	baseturfs = /turf/open/lava/super_hot // it's super hott

/turf/open/lava/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/open/lava/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	return FALSE

/turf/open/lava/super_hot/smooth
	name = "super hot lava"
	baseturfs = /turf/open/lava/smooth
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/lava/super_hot/smooth)

/turf/open/lava/super_hot/smooth/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/lava/super_hot/smooth/lava_land_surface
