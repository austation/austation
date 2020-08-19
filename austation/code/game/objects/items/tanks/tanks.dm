/obj/item/tank
  name = "tank"
  icon = 'icons/obj/tank.dmi'
  lefthand_file = 'icons/mob/inhands/equipment/tanks_lefthand.dmi'
  righthand_file = 'icons/mob/inhands/equipment/tanks_righthand.dmi'
  flags_1 = CONDUCT_1
  slot_flags = ITEM_SLOT_BACK
  hitsound = 'sound/weapons/smash.ogg'
  pressure_resistance = ONE_ATMOSPHERE * 5
  force = 5
  throwforce = 10
  throw_speed = 1
  throw_range = 4
  materials = list(/datum/material/iron = 500)
  actions_types = list(/datum/action/item_action/set_internals)
  armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 30)
  var/datum/gas_mixture/air_contents = null
  var/distribute_pressure = ONE_ATMOSPHERE
  var/integrity = 3
  var/volume = 70
  var/no_rupture = FALSE

/obj/item/tank/check_status()
  if(no_rupture == TRUE)
    return 0
  ..()
