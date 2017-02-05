@LAZYGLOBAL off.
run lib_navball.ks.txt.

//makes appropriate manuevers to get ship to specified circular orbit given desired altitude
//WARNING: ONLY WORKS WHEN SHIP IS IN STABLE, STEADY ORBIT WHERE 5 MINUTES OF PREP CAN BE GIVEN BEFORE BURN
//WARNING: DO NOT USE TO CIRCULARIZE INITIAL ASCENT ORBIT
declare function set_orbit_circ
{
	parameter des_alt.
	local ap to ship:apoapsis.
	local pe to ship:periapsis.
	if ap < des_alt and pe < des_alt //burns twice to increase periapsis and apoapsis to desired altitude
	{
		if((eta:apoapsis < eta:periapsis and eta:apoapsis > 300) or (eta:apoapsis > eta:periapsis and eta:periapsis < 300))
		{
			local node_height to ship:apoapsis.
			local prograde to 0.1. //how much the prograde will be increased each time a new solution is tried
			local difference to 0.
			local old_node1_ap to pe.
			global node1 to node((time:seconds + eta:apoapsis), 0, 0, prograde).
			add node1.
			until node1:orbit:apoapsis >= des_alt - (difference / 2)
			{
				set old_node1_ap to node1:orbit:apoapsis.
				remove node1.
				global node1 to node((time:seconds + eta:apoapsis), 0, 0, prograde).
				set prograde to prograde + 0.1.
				add node1.
				set difference to node1:orbit:apoapsis - old_node1_ap.
			}
		}
		else
		{
			local node_height to ship:apoapsis.
			local prograde to 0.1. //how much the prograde will be increased each time a new solution is tried
			local difference to 0.
			local old_node1_ap to ap.
			global node1 to node(timenode - time:seconds, 0, 0, prograde).
			add node1.
			until node1:orbit:apoapsis >= des_alt - (difference / 2)
			{
				set old_node1_ap to node1:orbit:apoapsis.
				remove node1.
				global node1 to node(timenode - time:seconds, 0, 0, prograde).
				set prograde to prograde + 0.1.
				add node1.
				set difference to node1:orbit:apoapsis - old_node1_ap.
			}
		}
		execute_node.
	}
	else if ap > des_alt and pe < des_alt //burns twice to decrease apoapsis and increase periapsis to desired altitude
	{
		
	}
	else //both periapsis and apoapsis are above desired altitude, so both are lowered to achieve it
	{
		
	}
}

declare function circularize//meant to be called once
{
	local done to false.
	local node_height to ship:apoapsis.
	local prograde to 0.1.
	local min to ship:orbit:eccentricity.
	local node_circle to node((time:seconds + eta:apoapsis), 0, 0, prograde).
	add node_circle.
	until done
	{
		remove node_circle.
		set node_circle to node((time:seconds + eta:apoapsis), 0, 0, prograde).
		add node_circle.
		if node_circle:orbit:eccentricity < min
		{
			set min to node_circle:orbit:eccentricity.
			set prograde to prograde + 0.1.
		}
		else
		{
			remove node_circle.
			set node_circle to node((time:seconds + eta:apoapsis), 0, 0, prograde - 0.1).
			add node_circle.
			set done to true.
		}
	}
	return node_circle.
}

declare function transmun
{
	local timenode to time:seconds + 300.
	local node_transmun to node(timenode, 0, 0, 842).
	add node_transmun.
	if node_transmun:orbit:hasnextpatch
	{
		remove node_transmun.
		set timenode to timenode + 960.
		set node_transmun to node(timenode, 0, 0, 842).
		add node_transmun.
	}
	until node_transmun:orbit:hasnextpatch
	{
		remove node_transmun.
		set node_transmun to node(timenode, 0, 0, 842).
		add node_transmun.
		set timenode to timenode + 5.
	}
	until node_transmun:orbit:nextpatch:periapsis <= 30000
	{
		remove node_transmun.
		set node_transmun to node(timenode, 0, 0, 842).
		add node_transmun.
		set timenode to timenode + 1.
	}
	until node_transmun:orbit:nextpatch:periapsis >= 30000
	{
		remove node_transmun.
		set node_transmun to node(timenode, 0, 0, 842).
		add node_transmun.
		set timenode to timenode - 0.1.
	}
	return node_transmun.
}

declare function correct1
{
	local timenode to time:seconds + 300.
	local node_correct1 to node(timenode, 0, 0, 0).
	add node_correct1.
	local radial to 0.
	if ship:periapsis < 30000
	{
		until node_correct1:orbit:periapsis >= 30000
		{
			remove node_correct1.
			set node_correct1 to node(timenode, radial, 0, 0).
			add node_correct1.
			set radial to radial + 0.1.
		}
	}
	else
	{
		until node_correct1:orbit:periapsis <= 30000
		{
			remove node_correct1.
			set node_correct1 to node(timenode, radial, 0, 0).
			add node_correct1.
			set radial to radial - 0.1.
		}
	}
	return node_correct1.
}

declare function circularize_noinc //helps to circularize and 0 inclination by creating node at the periapsis
{
	parameter type.
	
	local done to false.
	local timenode to 0.
	local radial to 0.
	local normal to 0.
	local prograde to 0.
	local node_gen to node(timenode, radial, normal, prograde).
	add node_gen.
	if type = "ap"
	{
		set timenode to time:seconds + eta:apoapsis.
	}
	else if type = "pe"
	{
		set timenode to time:seconds + eta:periapsis.
	}
	else if type = "nd"
	{
		set timenode to time:seconds + 240.
		remove node_gen.
		set node_gen to node(timenode, radial, 0.1, prograde).
		add node_gen.
		local i0 to node_gen:orbit:inclination.
		set timenode to timenode + 1.
		remove node_gen.
		set node_gen to node(timenode, radial, 0.1, prograde).
		add node_gen.
		local i1 to node_gen:orbit:inclination.
		local diffdiff to (abs(i1 - ship:orbit:inclination) - abs(i0 - ship:orbit:inclination)).
		local diff to 0.
		local max to 0.
		local min to 180.
		if diffdiff > 0 //node is less than 90 degrees from ascending or descending node
		{
			until done
			{
				print "FIRST LOOP" at (0, 33).
				remove node_gen.
				set node_gen to node(timenode, radial, 0.1, prograde).
				add node_gen.
				set i1 to node_gen:orbit:inclination.
				set diff to abs(i1 - ship:orbit:inclination).
				if diff > max
				{
					set max to diff.
					set timenode to timenode + 1.
				}
				else
				{
					remove node_gen.
					set timenode to timenode - 1.
					set node_gen to node(timenode, radial, radial, prograde).
					add node_gen.
					set done to true.
				}
			}
		}
		else //node is greater than 90 degrees from ascending or descending node
		{
			until done
			{
				remove node_gen.
				set node_gen to node(timenode, radial, 0.1, prograde).
				add node_gen.
				set i1 to node_gen:orbit:inclination.
				set diff to abs(i1 - ship:orbit:inclination).
				if diff < min
				{
					set min to diff.
					set timenode to timenode + 10.
					print "MIN IF" at (0, 33).
				}
				else
				{
					set done to true.
				}
			}
			set done to false.
			until done
			{
				remove node_gen.
				set node_gen to node(timenode, radial, 0.1, prograde).
				add node_gen.
				set i1 to node_gen:orbit:inclination.
				set diff to abs(i1 - ship:orbit:inclination).
				if diff > max
				{
					set max to diff.
					set timenode to timenode + 1.
					print "MAX IF" at (0, 33).
				}
				else
				{
					remove node_gen.
					set timenode to timenode - 1.
					set node_gen to node(timenode, radial, radial, prograde).
					add node_gen.
					set done to true.
				}
			}
		}
		set done to false.
	}
	else
	{
		return node(time:seconds, 0, 0, 0).
	}
	local i to 10.
	local minecc to ship:orbit:eccentricity.
	local mininc to ship:orbit:inclination.
	
	until i < 0.001
	{
		set mininc to node_gen:orbit:inclination.
		set normal to normal + i.
		until done //optimizes normal by addition
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:inclination < mininc
			{
				set mininc to node_gen:orbit:inclination.
				set normal to normal + i.
			}
			else
			{
				remove node_gen.
				set normal to normal - i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set normal to normal - i.
		until done //optimizes normal by subtraction
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:inclination < mininc
			{
				set mininc to node_gen:orbit:inclination.
				set normal to normal - i.
			}
			else
			{
				remove node_gen.
				set normal to normal + i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set minecc to node_gen:orbit:eccentricity.
		set prograde to prograde + i.
		until done //optimizes prograde by addition
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:eccentricity < minecc
			{
				set minecc to node_gen:orbit:eccentricity.
				set prograde to prograde + i.
			}
			else
			{
				remove node_gen.
				set prograde to prograde - i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set prograde to prograde - i.
		until done //optimizes prograde by subtraction
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:eccentricity < minecc
			{
				set minecc to node_gen:orbit:eccentricity.
				set prograde to prograde - i.
			}
			else
			{
				remove node_gen.
				set prograde to prograde + i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set radial to radial + i.
		until done //optimizes radial by addition
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:eccentricity < minecc
			{
				set minecc to node_gen:orbit:eccentricity.
				set radial to radial + i.
			}
			else
			{
				remove node_gen.
				set radial to radial - i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set radial to radial - i.
		until done //optimizes radial by subtraction
		{
			remove node_gen.
			set node_gen to node(timenode, radial, normal, prograde).
			add node_gen.
			if node_gen:orbit:eccentricity < minecc
			{
				set minecc to node_gen:orbit:eccentricity.
				set radial to radial - i.
			}
			else
			{
				remove node_gen.
				set radial to radial + i.
				set node_gen to node(timenode, radial, normal, prograde).
				add node_gen.
				set done to true.
			}
		}
		set done to false.
		set i to i / 10.
	}
	return node_gen.
}

declare function deorbitmm
{
	local timenode to time:seconds + (ship:orbit:period / 2).
	local node_deorbitmm to node(timenode, 0, 0, 0).
	add node_deorbitmm.
	local prograde to 0.
	until node_deorbitmm:orbit:periapsis <= 12000
	{
		remove node_deorbitmm.
		set node_deorbitmm to node(timenode, 0, 0, prograde).
		add node_deorbitmm.
		set prograde to prograde - 0.1.
	}
	return node_deorbitmm.
}

declare function execute_node_s2
{
	parameter node1.
	parameter run.
	parameter canexecute.
	
	
	if get_burn_time(node1) = 0
	{
		return true.
	}
	local time_start to time:seconds + node1:eta - (get_burn_time(node1) / 2).
	
	lock steering to node1:deltav.
	if run = 0
	{
		sas off.
		rcs on.
		return false.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= 1 and run = 1 //ends burn
	{
		lock throttle to 0.
		sas on.
		unlock steering.
		return true.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= (ship:maxthrust / ship:mass) * 0.5 and run = 1 and canexecute //slows down burn
	{
		lock throttle to 0.075.
		return false.
	}
	else if time:seconds >= time_start and run = 1 and canexecute //begins burn
	{
		lock throttle to 1.
		return false.
	}
}

declare function execute_node_cmmm
{
	parameter node1.
	parameter run.
	parameter canexecute.
	
	if get_burn_time(node1) = 0
	{
		return true.
	}
	local time_start to time:seconds + node1:eta - (get_burn_time(node1) / 2).
	
	lock steering to node1:deltav.
	if run = 0
	{
		sas off.
		return false.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= 0.2 and run = 1 //ends burn
	{
		lock throttle to 0.
		sas on.
		unlock steering.
		return true.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= (ship:maxthrust / ship:mass) * 0.5 and run = 1 and canexecute //slows down burn
	{
		lock throttle to 0.1.
		return false.
	}
	else if time:seconds >= time_start and run = 1 and canexecute //begins burn
	{
		lock throttle to 1.
		return false.
	}
}

declare function execute_node_mm
{
	parameter node1.
	parameter run.
	parameter canexecute.
	
	if get_burn_time(node1) = 0
	{
		return true.
	}
	local time_start to time:seconds + node1:eta - (get_burn_time(node1) / 2).
	
	lock steering to node1:deltav.
	if run = 0
	{
		sas off.
		return false.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= 0.2 and run = 1 //ends burn
	{
		lock throttle to 0.
		sas on.
		unlock steering.
		return true.
	}
	else if time:seconds >= time_start and node1:deltav:mag <= (ship:maxthrust / ship:mass) * 0.5 and run = 1 and canexecute //slows down burn
	{
		lock throttle to 0.1.
		return false.
	}
	else if time:seconds >= time_start and run = 1 and canexecute //begins burn
	{
		lock throttle to 1.
		return false.
	}
}

declare function get_burn_time //duration of the burn. ASSUMES ALL ENGINES OF THE SAME TYPE!
{
	parameter n. //node
	local real_isp to 0.
	local englist is list().
	list engines in englist.
	for eng in englist
	{
		if eng:ignition = true and eng:flameout = false
		{
			set real_isp to eng:isp.
			break.
		}
	}
	
	local delta_mass to (ship:mass) * 1000 - (ship:mass) * 1000 * constant:e ^ ((-1 * n:deltav:mag) / (real_isp * 9.82)).
	local pps to (ship:availablethrust * 1000) / (real_isp * 9.82). //pps means propellent per second
	if pps = 0
	{
		return 0.
	}
	else
	{
		return delta_mass / pps.
	}
}