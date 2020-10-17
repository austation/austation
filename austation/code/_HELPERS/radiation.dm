/radiation_pulse(atom/source, intensity, range_modifier, log=FALSE, can_contaminate=TRUE)
	if(istype(get_turf(source), /turf/open/pool))
		var/turf/open/pool/PL = get_turf(source)
		if(PL.filled == TRUE)
			intensity *= 0.15
	..()
