/datum/reagent
	var/aus = FALSE // is this drink austation only?
	var/gas = null //do we have an associated gas? (expects a string, not a datum typepath!)
	var/boiling_point = null // point at which this gas boils; if null, will never boil (and thus not become a gas)
	var/condensation_amount = 1
	var/molarity = 5 // How many units per mole of this reagent. Technically this is INVERSE molarity, but hey.

/datum/reagent/reaction_obj(obj/O, volume)
	if(O && volume && boiling_point)
		var/temp = holder ? holder.chem_temp : T20C
		if(temp > boiling_point)
			O.atmos_spawn_air("[get_gas()]=[volume/molarity];TEMP=[temp]")

/datum/reagent/reaction_turf(turf/T, volume, show_message, from_gas)
	if(!from_gas && boiling_point)
		var/temp = holder?.chem_temp
		if(!temp)
			if(isopenturf(T))
				var/turf/open/O = T
				var/datum/gas_mixture/air = O.return_air()
				temp = air.return_temperature()
			else
				temp = T20C
		if(temp > boiling_point)
			T.atmos_spawn_air("[get_gas()]=[volume/molarity];TEMP=[temp]")

/datum/reagent/proc/define_gas()
	if(reagent_state == SOLID)
		return null // doesn't make that much sense
	var/list/cached_reactions = GLOB.chemical_reactions_list
	for(var/reaction in cached_reactions[src.type])
		var/datum/chemical_reaction/C = reaction
		if(!istype(C))
			continue
		if(C.required_reagents.len < 2) // no reagents that react on their own
			return null
	var/datum/gas/G = new
	G.id = "[src.type]"
	G.name = name
	G.specific_heat = specific_heat / 10
	G.color = color
	G.breath_reagent = src.type
	G.group = GAS_GROUP_CHEMICALS
	return G

/datum/reagent/proc/create_gas()
	var/datum/gas/G = define_gas()
	if(istype(G)) // if this reagent should never be a gas, define_gas may return null
		GLOB.gas_data.add_gas(G)
		var/datum/gas_reaction/condensation/condensation_reaction = new(src) // did you know? you can totally just add new reactions at runtime. it's allowed
		SSair.add_reaction(condensation_reaction)
	return G


/datum/reagent/proc/get_gas()
	if(gas)
		return gas
	else
		var/datum/auxgm/cached_gas_data = GLOB.gas_data
		. = "[src.type]"
		if(!(. in cached_gas_data.ids))
			create_gas()

