/obj/structure/disposalconstruct/loafer
	icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'

/obj/structure/disposalconstruct/coilgun
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
/*
/obj/structure/disposalconstruct/coilgun/Initialize(loc, _pipe_type, _dir = SOUTH, flip = FALSE, obj/make_from)
	. = ..()
*/
/obj/structure/disposalconstruct/coilgun/update_icon()
	icon_state = initial(pipe_type.icon_state)
	transform = transform.Scale(0.9, 0.9) // when you sprite it
