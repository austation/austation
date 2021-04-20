/obj/structure/disposalconstruct/loafer
	icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'

/obj/structure/disposalconstruct/coilgun
	name = "coilgun segment"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	var/scale = 1

/// The size deconstructed pipes are scaled to, should always be less than 1
#define DECON_SCALE 0.9
/obj/structure/disposalconstruct/coilgun/update_icon()
	icon_state = initial(pipe_type.icon_state)
	var/old_scale = scale
	if(!is_pipe())
		return
	if(anchored)
		scale = 1 + (1 - DECON_SCALE)
		level = initial(pipe_type.level)
		layer = initial(pipe_type.layer)
	else
		scale = DECON_SCALE
		level = initial(level)
		layer = initial(layer)
	if(scale != old_scale)
		transform = transform.Scale(scale, scale)

#undef DECON_SCALE

/obj/structure/disposalconstruct/coilgun/is_pipe()
	return ispath(pipe_type, /obj/structure/disposalpipe/coilgun)
