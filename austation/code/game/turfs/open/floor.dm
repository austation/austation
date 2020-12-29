/turf/open/floor
	var/painted = 0
	var/current_overlay = null
	initial_gas_mix = "o2=22;n2=82;TEMP=313.15"

/turf/open/floor/Initialize(mapload)

	if (!broken_states)
		broken_states = typelist("broken_states", list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5"))
	else
		broken_states = typelist("broken_states", broken_states)
	burnt_states = typelist("burnt_states", burnt_states)
	if(!broken && broken_states && (icon_state in broken_states))
		broken = TRUE
	if(!burnt && burnt_states && (icon_state in burnt_states))
		burnt = TRUE
	. = ..()
	//This is so damaged or burnt tiles or platings don't get remembered as the default tile
	var/static/list/icons_to_ignore_at_floor_init = list("foam_plating", "plating","light_on","light_on_flicker1","light_on_flicker2",
					"light_on_clicker3","light_on_clicker4","light_on_clicker5",
					"light_on_broken","light_off","wall_thermite","grass", "sand",
					"asteroid","asteroid_dug",
					"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
					"asteroid5","asteroid6","asteroid7","asteroid8","asteroid9","asteroid10","asteroid11","asteroid12",
					"basalt","basalt_dug",
					"basalt0","basalt1","basalt2","basalt3","basalt4",
					"basalt5","basalt6","basalt7","basalt8","basalt9","basalt10","basalt11","basalt12",
					"oldburning","light-on-r","light-on-y","light-on-g","light-on-b", "wood", "carpetsymbol", "carpetstar",
					"carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
					"ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
					"ironsand12", "ironsand13", "ironsand14", "ironsand15")
	if(broken || burnt || (icon_state in icons_to_ignore_at_floor_init)) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state
	if(mapload && prob(33))
		MakeDirty()

/turf/open/floor/update_icon()
	if(painted)
		update_visuals()
		overlays -= current_overlay
		if(current_overlay)
			overlays.Add(current_overlay)
		return
	else
		..()

/turf/open/floor/break_tile()
	if(painted)
		if(broken)
			return
		current_overlay = pick(broken_states)
		broken = 1
		update_icon()
	else
		..()

/turf/open/floor/burn_tile()
	if(painted)
		if(burnt)
			return
		current_overlay = pick(burnt_states)
		burnt = 1
		update_icon()
	else
		..()
