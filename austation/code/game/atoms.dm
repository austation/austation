/atom/rad_act(strength)
	if(istype(get_turf(src), /turf/open/pool))
		var/turf/open/pool/PL = get_turf(src)
		if(PL.filled == TRUE)
			strength *= 0.15
	..()
