/obj/item/projectile/energy/vortex
	name = "vortex beam"
	alpha = 0
	damage = 0
	damage_type = BURN
	reflectable = REFLECT_NORMAL
	nodamage = FALSE
	armor_flag = ENERGY
	range = 10
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMOB

/obj/item/projectile/energy/vortex/Range()
	new /obj/effect/temp_visual/hierophant/blast/vortex(get_turf(src), firer, FALSE)
	return ..()
