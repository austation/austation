/obj/item/sharpener/bluespace
	name = "bluespace whetstone"
	desc = "A bluespace block that can enhance your weapon, allowing it to phase through space."
	icon = 'austation/icons/obj/kitchen.dmi'
	icon_state = "bsharpener"
	increment = 10
	max = 50
	prefix = "bluespace sharpened"
	requires_sharpness = 0
	var/range_increment = 1 // amount to increase range by

/obj/item/sharpener/bluespace/attackby(obj/item/I, mob/user, params) // yes, I'm overiding the parent code so I don't have to modify the main file, bite me.
	if(used)
		to_chat(user, "<span class='warning'>The sharpening block is too worn to use again!</span>")
		return
	if(I.force >= max || I.throwforce >= max)//no esword sharpening
		to_chat(user, "<span class='warning'>[I] is much too powerful to sharpen further!</span>")
		return
	if(requires_sharpness && !I.sharpness)
		to_chat(user, "<span class='warning'>You can only sharpen items that are already sharp, such as knives!</span>")
		return
	if(istype(I, /obj/item/melee/transforming/energy))
		to_chat(user, "<span class='warning'>You don't think \the [I] will be the thing getting modified if you use it on \the [src]!</span>")
		return
	if(istype(I, /obj/item/twohanded))//some twohanded items should still be sharpenable, but handle force differently. therefore i need this stuff
		var/obj/item/twohanded/TH = I
		if(TH.force_wielded >= max)
			to_chat(user, "<span class='warning'>[TH] is much too powerful to sharpen further!</span>")
			return
		if(TH.wielded)
			to_chat(user, "<span class='warning'>[TH] must be unwielded before it can be sharpened!</span>")
			return
		if(TH.force_wielded > initial(TH.force_wielded))
			to_chat(user, "<span class='warning'>[TH] has already been refined before. It cannot be sharpened further!</span>")
			return
		TH.force_wielded = CLAMP(TH.force_wielded + increment, 0, max)//wieldforce is increased since normal force wont stay
	if(I.force > initial(I.force))
		to_chat(user, "<span class='warning'>[I] has already been refined before. It cannot be sharpened further!</span>")
		return
	user.visible_message("<span class='notice'>[user] sharpens [I] with [src]!</span>", "<span class='notice'>You sharpen [I], making it much more deadly than before.</span>")
	playsound(src, 'sound/items/unsheath.ogg', 25, 1)
	I.sharpness = IS_SHARP_ACCURATE
	I.force = CLAMP(I.force + increment, 0, max)
	I.throwforce = CLAMP(I.throwforce + increment, 0, max)
	I.name = "[prefix] [I.name]"
	I.reach = I.reach += range_increment // the only different line from the parent ahahaa
	name = "worn out [name]"
	desc = "[desc] At least, it used to."
	used = 1
	update_icon()
