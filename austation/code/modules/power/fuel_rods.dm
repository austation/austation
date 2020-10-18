/obj/item/twohanded/required/fuel_rod
	var/conversion = "plutonium"// what does this rod convert to when depleted?
	var/rad_strength = 500
	var/half_life = 2000 // how many depletion ticks are needed to half the fuel_power (1 tick = 1 second)
	var/time_created = 0
	var/og_fuel_power = 0.20 //the original fuel power value

	// TC rod only vars (yes I know, slight shitcode having them stored here but I don't want to make another proc for tc rods)
	var/grown = FALSE // has the rod fissiled enough for us to remove the grown TC?
	var/percentage = 0 //progress towards tc transmutation in percentage

/obj/item/twohanded/required/fuel_rod/New()
	..()
	time_created = world.time
	AddComponent(/datum/component/radioactive, rad_strength, src)
	if(process)
		START_PROCESSING(SSobj, src)
	. = ..()

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

/obj/item/twohanded/required/fuel_rod/deplete(amount=0.035) // override for the one in rmbk.dm
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/N = loc // store the reactor we're inside of in a var
	depletion += amount
	if(conversion == "telecrystal")
		percentage = min(((depletion - 65) / 35) * 100, 1)
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
						var/obj/item/twohanded/required/fuel_rod/depleted/D = new(loc)
						D.depletion = depletion
						N.fuel_rods += D
						qdel(src)

	else
		fuel_power = 0.10

/obj/item/twohanded/required/fuel_rod/telecrystal/attackby(obj/item/W, mob/user, params)
	var/obj/item/stack/telecrystal/M = W
	if(istype(M))
		if(depletion >= 10)
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
