/obj/item/twohanded/required/fuel_rod
	var/rad_strength = 500
	var/half_life = 2000 // how many depletion ticks are needed to half the fuel_power (1 tick = 1 second)
	var/time_created = 0
	var/og_fuel_power = 0.20 //the original fuel power value
	var/process =  FALSE
	var/depletion_threshold = 100
	var/depletion_speed_modifier = 1

/obj/item/twohanded/required/fuel_rod/Initialize()
	. = ..()
	time_created = world.time
	var/datum/component/radioactive/oldradcomponent = GetComponent(/datum/component/radioactive)
	if(istype(oldradcomponent))
		oldradcomponent.RemoveComponent()
	AddComponent(/datum/component/radioactive, rad_strength, src)
	if(process)
		START_PROCESSING(SSobj, src)

/obj/item/twohanded/required/fuel_rod/Destroy()
	if(process)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/twohanded/required/fuel_rod/proc/Final_Depletion()
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/N = loc
	if(istype(N))
		var/obj/item/twohanded/required/fuel_rod/plutonium/P = new(loc)
		P.depletion = depletion
		N.fuel_rods += P
		qdel(src)

/obj/item/twohanded/required/fuel_rod/deplete(amount=0.035) // override for the one in rmbk.dm
	depletion += amount * depletion_speed_modifier
	if(depletion >= depletion_threshold)
		Final_Depletion()

/obj/item/twohanded/required/fuel_rod/plutonium
	fuel_power = 0.20
	name = "Plutonium-239 Fuel Rod"
	desc = "A highly energetic titanium sheathed rod containing a sizeable measure of weapons grade plutonium, it's highly efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
	icon_state = "inferior"
	rad_strength = 1500
	process = TRUE // for half life code
	depletion_threshold = 300

/obj/item/twohanded/required/fuel_rod/plutonium/process()
	fuel_power = og_fuel_power * 0.5**((world.time - time_created) / half_life SECONDS) // halves the fuel power every half life (33 minutes)

/obj/item/twohanded/required/fuel_rod/plutonium/Final_Depletion()
	if(fuel_power < 10)
		var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/N = loc
		fuel_power = 0
		playsound(loc, 'sound/effects/supermatter.ogg', 100, TRUE)
		if(istype(N))
			var/obj/item/twohanded/required/fuel_rod/depleted/D = new(loc)
			D.depletion = depletion
			N.fuel_rods += D
			qdel(src)

/obj/item/twohanded/required/fuel_rod/depleted
	name = "Depleted Fuel Rod"
	desc = "A highly radioactive fuel rod which has expended most of it's useful energy."
	icon_state = "normal"
	rad_strength = 6000 // smelly

// Master type for material optional (or requiring, wyci) and/or producing rods
/obj/item/twohanded/required/fuel_rod/material
	var/grown = FALSE
	var/expended = FALSE
	var/material_type
	var/initial_amount = 0
	var/max_initial_amount = 10
	var/grown_amount = 0
	var/multiplier = 2
	depletion_speed_modifier = 2
	var/material_input_deadline = 25

/obj/item/twohanded/required/fuel_rod/material/proc/expend()
	expended = TRUE

/obj/item/twohanded/required/fuel_rod/material/proc/check_material_input(mob/user)
	if(depletion >= material_input_deadline)
		to_chat(user, "<span class='warning'>The sample slots have sealed themselves shut, it's too late to add [material_type] now!</span>") // no cheesing in crystals at 100%
		return FALSE
	if(expended)
		to_chat(user, "<span class='warning'>\The [src]'s material slots have already been used.</span>")
		return FALSE
	return TRUE

/obj/item/twohanded/required/fuel_rod/material/Final_Depletion()
	grown = TRUE
	grown_amount = initial_amount * multiplier

/obj/item/twohanded/required/fuel_rod/material/attackby(obj/item/W, mob/user, params)
	var/obj/item/stack/M = W
	if(istype(M, material_type))
		if(!check_material_input(user))
			return
		if(initial_amount < max_initial_amount)
			var/adding = min((max_initial_amount - initial_amount), M.amount)
			M.amount -= adding
			initial_amount += adding
			M.zero_amount()
			to_chat(user, "<span class='notice'>You insert [adding] [M] into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src]'s material slots are full!</span>")
			return
	else
		return ..()

/obj/item/twohanded/required/fuel_rod/material/attack_self(mob/user)
	if(expended)
		to_chat(user, "<span class='notice'>You have already removed \the [material_type] from \the [src].</span>")
		return

	if(grown)
		do
			var/obj/item/stack/st = new material_type(get_turf(user))
			var/output = min(grown_amount, st.max_amount)
			to_chat(user, "<span class='notice'>You harvest [output] [material_type] from \the [src].</span>")
			grown_amount -= output
			st.amount = output
		while(grown_amount)
		expend()
	else if(depletion)
		to_chat(user, "<span class='warning'>\The [src] has not fissiled enough to fully grow the sample. The progress bar shows it is [min(depletion/depletion_threshold*100,100)]% complete.</span>")
	else if(initial_amount)
		do
			var/obj/item/stack/st = new material_type(get_turf(user))
			var/output = min(initial_amount, st.max_amount)
			to_chat(user, "<span class='notice'>You remove [output] [material_type] from \the [src].</span>")
			initial_amount -= output
			st.amount = output
		while(initial_amount)

/obj/item/twohanded/required/fuel_rod/material/examine(mob/user)
	. = ..()
	if(expended)
		. += "<span class='warning'>The material slots have been slagged by the extreme heat, you can't grow [material_type] in this rod again...</span>"
		return
	else if(grown)
		. += "<span class='warning'>This fuel rod's [material_type] are now fully grown, and it currently bears [grown_amount] [material_type].</span>"
		return
	if(depletion)
		. += "<span class='danger'>The sample is [min(depletion/depletion_threshold*100,100)]% fissiled.</span>"
	. += "<span class='disarm'>[initial_amount]/[max_initial_amount] of the slots for [material_type] are full.</span>"

/obj/item/twohanded/required/fuel_rod/material/telecrystal
	name = "Telecrystal Fuel Rod"
	desc = "A disguised titanium sheathed rod containing several small slots infused with uranium dioxide. Permits the insertion of telecrystals to grow more. Fissiles much faster than its standard counterpart"
	icon_state = "telecrystal"
	fuel_power = 0.30 // twice as powerful as a normal rod, you're going to need some engineering autism if you plan to mass produce TC
	depletion_speed_modifier = 3 // headstart, otherwise it takes two hours
	rad_strength = 1500
	max_initial_amount = 8
	multiplier = 3
	material_type = /obj/item/stack/telecrystal

/obj/item/twohanded/required/fuel_rod/material/telecrystal/Final_Depletion()
	..()
	fuel_power = 0.60 // thrice as powerful as plutonium, you'll want to get this one out quick!
	name = "Exhausted Telecrystal Fuel Rod"
	desc = "A highly energetic, disguised titanium sheathed rod containing a number of slots filled with greatly expanded telecrystals which can be removed by hand. It's extremely efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
	icon_state = "telecrystal_used"
	AddComponent(/datum/component/radioactive, 3000, src)

/obj/item/twohanded/required/fuel_rod/material/bluespace
	name = "Bluespace Crystal Fuel Rod"
	desc = "A heavy-duty low-grade fuel rod which fissiles much slower than standard counterparts. However, it's complex and sophisticated design allows insertion and utilisation of a certain material with special properties, namely bluespace crystals."
	icon_state = "bluespace"
	fuel_power = 0.05 // bluespace growth shouldn't be *that* interesting, isn't it?
	rad_strength = 200
	og_fuel_power = 0.05
	max_initial_amount = 15
	multiplier = 3
	material_type = /obj/item/stack/sheet/bluespace_crystal
	// bananium specific stuff
	var/bananium_initial_amount = 0
	var/bananium_slot = 2 // going double bananium won't hurt, I promise
	var/bananium_grown_amount = 0

/obj/item/twohanded/required/fuel_rod/material/bluespace/deplete(amount=0.035)
	..()
	if(bananium_initial_amount >= 2 && prob(10))
		playsound(src, pick('sound/items/bikehorn.ogg', 'sound/misc/bikehorn_creepy.ogg'), 50) // HONK
	fuel_power = max(og_fuel_power - (depletion - 100) / 500, 0)

/obj/item/twohanded/required/fuel_rod/material/bluespace/Final_Depletion()
	..()
	name = "Fully Grown Bluespace Crystal Fuel Rod"
	desc = "A heavy-duty low-grade fuel rod which fissiles much slower than standard counterparts. Its growth stage has finished, and its power now starts to wane. You also can harvest bluespace crystals which should've been multiplied by now."
	if (bananium_initial_amount)
		icon_state = "bluespace_bananium"
	else
		icon_state = "bluespace_used"
	rad_strength *= 5
	og_fuel_power *= 2  
	AddComponent(/datum/component/radioactive, rad_strength, src) // Rads only go up

/obj/item/twohanded/required/fuel_rod/material/bluespace/proc/update_stats()
	multiplier = 3 + bananium_initial_amount
	og_fuel_power = 0.05 + initial_amount * 0.01 // 0.2 would be high-end cases
	rad_strength = 200 + bananium_initial_amount * 100 + initial_amount * 10
	if(!grown)
		fuel_power = og_fuel_power

/obj/item/twohanded/required/fuel_rod/material/bluespace/expend()
	..()
	icon_state = "bluespace_harvested"
	update_stats() // Return to baseline

/obj/item/twohanded/required/fuel_rod/material/bluespace/attackby(obj/item/W, mob/user, params)
	if(istype(W, istype(W, /obj/item/stack/ore/bluespace_crystal)))
		// Common message
		if(!check_material_input(user))
			return
		// Bluespace crystal specific messages
		if(istype(W, /obj/item/stack/ore/bluespace_crystal/artificial))
			to_chat(user, "<span class='warning'>Artificial bluespace crystals won't work, sadly.</span>")
			return
		if(!istype(W, /obj/item/stack/ore/bluespace_crystal/refined) && istype(W, /obj/item/stack/ore/bluespace_crystal))
			to_chat(user, "<span class='warning'>Unrefined bluespace crystals won't work, sadly.</span>")
			return
		// Why is single refined bluespace crystal a different item??!?
		var/obj/item/stack/ore/bluespace_crystal/refined/C = W

		if(istype(C))
			if(initial_amount < max_initial_amount)
				icon_state = "bluespace_ready"
				initial_amount++
				qdel(C)
				update_stats()
				to_chat(user, "<span class='notice'>You insert single bluespace crystal into \the [src].</span>")
			else
				to_chat(user, "<span class='warning'>\The [src]'s material slots are full!</span>")
		return
	else if(istype(W, /obj/item/stack/sheet/mineral/bananium))
		// Common message
		if(!check_material_input(user))
			return
		var/obj/item/stack/C = W

		if(bananium_initial_amount < bananium_slot)
			var/adding = 0
			adding = min(bananium_slot - bananium_initial_amount, C.amount)
			C.amount -= adding
			bananium_initial_amount += adding
			C.zero_amount()
			update_stats()
			to_chat(user, "<span class='notice'>You manage to slide [adding] bananium sheets into \the [src]. What could go wrong?</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] looks unable to hold more bananium!</span>")
	else
		. = ..()
		update_stats()
		if(initial_amount)
			icon_state = "bluespace_ready"

/obj/item/twohanded/required/fuel_rod/material/bluespace/attack_self(mob/user)
	..()
	if(!initial_amount)
		icon_state = "bluespace"
	if(grown)
		if(bananium_grown_amount)
			var/obj/item/stack/sheet/mineral/bananium/ba = new(get_turf(user))
			var/output = min(bananium_grown_amount, ba.max_amount)
			to_chat(user, "<span class='notice'>You harvest [output] sheets of bananium from \the [src].</span>")
			ba.amount = output
			bananium_grown_amount -= output
	else if(bananium_initial_amount)
		var/obj/item/stack/sheet/mineral/bananium/ba = new(get_turf(user))
		var/output = min(bananium_initial_amount, ba.max_amount)
		to_chat(user, "<span class='notice'>You remove [output] sheets of bananium from \the [src].</span>")
		ba.amount = output
		bananium_initial_amount -= output

/obj/item/twohanded/required/fuel_rod/material/bluespace/examine(mob/user)
	. = ..()
	if(bananium_initial_amount)
		if(grown)
			. += "<span class='warning'>... and [bananium_grown_amount] sheets of bananium.</span>"
			return
		. += "<span class='disarm'>[bananium_initial_amount]/[bananium_slot] of the bananium \"slots\" are full.</span>"