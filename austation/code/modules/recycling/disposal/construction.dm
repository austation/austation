/obj/structure/disposalconstruct/loafer
	icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'

/obj/structure/disposalconstruct/coilgun
	name = "coilgun segment"
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
	var/scale = 1

#define DECON_SCALE 0.9
/obj/structure/disposalconstruct/coilgun/update_icon()
	var/old_scale = scale
	if(anchored)
		scale = 1 + (1 - DECON_SCALE)
	else
		scale = DECON_SCALE
	if(scale != old_scale)
		transform = transform.Scale(scale, scale) // when you sprite it

/obj/structure/disposalconstruct/coilgun/is_pipe()
	return ispath(pipe_type, /obj/structure/disposalpipe/coilgun)
