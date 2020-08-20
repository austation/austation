/obj/item/reagent_containers/food/snacks/grown/attack(mob/living/carbon/M, mob/user)
	if(seed)
		for(var/datum/plant_gene/trait/T in seed.genes)
			T.on_throw_impact(src, M)
	..()

/obj/item/reagent_containers/food/snacks/grown/squash(atom/target)
	var/turf/T = get_turf(target)
	forceMove(T)
	if(ispath(splat_type, /obj/effect/decal/cleanable/food/plant_smudge))
		if(filling_color)
			var/obj/O = new splat_type(T)
			O.color = filling_color
			O.name = "[name] smudge"
	else if(splat_type)
		new splat_type(T)

	if(trash)
		generate_trash(T)

	visible_message("<span class='warning'>[src] has been squashed.</span>","<span class='italics'>You hear a smack.</span>")
	if(seed)
		if(!seed.get_gene(/datum/plant_gene/trait/noreact))
			for(var/datum/plant_gene/trait/trait in seed.genes)
				trait.on_squash(src, target)
		else
			for(var/datum/plant_gene/trait/trait in seed.genes)
				trait.on_squashreact(src)

	reagents.reaction(T)
	for(var/A in T)
		reagents.reaction(A)

	qdel(src)
