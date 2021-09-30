/obj/item/toy/crayon/attack(mob/M, mob/user)
	if(M.job == "Clown" && istype(src, /obj/item/toy/crayon/rainbow))
		to_chat(user, "That's my favourite crayon! Rainbow crayons are friends, not food...")
		return
	.=..()
