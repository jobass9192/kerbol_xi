@LAZYGLOBAL off.
run lib_navball.ks.txt.

declare function print_init
{
	parameter input.
	parameter output.
	print "--------------------------------------------------" at (0, 30).
	print "CPU" at (0, 31).
	print input + output + "                              " at (0, 32).
}

declare function print_systems
{
	parameter input.
	parameter output.
	parameter timelaunch.
	parameter runmode.
	parameter abortmode.
	parameter abortisactive.
	parameter current_action.
	parameter p_seek.
	parameter y_seek.
	parameter r_seek.
	
	print "Clock: " at (0,0).
	if time:seconds < timelaunch
	{
		print "T - " + get_clock(timelaunch - time:seconds) at (0,1).
	}
	else
	{
		print "T + " + get_clock(time:seconds - timelaunch) at (0,1).
	}

	print "Systems" at (20, 0).
	
	print "Runmode: " at (41, 0).
	print runmode  at (41, 1).
	
	print "|" at (13, 0).
	print "|" at (33, 0).
	print "|" at (13, 1).
	print "|" at (33, 1).
	print "--------------------------------------------------" at (0, 2).
	
	print "Current Action: " + current_action at (0, 3).
	
	print "--------------------------------------------------" at (0, 4).
	
	print "Basics" at (5, 5).
	local total_thrust to 0.
	local englist is list().
	list engines in englist.
	for eng in englist
	{
		if eng:ignition = true and eng:flameout = false
		{
			set total_thrust to total_thrust + eng:thrust.
		}
	}
	print "Thrust: " + (round(total_thrust, 1)) at (0, 7).
	if gear
	{
		print "Gear: Down" at (0, 8).
	}
	else
	{
		print "Gear: Up" at (0, 8).
	}
	if ship:partstagged("Tower"):length = 0
	{
		print "Tower: Jett" at (0, 9).
	}
	else
	{
		print "Tower: Atts" at (0, 9).
	}
	
	print "Abort Systems" at (31, 5).
	print "Mode: " + abortmode at (25, 7).
	print "Active: " + abortisactive at (25, 8).
	
	print "|" at (23, 5).
	print "|" at (23, 6).
	print "|" at (23, 7).
	print "|" at (23, 8).
	print "|" at (23, 9).
	print "--------------------------" at (24, 9).
	print "|" at (23, 10).
	print "-----------------------" at (0, 10).
	
	print "Fuel" at (8, 11).
	local totallf to 0.
	local totalox to 0.
	local totalmono to 0.
	//Calculates Liquid Fuel in CM
	local i to 0.
	local lfcm to 0.
	until i >= ship:partstagged("FuelCM"):length
	{
		local j to 0.
		until j >= ship:partstagged("FuelCM")[i]:resources:length
		{
			if ship:partstagged("FuelCM")[i]:resources[j]:name = "LiquidFuel"
			{
				set lfcm to lfcm + ship:partstagged("FuelCM")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "CM LF: " + round(lfcm) at (0, 13).
	set totallf to lfcm.
	//Calculates Oxidizer in CM
	set i to 0.
	local oxcm to 0.
	until i >= ship:partstagged("FuelCM"):length
	{
		local j to 0.
		until j >= ship:partstagged("FuelCM")[i]:resources:length
		{
			if ship:partstagged("FuelCM")[i]:resources[j]:name = "Oxidizer"
			{
				set oxcm to oxcm + ship:partstagged("FuelCM")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "CM OX: " + round(oxcm) at (0, 14).
	set totalox to oxcm.
	//Calculates Mono in CM
	set i to 0.
	local monocm to 0.
	until i >= ship:partstagged("MonoCM"):length
	{
		local j to 0.
		until j >= ship:partstagged("MonoCM")[i]:resources:length
		{
			if ship:partstagged("MonoCM")[i]:resources[j]:name = "MonoPropellant"
			{
				set monocm to monocm + ship:partstagged("MonoCM")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	local j to 0.
	until j >= ship:partstagged("Command Capsule")[0]:resources:length
	{
		if ship:partstagged("Command Capsule")[0]:resources[j]:name = "MonoPropellant"
		{
			set monocm to monocm + ship:partstagged("Command Capsule")[0]:resources[j]:amount.
		}
		set j to j + 1.
	} 
	print "CM Mono: " + round(monocm) at (0, 15).
	set totalmono to monocm.
	//Calculates Liquid Fuel in Second Stage
	set i to 0.
	local lf2 to 0.
	until i >= ship:partstagged("Fuel2"):length
	{
		local j to 0.
		until j >= ship:partstagged("Fuel2")[i]:resources:length
		{
			if ship:partstagged("Fuel2")[i]:resources[j]:name = "LiquidFuel"
			{
				set lf2 to lf2 + ship:partstagged("Fuel2")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "S2 LF: " + round(lf2) at (0, 19).
	set totallf to totallf + lf2.
	//Calculates Oxidizer in Second Stage
	set i to 0.
	local ox2 to 0.
	until i >= ship:partstagged("Fuel2"):length
	{
		local j to 0.
		until j >= ship:partstagged("Fuel2")[i]:resources:length
		{
			if ship:partstagged("Fuel2")[i]:resources[j]:name = "Oxidizer"
			{
				set ox2 to ox2 + ship:partstagged("Fuel2")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "S2 OX: " + round(ox2) at (0, 20).
	set totalox to totalox + ox2.
	//Calculates Mono in Second Stage
	set i to 0.
	local mono2 to 0.
	until i >= ship:partstagged("Mono2"):length
	{
		local j to 0.
		until j >= ship:partstagged("Mono2")[i]:resources:length
		{
			if ship:partstagged("Mono2")[i]:resources[j]:name = "MonoPropellant"
			{
				set mono2 to mono2 + ship:partstagged("Mono2")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "S2 Mono: " + round(mono2) at (0, 21).
	set totalmono to totalmono + mono2.
	//Calculates Liquid Fuel in First Stage
	set i to 0.
	local lf1 to 0.
	until i >= ship:partstagged("Fuel1"):length
	{
		local j to 0.
		until j >= ship:partstagged("Fuel1")[i]:resources:length
		{
			if ship:partstagged("Fuel1")[i]:resources[j]:name = "LiquidFuel"
			{
				set lf1 to lf1 + ship:partstagged("Fuel1")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "S1 LF: " + round(lf1) at (0, 22).
	set totallf to totallf + lf1.
	//Calculates Oxidizer in First Stage
	set i to 0.
	local ox1 to 0.
	until i >= ship:partstagged("Fuel1"):length
	{
		local j to 0.
		until j >= ship:partstagged("Fuel1")[i]:resources:length
		{
			if ship:partstagged("Fuel1")[i]:resources[j]:name = "Oxidizer"
			{
				set ox1 to ox1 + ship:partstagged("Fuel1")[i]:resources[j]:amount.
			}
			set j to j + 1.
		}
		set i to i + 1.
	}
	print "S1 OX: " + round(ox1) at (0, 23).
	set totalox to totalox + ox1.
	
	print "MM LF: " + round(ship:liquidfuel - totallf) at (0, 16).
	print "MM OX: " + round(ship:oxidizer - totalox) at (0, 17).
	print "MM Mono: " + round(ship:monopropellant - totalmono) at (0, 18).
	
	print "Command and Control" at (29, 10).
	if ship:partstagged("Command Capsule Indicator"):length > 0
	{
		if ship:partstagged("Command Capsule Indicator")[0]:getmodule("ModuleLight"):getfield("light status"):tostring() = "Nominal"
		{
			print "CM Wheels On  " at (25, 12).
		}
		else
		{
			print "CM Wheels Off " at (25, 12).
		}
	}
	else
	{
		print "CM Wheels Disc" at (25, 12).
	}
	if ship:partstagged("Munar Lander Capsule Indicator"):length > 0
	{
		if ship:partstagged("Munar Lander Capsule Indicator")[0]:getmodule("ModuleLight"):getfield("light status"):tostring() = "Nominal"
		{
			print "MM Wheels On  " at (25, 13).
		}
		else
		{
			print "MM Wheels Off " at (25, 13).
		}
	}
	else
	{
		 print "MM Wheels Disc" at (25, 13).
	}
	local n to 1.
	until n = 9
	{
		local tag to "RCSCM" + n.
		if ship:partstagged(tag):length > 0
		{
			if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
			{
				print "RCSCM" + n + " On  " at (25, 13 + n).
			}
			else if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
			{
				print "RCSCM" + n + " Arm " at (25, 13 + n).
			}
			else
			{
				print "RCSCM" + n + " Off  " at (25, 13 + n).
			}
		}
		else
		{
			print "RCSCM" + n + " Disc" at (25, 13 + n).
		}
		set n to n + 1.
	}
	set n to 1.
	until n = 5
	{
		local tag to "RCSMM" + n.
		if ship:partstagged(tag):length > 0
		{
			if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
			{
				print "RCSMM" + n + " On  " at (38, 13 + n).
			}
			else if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
			{
				print "RCSMM" + n + " Arm " at (38, 13 + n).
			}
			else
			{
				print "RCSMM" + n + " Off  " at (38, 13 + n).
			}
		}
		else
		{
			print "RCSMM" + n + " Disc" at (38, 13 + n).
		}
		set n to n + 1.
	}
	set n to 1.
	until n = 5
	{
		local tag to "RCSS" + n.
		if ship:partstagged(tag):length > 0
		{
			if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
			{
				print "RCSS" + n + " On  " at (38, 17 + n).
			}
			else if ship:partstagged(tag)[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
			{
				print "RCSS" + n + " Arm " at (38, 17 + n).
			}
			else
			{
				print "RCSS" + n + " Off  " at (38, 17 + n).
			}
		}
		else
		{
			print "RCSS" + n + " Disc" at (38, 17 + n).
		}
		set n to n + 1.
	}
	
	print "|" at (23, 11).
	print "|" at (23, 12).
	print "|" at (23, 13).
	print "|" at (23, 14).
	print "|" at (23, 15).
	print "|" at (23, 16).
	print "|" at (23, 17).
	print "|" at (23, 18).
	print "|" at (23, 19).
	print "|" at (23, 20).
	print "|" at (23, 21).
	print "|" at (23, 22).
	print "--------------------------" at (24, 22).
	print "|" at (23, 23).
	print "|" at (23, 24).
	print "-----------------------" at (0, 24).
	
	print "Electricity" at (31, 23).
	set i to 0.
	local ccbatt to 0.
	if ship:partstagged("Command Capsule"):length > 0
	{
		until i >= ship:partstagged("Command Capsule")[0]:resources:length
		{
			if ship:partstagged("Command Capsule")[0]:resources[i]:name = "ElectricCharge"
			{
				set ccbatt to ship:partstagged("Command Capsule")[0]:resources[i]:amount.
			}
			set i to i + 1.
		}
	}
	print "CC BATT: " + round(ccbatt) at (25, 25).
	set i to 0.
	local cmbatt to 0.
	until i >= ship:partsnamed("batteryPack"):length
	{
		set cmbatt to cmbatt + ship:partsnamed("batteryPack")[i]:resources[0]:amount.
		set i to i + 1.
	}
	if ship:partstagged("FuelCellCM1"):length > 0
	{
		set cmbatt to cmbatt + ship:partstagged("FuelCellCM1")[0]:resources[0]:amount.
		if ship:partstagged("FuelCellCM1")[0]:getmodule("ModuleResourceConverter"):getfield("fuel cell") = "Inactive"
		{
			print "CM FC1: Off " at (38, 25).
		}
		else
		{
			print "CM FC1: On  " at (38, 25).
		}
	}
	else
	{
		print "CM FC1: Disc" at (38, 25).
	}
	if ship:partstagged("FuelCellCM2"):length > 0
	{
		set cmbatt to cmbatt + ship:partstagged("FuelCellCM2")[0]:resources[0]:amount.
		if ship:partstagged("FuelCellCM2")[0]:getmodule("ModuleResourceConverter"):getfield("fuel cell") = "Inactive"
		{
			print "CM FC2: Off " at (38, 26).
		}
		else
		{
			print "CM FC2: On  " at (38, 26).
		}
	}
	else
	{
		print "CM FC2: Disc" at (38, 26).
	}
	print "CM BATT: " + round(cmbatt) at (25, 26).
	set i to 0.
	local mcbatt to 0.
	if ship:partstagged("Munar Lander Capsule"):length > 0
	{
		until i >= ship:partstagged("Munar Lander Capsule")[0]:resources:length
		{
			if ship:partstagged("Munar Lander Capsule")[0]:resources[i]:name = "ElectricCharge"
			{
				set mcbatt to ship:partstagged("Munar Lander Capsule")[0]:resources[i]:amount.
			}
			set i to i + 1.
		} 
	}
	print "MC BATT: " + round(mcbatt) at (25, 27).
	local mmbatt to 0.
	if ship:partstagged("FuelCellMM1"):length > 0
	{
		set mmbatt to ship:partstagged("FuelCellMM1")[0]:resources[0]:amount.
		if ship:partstagged("FuelCellMM1")[0]:getmodule("ModuleResourceConverter"):getfield("fuel cell") = "Inactive"
		{
			print "MM FC1: Off " at (38, 27).
		}
		else
		{
			print "MM FC1: On  " at (38, 27).
		}
	}
	else
	{
		print "MM FC1: Disc" at (38, 27).
	}
	if ship:partstagged("FuelCellMM2"):length > 0
	{
		set mmbatt to mmbatt + ship:partstagged("FuelCellMM2")[0]:resources[0]:amount.
		if ship:partstagged("FuelCellMM2")[0]:getmodule("ModuleResourceConverter"):getfield("fuel cell") = "Inactive"
		{
			print "MM FC2: Off " at (38, 28).
		}
		else
		{
			print "MM FC2: On  " at (38, 28).
		}
	}
	else
	{
		print "MM FC2: Disc" at (38, 28).
	}
	print "MM BATT: " + round(mmbatt) at (25, 28).
	
	print "|" at (23, 25).
	print "|" at (23, 26).
	print "|" at (23, 27).
	print "|" at (23, 28).
	print "|" at (23, 29).
	
	print "Comms" at (8, 25).
	if ship:partstagged("COMM1"):length > 0
	{
		print "Antenna: " + ship:partstagged("COMM1")[0]:getmodule("ModuleDeployableAntenna"):getfield("status") at (0, 27).
	}
	else
	{
		print "Antenna: Disc" at (0, 27).
	}
	
	print "--------------------------------------------------" at (0, 30).
	print "CPU" at (0, 31).
	print input + output + "                              " at (0, 32).
}

declare function print_launch
{
	parameter input.
	parameter output.
	parameter timelaunch.
	parameter runmode.
	parameter abortmode.
	parameter abortisactive.
	parameter current_action.
	parameter p_seek.
	parameter y_seek.
	parameter r_seek.
	print "Clock: " at (0,0).
	if time:seconds < timelaunch
	{
		print "T - " + get_clock(timelaunch - time:seconds) at (0,1).
	}
	else
	{
		print "T + " + get_clock(time:seconds - timelaunch) at (0,1).
	}

	print "Launch and Ascent" at (15, 0).
	
	print "Runmode: " at (41, 0).
	print runmode  at (41, 1).
	
	print "|" at (13, 0).
	print "|" at (33, 0).
	print "|" at (13, 1).
	print "|" at (33, 1).
	print "--------------------------------------------------" at (0, 2).
	
	print "Current Action: " + current_action at (0, 3).
	
	print "--------------------------------------------------" at (0, 4).
	
	print "Primary Flight" at (16, 5).
	print "Pitch: " + round(pitch_for(ship), 2) + "   " at (0, 7).
	print "Altitude: " + round(ship:altitude) + "   " at (25, 7).
	print "Heading: " + round(compass_for(ship), 2) + "   " at (0, 8).
	print "Airspeed: " + round(ship:airspeed, 1) + "   " at (25, 8).
	print "Roll: " + round(round(roll_for(ship)), 2) + "   " + "   " at (0,9).
	print "Vert Speed: " + round(ship:verticalspeed, 1) + "   " at (25, 9).
	
	print "--------------------------------------------------" at (0, 10).
	
	print "Systems" at (5, 11).
	local total_thrust to 0.
	local englist is list().
	list engines in englist.
	for eng in englist
	{
		if eng:ignition = true and eng:flameout = false
		{
			set total_thrust to total_thrust + eng:thrust.
		}
	}
	print "Thrust: " + (round(total_thrust, 1)) at (0, 13).
	print "Fuel:" + round(ship:liquidfuel, 1) at (0, 14).
	if ship:partstagged("Tower"):length = 0
	{
		print "Tower: Jett" at (0, 15).
	}
	else
	{
		print "Tower: Atts" at (0, 15).
	}
	
	print "Orbit" at (33, 11).
	print "Ap: " + round(ship:apoapsis) at (25, 13).
	print "Pe: " + round(ship:periapsis) at (25, 14).
	print "Time to Ap: " + get_clock(eta:apoapsis) + "     " at (25, 15).
	print "Time to Pe: " + get_clock(eta:periapsis) + "     " at (25, 16).
	
	print "|" at (23, 11).
	print "|" at (23, 12).
	print "|" at (23, 13).
	print "|" at (23, 14).
	print "|" at (23, 15).
	print "|" at (23, 16).
	print "--------------------------------------------------" at (0, 17).
	
	print "Autopilot Seeks" at (2, 18).
	print "Pitch Seek: " + round(p_seek, 2) at (0, 20).
	print "Heading Seek: " + round(y_seek, 2) at (0, 21).
	print "Roll Seek: " + round(r_seek, 2) at (0, 22).
	
	print "Abort Systems" at (31, 18).
	print "Mode: " + abortmode at (25, 20).
	print "Active: " + abortisactive at (25, 21).
	
	print "|" at (23, 18).
	print "|" at (23, 19).
	print "|" at (23, 20).
	print "|" at (23, 21).
	print "|" at (23, 22).
	print "--------------------------------------------------" at (0, 23).
	
	print "--------------------------------------------------" at (0, 30).
	print "CPU" at (0, 31).
	print input + output + "                              " at (0, 32).
}

declare function print_orbit
{
	parameter input.
	parameter output.
	parameter timelaunch.
	parameter runmode.
	parameter current_action.
	print "Clock: " at (0,0).
	if time:seconds < timelaunch
	{
		print "T - " + get_clock(timelaunch - time:seconds) at (0,1).
	}
	else
	{
		print "T + " + get_clock(time:seconds - timelaunch) at (0,1).
	}

	print "Orbit" at (21, 0).
	
	print "Runmode: " at (41, 0).
	print runmode  at (41, 1).
	
	print "|" at (13, 0).
	print "|" at (33, 0).
	print "|" at (13, 1).
	print "|" at (33, 1).
	print "--------------------------------------------------" at (0, 2).
	
	print "Current Action: " + current_action at (0, 3).
	
	print "--------------------------------------------------" at (0, 4).
	
	print "Primary Flight" at (16, 5).
	print "Pitch: " + round(pitch_for(ship), 2) + "   " at (0, 7).
	print "Altitude: " + round(ship:altitude) + "   " at (25, 7).
	print "Heading: " + round(compass_for(ship), 2) + "   " at (0, 8).
	print "Orbital Vel: " + round(ship:velocity:orbit:mag, 1) + "   " at (25, 8).
	print "Roll: " + round(round(roll_for(ship)), 2) + "   " at (0,9).
	print "Vert Speed: " + round(ship:verticalspeed, 1) + "   " at (25, 9).
	
	print "--------------------------------------------------" at (0, 10).
	
	print "Orbital Information" at (16, 11).
	print "Ap: " + round(ship:apoapsis) at (0, 13).
	print "Pe: " + round(ship:periapsis) at (0, 14).
	if ship:orbit:transition = "escape" or kuniverse:timewarp:mode = "RAILS"
	{
		print "Time to Ap: N/A" at (0, 15).
		print "Period: N/A" at (25, 15).
	}
	else
	{
		print "Time to Ap: " + get_clock(eta:apoapsis) at (0, 15).
		print "Period: " + get_clock(ship:orbit:period) at (25, 15).
	}
	print "Time to Pe: " + get_clock(eta:periapsis) at (0, 16).
	print "Inc: " + round(ship:orbit:inclination, 3) + "   " at (25, 13).
	print "Ecc: " + round(ship:orbit:eccentricity, 3) + "   " at (25, 14).
	print "Body: " + ship:orbit:body:name at (25, 16).
	
	print "--------------------------------------------------" at (0, 17).
	
	print "Fuel" at (8, 18).
	print "LF: " + round(ship:LiquidFuel) at (0, 20).
	print "OX: " + round(ship:Oxidizer) at (0, 21).
	print "Mono: " + round(ship:MonoPropellant) at (0, 22).
	
	
	print "Command and Control" at (29, 18).
	if ship:partstagged("Command Capsule Indicator"):length > 0
	{
		if ship:partstagged("Command Capsule Indicator")[0]:getmodule("ModuleLight"):getfield("light status"):tostring() = "Nominal"
		{
			print "CM Wheels On  " at (25, 20).
		}
		else
		{
			print "CM Wheels Off " at (25, 20).
		}
	}
	else
	{
		print "CM Wheels Disc" at (25, 20).
	}
	if ship:partstagged("Munar Lander Capsule Indicator"):length > 0
	{
		if ship:partstagged("Munar Lander Capsule Indicator")[0]:getmodule("ModuleLight"):getfield("light status"):tostring() = "Nominal"
		{
			print "MM Wheels On  " at (25, 21).
		}
		else
		{
			print "MM Wheels Off " at (25, 21).
		}
	}
	else
	{
		 print "MM Wheels Disc" at (25, 21).
	}
	if ship:partstagged("RCSCM1"):length > 0
	{
		if ship:partstagged("RCSCM1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
		{
			print "RCSCM On   " at (25, 22).
		}
		else if ship:partstagged("RCSCM1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
		{
			print "RCSCM Arm " at (25, 22).
		}
		else
		{
			print "RCSCM Off  " at (25, 22).
		}
	}
	else
	{
		print "RCSCM Disc" at (25, 22).
	}
	if ship:partstagged("RCSMM1"):length > 0
	{
		if ship:partstagged("RCSMM1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
		{
			print "RCSMM On  " at (25, 23).
		}
		else if ship:partstagged("RCSMM1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
		{
			print "RCSMM Arm " at (25, 23).
		}
		else
		{
			print "RCSMM Off  " at (25, 23).
		}
	}
	else
	{
		print "RCSMM Disc" at (25, 23).
	}
	if ship:partstagged("RCSS1"):length > 0
	{
		if ship:partstagged("RCSS1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs
		{
			print "RCSS On  " at (25, 24).
		}
		else if ship:partstagged("RCSS1")[0]:getmodule("ModuleRCSFX"):getfield("rcs"):tostring() = "True" and rcs = false
		{
			print "RCSS Arm " at (25, 24).
		}
		else
		{
			print "RCSS Off  " at (25, 24).
		}
	}
	else
	{
		print "RCSS Disc" at (25, 24).
	}
	
	print "|" at (23, 18).
	print "|" at (23, 19). 
	print "|" at (23, 20). 
	print "|" at (23, 21). 
	print "|" at (23, 22). 
	print "|" at (23, 23). 
	print "--------------------------" at (24, 25).
	print "|" at (23, 24).
	print "|" at (23, 25).
	print "-----------------------" at (0, 23).
	
	print "Maneuver Node" at (3, 24).
	if hasnode
	{
		print "Delta V: " + round(nextnode:deltav:mag, 1) at (0, 26).
		print "ETA: " + get_clock(round(nextnode:eta)) at (0, 27).
		print "Burn Time: " + get_clock(round(get_burn_time(nextnode))) at (0, 28).
	}
	else
	{
		print "Delta V: N/A" at (0, 26).
		print "ETE: N/A" at (0, 27).
		print "Burn Time: N/A" at (0, 28).
	}
	
	print "|" at (23, 26).
	print "|" at (23, 27).
	print "|" at (23, 28).
	print "|" at (23, 29).
	
	print "--------------------------------------------------" at (0, 30).
	print "CPU" at (0, 31).
	print input + output + "                              " at (0, 32).
}

declare function print_docking
{
	parameter input.
	parameter output.
	parameter timelaunch.
	parameter runmode.
	parameter current_action.
	print "Clock: " at (0,0).
	if time:seconds < timelaunch
	{
		print "T - " + get_clock(timelaunch - time:seconds) at (0,1).
	}
	else
	{
		print "T + " + get_clock(time:seconds - timelaunch) at (0,1).
	}

	print "Docking" at (21, 0).
	
	print "Runmode: " at (41, 0).
	print runmode  at (41, 1).
	
	print "|" at (13, 0).
	print "|" at (33, 0).
	print "|" at (13, 1).
	print "|" at (33, 1).
	print "--------------------------------------------------" at (0, 2).
	
	print "Current Action: " + current_action at (0, 3).
	
	print "--------------------------------------------------" at (0, 4).
	
	print "Angles" at (21 , 5).
	print "--------------------------------------------------" at (0, 10).
	print "Velocities" at (19 , 11).
	print "--------------------------------------------------" at (0, 16).
	print "Distances" at (19 , 17).
	print "--------------------------------------------------" at (0, 22).
	if hastarget
	{
		if target:ship:name = "Kerbol XI Lander"
		{
			local mm to vessel("Kerbol XI Lander").
			local mmd to mm:dockingports[0].
			local vmm to mmd:portfacing.
			local vcm to ship:dockingports[0]:portfacing.
			local deltap to arccos(vdot(vcm:forevector , vmm:topvector) / (vcm:vector:mag * vmm:vector:mag)) - 90.
			local deltay to 90 - arccos(vdot(vcm:forevector , vmm:starvector) / (vcm:vector:mag * vmm:vector:mag)).
			local deltar to vcm:roll - vmm:roll.
			
			print "Pitch: " + round(deltap, 1) + "     " at (19, 7).
			print "Yaw: " + round(deltay, 1) + "     " at (19, 8).
			print "Roll: " + round(deltar, 1) + "     " at (19, 9).
			
			print "Y: " + round(vdot(ship:velocity:orbit, vcm:topvector) - vdot(mm:velocity:orbit, vcm:topvector), 2) + "     " at (19, 13).
			print "X: " + round(vdot(ship:velocity:orbit, vcm:starvector) - vdot(mm:velocity:orbit, vcm:starvector), 2) + "     " at (19, 14).
			print "Z: " + round(vdot(ship:velocity:orbit, vcm:forevector) - vdot(mm:velocity:orbit, vcm:forevector), 2) + "     " at (19, 15).
			
			print "Y: " + round(vdot(ship:dockingports[0]:position, vcm:topvector) - vdot(mmd:position, vcm:topvector), 2) + "     " at (19, 19).
			print "X: " + round(vdot(ship:dockingports[0]:position, vcm:starvector) - vdot(mmd:position, vcm:starvector), 2) + "     " at (19, 20).
			print "Z: " + round(vdot(ship:dockingports[0]:position, vcm:forevector) - vdot(mmd:position, vcm:forevector), 2) + "     " at (19, 21).
		}
		else
		{
			local cm to vessel("Kerbol XI Lander").
			local cmd to cm:dockingports[0].
			local vcm to cmd:portfacing.
			local vmm to ship:dockingports[0]:portfacing.
			local deltap to arccos(vdot(vmm:forevector , vcm:topvector) / (vmm:vector:mag * vcm:vector:mag)) - 90.
			local deltay to 90 - arccos(vdot(vmm:forevector , vcm:starvector) / (vmm:vector:mag * vcm:vector:mag)).
			local deltar to vmm:roll - vcm:roll.
			
			print "Pitch: " + round(deltap, 1) + "     " at (19, 7).
			print "Yaw: " + round(deltay, 1) + "     " at (19, 8).
			print "Roll: " + round(deltar, 1) + "     " at (19, 9).
			
			print "Y: " + round(vdot(ship:velocity:orbit, vmm:topvector) - vdot(cm:velocity:orbit, vmm:topvector), 2) + "     " at (19, 13).
			print "X: " + round(vdot(ship:velocity:orbit, vmm:starvector) - vdot(cm:velocity:orbit, vmm:starvector), 2) + "     " at (19, 14).
			print "Z: " + round(vdot(ship:velocity:orbit, vmm:forevector) - vdot(cm:velocity:orbit, vmm:forevector), 2) + "     " at (19, 15).
			
			print "Y: " + round(vdot(ship:dockingports[0]:position, vmm:topvector) - vdot(cmd:position, vmm:topvector), 2) + "     " at (19, 19).
			print "X: " + round(vdot(ship:dockingports[0]:position, vmm:starvector) - vdot(cmd:position, vmm:starvector), 2) + "     " at (19, 20).
			print "Z: " + round(vdot(ship:dockingports[0]:position, vmm:forevector) - vdot(cmd:position, vmm:forevector), 2) + "     " at (19, 21).
		}
	}
	else
	{
		print "Pitch: N/A   " at (19, 7).
		print "Yaw: N/A   " at (19, 8).
		print "Roll: N/A   " at (19, 9).
		
		print "Y: N/A   " at (19, 13).
		print "X: N/A   " at (19, 14).
		print "Z: N/A   " at (19, 15).
		
		print "Y: N/A   " at (19, 19).
		print "X: N/A   " at (19, 20).
		print "Z: N/A   " at (19, 21).
	}
	
	print "--------------------------------------------------" at (0, 30).
	print "CPU" at (0, 31).
	print input + output + "                              " at (0, 32).
}

declare function get_clock
{
	parameter time_in_seconds.
	set time_in_seconds to round(time_in_seconds).
	local clock_format to "".
	local hours to 0.
	local minutes to 0.
	local string_hours to "".
	local string_minutes to "".
	local string_seconds to "".
	
	if time_in_seconds >= 3600
	{
		set hours to floor(time_in_seconds / 3600).
		set time_in_seconds to time_in_seconds - (hours * 3600).
		if hours < 10
		{
			set string_hours to "0" + hours.
		}
		else
		{
			set string_hours to hours.
		}
	}
	if time_in_seconds >= 60
	{
		set minutes to floor(time_in_seconds / 60).
		set time_in_seconds to time_in_seconds - (minutes * 60).
		if minutes < 10
		{
			set string_minutes to "0" + minutes.
		}
		else
		{
			set string_minutes to minutes.
		}
	}
	if time_in_seconds < 10
	{
		set string_seconds to "0" + time_in_seconds.
	}
	else
	{
		set string_seconds to time_in_seconds.
	}
	
	if hours > 0
	{
		set clock_format to string_hours + ":" + string_minutes + ":" + string_seconds.
	}
	else if minutes > 0 or hours > 0
	{
		set clock_format to string_minutes + ":" + string_seconds + "   ".
	}
	else
	{
		set clock_format to string_seconds + "     ".
	}
	return clock_format.
}