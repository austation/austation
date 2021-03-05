/obj/item/tank
  var/no_rupture = FALSE

/obj/item/tank/check_status()
  if(no_rupture == TRUE)
    return 0
  ..()
