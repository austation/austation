/obj/item/projectile/coilshot
	name = "coilgun projectile"
	icon_state = "oopsy woopsy, if you can read this, coder has messed up."
	damage = 0
	nodamage = FALSE
	movement_type = FLYING | UNSTOPPABLE
	range = 5
	var/mass = 1
	var/special = "none" //special propeties
	var/heat = 0 //how hot this projectile is
	var/speed = 0 //how fast the projectile will exit the barrel
	var/charged = FALSE //has the projectile been overcharged already

/obj/item/projectile/coilshot/Range()
	..()
	var/amount_destruction = EXPLODE_NONE
	var/wallbreak_chance = 0
	if(speed)
		wallbreak_chance == speed * 0.5
	if(istype(loc, /turf/closed/wall))
		if(prob(wallbreak_chance))
			W.dismantle_wall(TRUE, TRUE)
	if
