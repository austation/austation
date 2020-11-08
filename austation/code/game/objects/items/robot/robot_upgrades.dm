/obj/item/borg/upgrade/transform/security
	name = "borg module picker (Security)"
	desc = "Allows you to turn a cyborg into a security model."
	icon_state = "cyborg_upgrade3"
	new_module = /obj/item/robot_module/security

/obj/item/borg/upgrade/kitchen
	name = "cyborg upgrade (service)"
	desc = "Allows a service borg to be upgraded with cooking utensils."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/butler

/obj/item/borg/upgrade/kitchen/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/kitchen/rollingpin/K = locate() in R.module
		var/obj/item/kitchen/knife/T = locate() in R.module
		var/obj/item/borg/apparatus/food/F = locate() in R.module
		if(K)
			to_chat(user, "<span class='warning'>This unit is already equipped with a cooking upgrade.</span>")
			return FALSE

		K = new(R.module)
		T = new(R.module)
		F = new(R.module)
		R.module.basic_modules += K
		R.module.basic_modules += T
		R.module.basic_modules += F
		R.module.add_module(K, FALSE, TRUE)
		R.module.add_module(T, FALSE, TRUE)
		R.module.add_module(F, FALSE, TRUE)

/obj/item/borg/upgrade/kitchen/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/upgrade/kitchen/K = locate() in R.module
		if (K)
			R.module.remove_module(K, TRUE)

		var/obj/item/borg/upgrade/kitchen/T = locate() in R.module
		if (T)
			R.module.remove_module(T, TRUE)

		var/obj/item/borg/apparatus/food/F = locate() in R.module
		if (F)
			R.module.remove_module(F, TRUE)
