/obj/vehicle/sealed/car/thanoscar
	name = "thanos car"
	desc = "THANOS CAR! THANOS CAR!"
	icon = 'austation/icons/obj/vehicles.dmi'
	icon_state = "thanoscar"
	max_integrity = 250
	armor = list("melee" = 70, "bullet" = 40, "laser" = 40, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	enter_delay = 20
	max_occupants = 50
	movedelay = 0.6
	key_type = null

/obj/vehicle/sealed/car/thanoscar/Bump(atom/movable/M)
	. = ..()
	if(isliving(M))
		var/mob/living/L = M
		visible_message("<span class='danger'>[src] rams into [L]!</span>")
		L.throw_at(get_edge_target_turf(src, get_dir(src, L)), 7, 5)
		L.Knockdown(50)
		playsound(loc, 'sound/vehicles/clowncar_crash2.ogg', 50, 1)
	if(istype(M, /obj/vehicle))
		var/obj/vehicle/V = M
		visible_message("<span class='danger'>[src] and [V] rebound off each other!</span>")
		playsound(loc, 'sound/vehicles/clowncar_ram3.ogg', 50, 1)
		V.throw_at(get_edge_target_turf(src, get_dir(src, V)), 3, 4)
		src.throw_at(get_edge_target_turf(src, get_dir(V, src)), 4, 4)
	if(istype(M, /turf/closed))
		visible_message("<span class='danger'>[src] bounces off the wall!</span>")
		src.throw_at(get_edge_target_turf(src, get_dir(M, src)), 1, 2)
		playsound(loc, 'sound/vehicles/clowncar_crash1.ogg', 50, 1)

/obj/vehicle/sealed/car/thanoscar/RunOver(mob/living/carbon/human/H) //override to prevent thanoscar mass murder
	H.visible_message("<span class='danger'>[src] drives over [H]!</span>", \
					"<span class='userdanger'>[src] drives over you!</span>")
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
