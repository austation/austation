/obj/item/twohanded/required/fuel_rod
	var/conversion = "plutonium"// what does this rod convert to when depleted?
	var/rad_strength = 500
	var/half_life = 2000 // how many depletion ticks are needed to half the fuel_power (1 tick = 1 second)
	var/time_created = 0
	var/og_fuel_power = 0.20 //the original fuel power value
	var/process =  FALSE

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

/obj/item/twohanded/required/fuel_rod/plutonium
	fuel_power = 0.20
	name = "Plutonium-239 Fuel Rod"
	desc = "A highly energetic titanium sheathed rod containing a sizeable measure of weapons grade plutonium, it's highly efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
	icon_state = "inferior"
	conversion = "depleted"
	rad_strength = 1500
	process = TRUE // for half life code

/obj/item/twohanded/required/fuel_rod/plutonium/process()
	fuel_power = og_fuel_power * 0.5**((world.time - time_created) / half_life SECONDS) // halves the fuel power every half life (33 minutes)

/obj/item/twohanded/required/fuel_rod/depleted
	name = "Depleted Fuel Rod"
	desc = "A highly radioactive fuel rod which has expended most of it's useful energy."
	icon_state = "normal"
	rad_strength = 6000 // smelly

/obj/item/twohanded/required/fuel_rod/telecrystal
	name = "Telecrystal Fuel Rod"
	desc = "A disguised titanium sheathed rod containing several small slots infused with uranium dioxide. Permits the insertion of telecrystals to grow more. Fissiles much faster than its standard counterpart"
	icon_state = "telecrystal"
	fuel_power = 0.30 // twice as powerful as a normal rod, you're going to need some engineering autism if you plan to mass produce TC
	conversion = "telecrystal"
	depletion = 65 // headstart, otherwise it takes two hours
	rad_strength = 1500
	var/telecrystal_amount = 0 // amount of telecrystals inside the rod?
	var/max_telecrystal_amount = 8 // the max amount of TC that can be in the rod?
	var/expended = FALSE // have we removed the TC already?
	var/multiplier = 3 // how much do we multiply the inserted TC by?

/obj/item/twohanded/required/fuel_rod/bluespace
	name = "Bluespace Crystal Fuel Rod"
	desc = "A heavy-duty low-grade fuel rod which fissiles much slower than standard counterparts. However, it's complex and sophisticated design allows insertion and utilisation of a certain material with special properties, namely bluespace crystals."
	icon_state = "bluespace"
	fuel_power = 0.05 // bluespace growth shouldn't be *that* interesting, isn't it?
	conversion = "bluespace"
	depletion = 50
	rad_strength = 200
	og_fuel_power = 0.05
	var/bluespace_crystal_initial_amount = 0
	var/bluespace_crystal_slot = 15 // I dare you to insert *this* many
	var/bluespace_crystal_grown_amount = 0
	var/bananium_initial_amount = 0
	var/bananium_slot = 2 // going double bananium won't hurt, I promise
	var/bananium_grown_amount = 0
	var/growth_factor = 3
	var/expended = FALSE

/obj/item/twohanded/required/fuel_rod/deplete(amount=0.035) // override for the one in rmbk.dm
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/N = loc // store the reactor we're inside of in a var
	depletion += amount
	if(conversion == "telecrystal")
		percentage = min(((depletion - 65) / 35) * 100, 1)
	if(conversion == "bluespace" && rad_strength > 300 && prob(10))
		playsound(src, pick('sound/items/bikehorn.ogg', 'sound/misc/bikehorn_creepy.ogg'), 50) // HONK
	if(depletion >= 100)
		switch(conversion)
			if("plutonium") // uranium rod turns into a different object for cargo reasons.
				if(istype(N))
					var/obj/item/twohanded/required/fuel_rod/plutonium/P = new(loc)
					P.depletion = depletion
					N.fuel_rods += P
					qdel(src)

			if("telecrystal") // telecrystal rod turns into processed telecrystal rod
				fuel_power = 0.60 // thrice as powerful as plutonium, you'll want to get this one out quick!
				name = "Exhausted Telecrystal Fuel Rod"
				desc = "A highly energetic, disguised titanium sheathed rod containing a number of slots filled with greatly expanded telecrystals which can be removed by hand. It's extremely efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
				icon_state = "telecrystal_used"
				grown = TRUE
				AddComponent(/datum/component/radioactive, 3000, src)

			if("depleted") // plutonium rod turns into depleted fuel rod

				if(fuel_power < 10 || depletion >= 300) // you can also get depleted fuel with enough nitryl
					fuel_power = 0
					playsound(loc, 'sound/effects/supermatter.ogg', 100, TRUE)
					if(istype(N))
						var/obj/item/twohanded/required/fuel_rod/depleted/D = new(loc)
						D.depletion = depletion
						N.fuel_rods += D
						qdel(src)

			if("bluespace") // telecrystal rod turns into processed telecrystal rod
				if(!grown)
					name = "Fully Grown Bluespace Crystal Fuel Rod"
					desc = "A heavy-duty low-grade fuel rod which fissiles much slower than standard counterparts. Its growth stage has finished, and its power now starts to wane. You also can harvest bluespace crystals which should've been multiplied by now."
					if (rad_strength > 200)
						icon_state = "bluespace_bananium"
					else
						icon_state = "bluespace_used"
					grown = TRUE
					rad_strength *= 5
					og_fuel_power *= 2  
				AddComponent(/datum/component/radioactive, rad_strength, src)
				fuel_power = max(og_fuel_power - (depletion - 100) / 500, 0)

	else
		fuel_power = 0.10

/obj/item/twohanded/required/fuel_rod/telecrystal/attackby(obj/item/W, mob/user, params)
	var/obj/item/stack/telecrystal/M = W
	if(istype(M))
		if(depletion >= 75)
			to_chat(user, "<span class='warning'>The sample slots have sealed themselves shut, it's too late to add crystals now!</span>") // no cheesing in crystals at 100%
			return
		if(expended)
			to_chat(user, "<span class='warning'>\The [src]'s material slots have already been used.</span>")
			return

		if(telecrystal_amount < max_telecrystal_amount)
			var/adding = 0
			if(M.amount <= max_telecrystal_amount - telecrystal_amount)
				adding = M.amount
			else
				adding = max_telecrystal_amount - telecrystal_amount
			adding = min((max_telecrystal_amount - telecrystal_amount), M.amount)
			M.amount -= adding
			telecrystal_amount += adding
			M.zero_amount()
			to_chat(user, "<span class='notice'>You insert [adding] telecrystals into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src]'s material slots are full!</span>")
			return
	else
		return ..()

/obj/item/twohanded/required/fuel_rod/telecrystal/attack_self(mob/user)
	if(expended)
		to_chat(user, "<span class='notice'>You have already removed the telecrystals from the [src].</span>")
		return

	if(grown)
		var/profit = round(telecrystal_amount * multiplier, 1)
		to_chat(user, "<span class='notice'>You remove [profit] telecrystals from the [src].</span>")
		var/obj/item/stack/telecrystal/tc = new(get_turf(src))
		tc.amount = profit
		expended = TRUE
		telecrystal_amount = 0
		return

	else
		to_chat(user, "<span class='warning'>\The [src] has not fissiled enough to fully grow the sample. The progress bar shows it is [percentage]% complete.</span>")

/obj/item/twohanded/required/fuel_rod/telecrystal/examine(mob/user)
	. = ..()
	if(expended)
		. += "<span class='warning'>The material slots have been slagged by the extreme heat, you can't grow crystals in this rod again...</span>"
		return
	if(depletion)
		. += "<span class='danger'>The sample is [percentage]% fissiled.</span>"

	. += "<span class='disarm'>[telecrystal_amount]/[max_telecrystal_amount] of the telecrystal slots are full.</span>"

/obj/item/twohanded/required/fuel_rod/bluespace/proc/update_stats()
	growth_factor = 3 + bananium_initial_amount
	og_fuel_power = 0.05 + bluespace_crystal_initial_amount * 0.01 // 0.2 would be high-end cases
	rad_strength = 200 + bananium_initial_amount * 100
	if(!grown)
		fuel_power = og_fuel_power

/obj/item/twohanded/required/fuel_rod/bluespace/proc/expend()
	expended = TRUE
	icon_state = "bluespace_harvested"
	update_stats() // Return to baseline

/obj/item/twohanded/required/fuel_rod/bluespace/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/sheet/bluespace_crystal) || istype(W, /obj/item/stack/ore/bluespace_crystal))
		if(istype(W, /obj/item/stack/ore/bluespace_crystal/artificial))
			to_chat(user, "<span class='warning'>Artificial bluespace crystals won't work, sadly.</span>")
			return
		if(!istype(W, /obj/item/stack/ore/bluespace_crystal/refined) && istype(W, /obj/item/stack/ore/bluespace_crystal))
			to_chat(user, "<span class='warning'>Unrefined bluespace crystals won't work, sadly.</span>")
			return
		if(grown)
			to_chat(user, "<span class='warning'>\The [src]'s life is over. No point in adding more crystals now.</span>")
			return
		if(depletion >= 60)
			to_chat(user, "<span class='warning'>Markers indicate that adding more bluespace crystals now is not safe, it's too late to add crystals now!</span>") // no cheesing in crystals at 100%
			return
		var/obj/item/stack/C = W

		if(bluespace_crystal_initial_amount < bluespace_crystal_slot)
			icon_state = "bluespace_ready"
			var/adding = 0
			adding = min(bluespace_crystal_slot - bluespace_crystal_initial_amount, C.amount)
			C.amount -= adding
			bluespace_crystal_initial_amount += adding
			C.zero_amount()
			update_stats()
			if(bluespace_crystal_initial_amount < 10)
				to_chat(user, "<span class='notice'>You insert [adding] bluespace crystals into \the [src].</span>")
			else
				to_chat(user, "<span class='warning'>You insert [adding] bluespace crystals into \the [src], but an inbuilt sensor indicates that it is reaching not-very-safe levels.</span>")
		else
			to_chat(user, "<span class='warning'>\The [src]'s bluespace crystal slots are full!</span>")
			return
	else if(istype(W, /obj/item/stack/sheet/mineral/bananium))
		if(grown)
			to_chat(user, "<span class='warning'>\The [src]'s life is over. No point in adding more bananium now.</span>")
			return
		if(depletion >= 60)
			to_chat(user, "<span class='warning'>Markers indicate that adding something more now is not safe, it's too late to add something now!</span>") // no cheesing in crystals at 100%
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
		return ..()

/obj/item/twohanded/required/fuel_rod/bluespace/attack_self(mob/user)
	if(expended)
		to_chat(user, "<span class='warning'>This rod has already been harvested!</span>")
		return
	if(grown)
		if(!bluespace_crystal_grown_amount && !bananium_grown_amount)
			bluespace_crystal_grown_amount = bluespace_crystal_initial_amount * growth_factor
			bananium_grown_amount = bananium_initial_amount * 2
		if(bluespace_crystal_grown_amount)
			var/obj/item/stack/sheet/bluespace_crystal/bc = new(get_turf(user))
			var/output = min(bluespace_crystal_grown_amount, bc.max_amount)
			to_chat(user, "<span class='notice'>You harvest [output] bluespace crystals from \the [src].</span>")
			bc.amount = output
			bluespace_crystal_grown_amount -= output
			if(!bluespace_crystal_grown_amount && !bananium_grown_amount)
				expend()
			return
		if(bananium_grown_amount)
			var/obj/item/stack/sheet/mineral/bananium/ba = new(get_turf(user))
			var/output = min(bananium_grown_amount, ba.max_amount)
			to_chat(user, "<span class='notice'>You harvest [output] sheets of bananium from \the [src].</span>")
			ba.amount = output
			bananium_grown_amount -= output
			if(!bananium_grown_amount)
				expend()
			return
		// No material input case goes here
		to_chat(user, "<span class='warning'>Nothing can be harvested from \the [src]!</span>")
		expend()
		
	else
		var/didsomething = FALSE
		if(bluespace_crystal_initial_amount)
			var/obj/item/stack/sheet/bluespace_crystal/bc = new(get_turf(user))
			var/output = min(bluespace_crystal_initial_amount, bc.max_amount)
			to_chat(user, "<span class='notice'>You remove [output] bluespace crystals from \the [src].</span>")
			bc.amount = output
			bluespace_crystal_initial_amount -= output
			didsomething = TRUE
			icon_state = "bluespace"
		if(bananium_initial_amount)
			var/obj/item/stack/sheet/mineral/bananium/ba = new(get_turf(user))
			var/output = min(bananium_initial_amount, ba.max_amount)
			to_chat(user, "<span class='notice'>You remove [output] sheets of bananium from \the [src].</span>")
			ba.amount = output
			bananium_initial_amount -= output
			didsomething = TRUE
		if(!didsomething)
			to_chat(user, "<span class='warning'>Nothing can be removed from \the [src]!</span>")

/obj/item/twohanded/required/fuel_rod/bluespace/examine(mob/user)
	. = ..()
	if(expended)
		. += "<span class='warning'>This fuel rod has been fully harvested.</span>"
	else if(grown)
		if(bluespace_crystal_grown_amount || bananium_grown_amount)
			. += "<span class='warning'>This fuel rod is undergoing a process of bluespace crystal harvesting, and it currently has [bluespace_crystal_grown_amount] bluespace crystals.</span>"
			if(bananium_initial_amount)
				. += "<span class='warning'>... and [bananium_grown_amount] sheets of bananium.</span>"
		else if(bluespace_crystal_initial_amount)
			. += "<span class='warning'>This fuel rod's bluespace crystals are now fully grown, and it currently bears harvestable bluespace crystals.</span>"
			if(bananium_initial_amount)
				. += "<span class='warning'>... and a few sheets of bananium.</span>"
		else if(bananium_initial_amount)
			. += "<span class='warning'>This rod shows unusual growth of strange material with hilarious properties.</span>"
		else
			. += "<span class='warning'>This rod somehow seems to lack bluespace crystal growth. Bluespace crystals aren't likely be produced here.</span>"
	else
		. += "<span class='disarm'>[bluespace_crystal_initial_amount]/[bluespace_crystal_slot] of the bluespace crystal slots are full.</span>"
		if (bananium_initial_amount)
			. += "<span class='disarm'>[bananium_initial_amount]/[bananium_slot] of the bananium \"slots\" are full.</span>"
