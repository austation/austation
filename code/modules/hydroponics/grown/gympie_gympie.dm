// Gympie Gympie
/obj/item/seeds/gympie_gympie
	name = "pack of gympie gympie seeds"
	desc = "These seeds grow into a gympie gympie plant"
	icon_state = "seed-gympie_gympie"
	species = "gympie"
	plantname = "Gympie Gympie Plants"
	product = /obj/item/reagent_containers/food/snacks/grown/gympie_gympie
	yield = 5
	genes = list(/datum/plant_gene/trait/stinging)
	growthstages = 3
	icon_grow = "gympiegympie-grow"
	icon_harvest = "gympiegympie-harvest"
	icon_dead = "gympiegympie-dead"
	mutatelist = list()
	reagents_add = list(/datum/reagent/toxin/mindbreaker = 0.10)
	rarity = 50
	var/volume = 5

/obj/item/reagent_containers/food/snacks/grown/gympie_gympie
	seed = /obj/item/seeds/gympie_gympie
	name = "gympie gympie"
	desc = "Touching it wouldn't be wise."
	icon_state = "gympiegympie"
	var/awakening = 0
	filling_color = "#B1FF15"

/obj/item/reagent_containers/food/snacks/grown/gympie_gympie/attack(mob/M, mob/user, def_zone)
	if(awakening)
		to_chat(user, "<span class='warning'>The contoring Gympie twists away!</span>")
		return
	..()

/obj/item/seeds/gympie_gympie/Initialize()
	. = ..()

	create_reagents(volume, INJECTABLE|DRAWABLE)

/obj/item/seeds/gympie_gympie/on_reagent_change(changetype)
	if(changetype == ADD_REAGENT)
		var/datum/reagent/medicine/strange_reagent/S = reagents.has_reagent(/datum/reagent/medicine/strange_reagent)
		if(S)
			spawn(30)
				if(!QDELETED(src))
					var/mob/living/simple_animal/hostile/gympie_gympie/G = new /mob/living/simple_animal/hostile/gympie_gympie(get_turf(src.loc))
					G.maxHealth += round(endurance / 3)
					G.melee_damage = 1+round(potency / 11)//Minimum 1 maximum 10. Minimum 1 damage due to weird bug with simple mob attacks (This is also probably broken)
					G.move_to_delay -= round(production / 50)
					G.gympie_poison_per_bite = 2+round(potency/14)//Minimum 2 units maximum of 8 (This probably doesn't work well)
					G.type_count = 0
					for(var/datum/plant_gene/reagent/R in genes)
						G.gympie_poison += R.reagent_id
						G.type_count++
					G.health = G.maxHealth
					if(/datum/plant_gene/trait/smoke in genes)
						G.gas_boy = TRUE
					if(/datum/plant_gene/trait/stinging in genes)
						G.sting_boy = TRUE
					G.visible_message("<span class='notice'>The Gympie Gympie violently shakes its leafs at you!</span>")
					qdel(src)