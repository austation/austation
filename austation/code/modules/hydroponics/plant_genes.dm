/datum/plant_gene/trait/battery/on_attackby(obj/item/reagent_containers/food/snacks/grown/G, obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(5))
			to_chat(user, "<span class='notice'>You add some cable to [G] and slide it inside the battery encasing.</span>")
			var/obj/item/stock_parts/cell/potato/pocell = new /obj/item/stock_parts/cell/potato(user.loc)
			pocell.icon_state = G.icon_state
			pocell.maxcharge = G.seed.potency * 20

			// The secret of potato supercells!
			var/datum/plant_gene/trait/cell_charge/CG = G.seed.get_gene(/datum/plant_gene/trait/cell_charge)
			if(CG) // 10x charge for deafult cell charge gene - 20 000 with 100 potency.
				pocell.maxcharge *= CG.rate*500
			pocell.charge = pocell.maxcharge
			pocell.name = "[G.name] battery"
			pocell.desc = "A rechargeable plant-based power cell. This one has a rating of [DisplayEnergy(pocell.maxcharge)], and you should not swallow it."

			if(G.reagents.has_reagent(/datum/reagent/toxin/plasma, 2))
				pocell.rigged = TRUE

			qdel(G)
		else
			to_chat(user, "<span class='warning'>You need five lengths of cable to make a [G] battery!</span>")

// Add sepchems back
/datum/plant_gene/trait/noreact
	// Makes plant reagents not react until squashed.
	name = "Separated Chemicals"

/datum/plant_gene/trait/noreact/on_new(obj/item/reagent_containers/food/snacks/grown/G, newloc)
	..()
	ENABLE_BITFIELD(G.reagents.flags, NO_REACT)

/datum/plant_gene/trait/noreact/on_squashreact(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	DISABLE_BITFIELD(G.reagents.flags, NO_REACT)
	G.reagents.handle_reactions()

//Too close to Neck-Code TM
/datum/plant_gene/trait/spines
	name = "Floral Spines"

/datum/plant_gene/trait/spines/on_slip(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	if(G.seed)
		if(G.seed.get_gene(/datum/plant_gene/trait/spines))
			if(istype(target, /mob/living))
				G.target = target

				G.grown_overlay.layer = FLOAT_LAYER
				G.target.add_overlay(G.grown_overlay, TRUE)
			
				var/P = G.seed.get_gene(/datum/plant_gene/trait/stinging)
				var/mob/living/L = target
				L.adjustBruteLoss((G.seed.potency/4.7)*P)

/datum/plant_gene/trait/spines/on_throw_impact(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	if(!..()) //was it caught by a mob?
		if(seed)
			if(seed.get_gene(/datum/plant_gene/trait/spines))
				if(istype(hit_atom, /mob/living))
					target = hit_atom

					grown_overlay.layer = FLOAT_LAYER
					target.add_overlay(grown_overlay, TRUE)
				
					var/P = seed.get_gene(/datum/plant_gene/trait/stinging)
					var/mob/living/L = hit_atom
					L.adjustBruteLoss((seed.potency/4.7)*P)//I'm not going to use embed damage, this is easier.
