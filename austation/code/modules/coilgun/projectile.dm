/obj/item/projectile/coilshot
	name = "coilgun projectile"
	desc = "oopsy woopsy, if you can read this, coder has messed up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	damage = 0
	nodamage = FALSE
	movement_type = FLYING | UNSTOPPABLE
	range = 5
	var/heat_capacity = 80
	var/mass = 0
	var/special = "none" //special propeties
	var/p_heat = 0 //how hot this projectile is
	var/p_speed = 0 //how fast the projectile will exit the barrel
	var/charged = FALSE //has the projectile been overcharged already



/obj/item/projectile/coilshot/Range()
	..()
	var/amount_destruction = EXPLODE_NONE
	var/wallbreak_chance = 0
	var/momentum = 0
	if(speed && mass)
		momentum = mass*speed
	else
		gameover()

	if(istype(loc, /turf/closed/wall))
		var/turf/closed/wall/W = loc
		if(momentum >= 100) // uses 100 momentum to destroy a wall
			W.dismantle_wall(TRUE, TRUE)
			momentum -= 100
		else
			gameover()



/obj/item/projectile/coilshot/on_transfer()// called when we pass through a charger
	if(heat >= heat_capacity)
		var/obj/effect/decal/cleanable/ash/melted = new(loc) // make a new
		playsound(loc, 'sound/items/welder.ogg', 150, 1)
		melted.name = "slagged [name]"
		melted.desc = "Ahahah that's hot, that's hot."
		qdel(src)

// called when projectile has expired, replaces coilshot projectile with the original projectile
/obj/item/projectile/coilshot/gameover()
