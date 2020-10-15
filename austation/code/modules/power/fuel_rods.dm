/obj/item/twohanded/required/fuel_rod/telecrystal
	name = "Telecrystal Fuel Rod"
	desc = "A disguised titanium sheathed rod containing a measure of small telecrystals slots infused with uranium dioxide, can be inserted with telecrystals to grow more. Fissiles much faster than it's uranium counterpart"
	icon_state = "telecrystal"
	fuel_power = 0.20 // twice as powerful as a normal rod, you're going to need some engineering autism if you plan to mass produce TC
	var/telecrystal_amount = 0 // amount of telecrystals inside the rod?
	var/max_telecrystal_amount = 8 // the max amount of TC that can be in the rod?
	var/grown = FALSE // has the rod fissiled enough for us to remove the grown TC?
	var/expended = FALSE // have we removed the TC already?
	var/multiplier = 3 // how much do we multiply the inserted TC by?


/obj/item/twohanded/required/fuel_rod/telecrystal/deplete(amount=0.035)
	depletion += amount
	if(depletion >= 40)
		fuel_power = 0.40 // twice as powerful as plutonium, you'll want to get this one out quick!
		name = "Exhausted Telecrystal Fuel Rod"
		desc = "A highly energetic disguised titanium sheathed rod containing a sizeable measure of telecrystal slots which can be removed by hand, it's extremely efficient as nuclear fuel, but will cause the reaction to get out of control if not properly utilised."
		icon_state = "telecrystal_used"
		grown = TRUE
	else
		fuel_power = 0.20

/obj/item/twohanded/required/fuel_rod/telecrystal/attackby(obj/item/W, mob/user, params)
	if(depletion >= 10)
		to_chat(user, "<span class='warning'> The sample slots have sealed themselves shut, it's too late to add crystals now!</span>") // no cheesing in crystals at 100%
		return

	if(!expended) // can't add crystals to a used rod!
		if(istype(W, /obj/item/stack/telecrystal))
			var/obj/item/stack/telecrystal/M = W
			if(M.amount + telecrystal_amount >= max_telecrystal_amount) // does adding this many crystals push us over the capacity?
				var/added_amount = min(M.amount, max_telecrystal_amount - telecrystal_amount)
				M.amount -= added_amount
				telecrystal_amount += added_amount
				to_chat(user, "<span class='notice'> You insert [added_amount] telecrystals into the [src].</span>")
				if(M.amount <= 0)
					qdel(M)
			else
				to_chat(user, "<span class='warning'> The sample slots are full!</span>")

	else
		to_chat(user, "<span class='warning'> The [src]'s material slots have already been used.</span>")

/obj/item/twohanded/required/fuel_rod/telecrystal/attack_self(mob/user)
	if(expended)
		to_chat(user, "<span class='notice'> You have already removed the telecrystals from the [src].</span>")
		return

	if(grown)
		to_chat(user, "<span class='notice'> You remove [telecrystal_amount] telecrystals from the [src].</span>")
		var/obj/item/stack/telecrystal/tc = new(get_turf(src))
		tc.amount = round(telecrystal_amount * multiplier, 1)
		expended = TRUE
		telecrystal_amount = 0
		return

	else
		to_chat(user, "<span class='warning'> The [src] has not fissiled enough to fully grow the sample. the progress bar shows it is [min(depletion / 40 * 100, 100)]% complete. </span>")

/obj/item/twohanded/required/fuel_rod/telecrystal/examine(mob/user)
	. = ..()
	if(expended)
		. += "<span class='warning'>The material slots have been removed.</span>"
		return
	if(depletion)
		. += "<span class='danger'>The sample is [min(depletion / 40 * 100, 100)]% fissiled.</span>"

	. += "<span class='disarm'>[telecrystal_amount]/[max_telecrystal_amount] of the telecrystal slots are full.</span>"
