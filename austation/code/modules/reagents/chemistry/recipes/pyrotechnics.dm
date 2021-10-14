/datum/chemical_reaction/reagent_explosion/rdx
	results = list(/datum/reagent/rdx= 2)
	required_reagents = list(/datum/reagent/phenol = 2, /datum/reagent/toxin/acid/nitracid = 1, /datum/reagent/acetone_oxide = 1 )
	required_catalysts = list(/datum/reagent/gold) //royal explosive
	required_temp = 404
	strengthdiv = 8

/datum/chemical_reaction/reagent_explosion/rdx/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/rdx, created_volume*2)
	..()

/datum/chemical_reaction/reagent_explosion/rdx_explosion
	required_reagents = list(/datum/reagent/rdx = 1)
	required_temp = 474
	strengthdiv = 7

/datum/chemical_reaction/reagent_explosion/rdx_explosion2 //makes rdx unique , on its own it is a good bomb, but when combined with liquid electricity it becomes truly destructive
	required_reagents = list(/datum/reagent/rdx = 1 , /datum/reagent/consumable/liquidelectricity = 1)
	strengthdiv = 3.5 //actually a decrease of 1 becaused of how explosions are calculated. This is due to the fact we require 2 reagents
	modifier = 2

/datum/chemical_reaction/reagent_explosion/rdx_explosion2/on_reaction(datum/reagents/holder, created_volume)
	var/fire_range = round(created_volume/50)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(fire_range,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 500
	..()

/datum/chemical_reaction/reagent_explosion/rdx_explosion3
	required_reagents = list(/datum/reagent/rdx = 1 , /datum/reagent/teslium = 1)
	strengthdiv = 3.5 //actually a decrease of 1 becaused of how explosions are calculated. This is due to the fact we require 2 reagents
	modifier = 4


/datum/chemical_reaction/reagent_explosion/rdx_explosion3/on_reaction(datum/reagents/holder, created_volume)
	var/fire_range = round(created_volume/30)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(fire_range,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 750
	..()

/datum/chemical_reaction/reagent_explosion/tatp
	results = list(/datum/reagent/tatp= 1)
	required_reagents = list(/datum/reagent/acetone_oxide = 1, /datum/reagent/toxin/acid/nitracid = 1, /datum/reagent/pentaerythritol = 1 )
	required_temp = 450
	strengthdiv = 3

/datum/chemical_reaction/reagent_explosion/tatp/update_info()
	required_temp = 450 + rand(-49,49)  //this gets loaded only on round start

/datum/chemical_reaction/reagent_explosion/tatp/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent(/datum/reagent/exotic_stabilizer,round(created_volume / 50, CHEMICAL_QUANTISATION_LEVEL))) // we like exotic stabilizer
		return
	holder.remove_reagent(/datum/reagent/tatp, created_volume)
	..()

/datum/chemical_reaction/reagent_explosion/tatp_explosion
	required_reagents = list(/datum/reagent/tatp = 1)
	required_temp = 550 // this makes making tatp before pyro nades, and extreme pain in the ass to make
	strengthdiv = 3

/datum/chemical_reaction/reagent_explosion/tatp_explosion/on_reaction(datum/reagents/holder, created_volume)
	var/strengthdiv_adjust = created_volume / ( 2100 / initial(strengthdiv))
	strengthdiv = max(initial(strengthdiv) - strengthdiv_adjust + 1.5 ,1.5) //Slightly better than nitroglycerin
	. = ..()
	return

/datum/chemical_reaction/reagent_explosion/tatp_explosion/update_info()
	required_temp = 550 + rand(-49,49)

/datum/chemical_reaction/gasoline
	name = "Petrol"
	id = /datum/reagent/gasoline
	results = list(/datum/reagent/gasoline = 3)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/fuel = 1)
	required_temp = 450

/datum/chemical_reaction/napalm_alt
    name = "Napalm"
    id = /datum/reagent/napalm
    results = list(/datum/reagent/napalm = 3)
    required_reagents = list(/datum/reagent/polystyrene = 1, /datum/reagent/gasoline = 3)
    mix_message = "<span class='danger'>The mixture thickens, becoming a gel-like substance.</span>"
