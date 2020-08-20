/datum/wires/reflector
	holder_type = /obj/structure/reflector

/datum/wires/reflector/New(atom/holder)
  wires = list(WIRE_HACK, WIRE_DISABLE,WIRE_SHOCK, WIRE_ZAP)
  ..()

/datum/wires/reflector/on_pulse(wire)
  var/obj/structure/reflector/E = holder
  switch(wire)
    if(WIRE_HACK)
      E.setAngle(SIMPLIFY_DEGREES(1+E.rotation_angle))
    if(WIRE_DISABLE)
      E.setAngle(SIMPLIFY_DEGREES(-1+E.rotation_angle))
    if(WIRE_SHOCK)
      E.setAngle(SIMPLIFY_DEGREES(10+E.rotation_angle))
    if(WIRE_ZAP)
      E.setAngle(SIMPLIFY_DEGREES(-10+E.rotation_angle))
  ..()
