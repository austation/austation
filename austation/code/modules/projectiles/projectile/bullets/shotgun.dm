/obj/item/projectile/bullet/shotgun_slug
	damage = 60

/obj/item/projectile/bullet/shotgun_beanbag
	stamina = 80

/obj/item/projectile/bullet/shotgun_meteorslug
	paralyze = 80

/obj/item/projectile/bullet/pellet/shotgun_buckshot
	damage = 12.5
	tile_dropoff = 0

/obj/item/projectile/bullet/pellet/shotgun_rubbershot
	stamina = 25

/obj/item/projectile/bullet/pellet/shotgun_incapacitate
	stamina = 6

/obj/item/projectile/bullet/pellet/shotgun_improvised
	tile_dropoff = 0.55

/obj/item/projectile/bullet/scattershot
	damage = 24

/obj/item/projectile/bullet/pellet/Range()
	range--

	if(range <= 0 && loc)
		on_range()
