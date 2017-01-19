@LAZYGLOBAL off.
set config:IPU to 300.
run kerbolxiprintdisplays.ks.

sas on.
lock throttle to 0.3.
ag68 on.
clearscreen.

//corrects double type input error
local first1 to true.
local first2 to true.
local first3 to true.
local first4 to true.
local first5 to true.
local first6 to true.
local first7 to true.
local first8 to true.
local first9 to true.
local first10 to true.
local first11 to true.

parameter input.
parameter output.
parameter timelaunch.
parameter runmode.
parameter displaymode.
parameter abortmode.
parameter abortisactive.
parameter current_action.
parameter p_seek.
parameter y_seek.
parameter r_seek.

local program to 0.
local staged to 0.
local outfuel to 0.

set steeringmanager:maxstoppingtime to 10.
set steeringmanager:pitchts to 15.
set steeringmanager:yawts to 15.
set steeringmanager:pitchpid:kp to 0.7.
set steeringmanager:pitchpid:ki to 0.01.
set steeringmanager:pitchpid:kd to 0.05.
set steeringmanager:yawpid:kp to 0.7.
set steeringmanager:yawpid:ki to 0.01.
set steeringmanager:yawpid:kd to 0.05.
set steeringmanager:rollpid:kp to 0.5.
set steeringmanager:rollpid:ki to 0.0.
set steeringmanager:rollpid:kd to 0.1.

until runmode = -1
{
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////PRINT DISPLAYS///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if displaymode = 0
	{
		print_init(input, output).
	}
	else if displaymode = 1
	{
		print_systems(input, output, timelaunch, runmode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
	}
	else if displaymode = 2
	{
		print_launch(input, output, timelaunch, runmode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
	}
	else if displaymode = 3
	{
		print_orbit(input, output, timelaunch, runmode, current_action).
	}
	else if displaymode = 4
	{
		print_docking(input, output, timelaunch, runmode, current_action).
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////AG COMMANDS//////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	on ag1
	{
		clearscreen.
		if first1
		{
			set first1 to false.
		}
		else
		{
			set input to input + "1".
		}
		set output to "".
	}
	on ag2
	{
		clearscreen.
		if first2
		{
			set first2 to false.
		}
		else
		{
			set input to input + "2".
		}
		set output to "".
	}
	on ag3
	{
		clearscreen.
		if first3
		{
			set first3 to false.
		}
		else
		{
			set input to input + "3".
		}
		set output to "".
	}
	on ag4
	{
		clearscreen.
		if first4
		{
			set first4 to false.
		}
		else
		{
			set input to input + "4".
		}
		set output to "".
	}
	on ag5
	{
		clearscreen.
		if first5
		{
			set first5 to false.
		}
		else
		{
			set input to input + "5".
		}
		set output to "".
	}
	on ag6
	{
		clearscreen.
		if first6
		{
			set first6 to false.
		}
		else
		{
			set input to input + "6".
		}
		set output to "".
	}
	on ag7
	{
		clearscreen.
		if first7
		{
			set first7 to false.
		}
		else
		{
			set input to input + "7".
		}
		set output to "".
	}
	on ag8
	{
		clearscreen.
		if first8
		{
			set first8 to false.
		}
		else
		{
			set input to input + "8".
		}
		set output to "".
	}
	on ag9
	{
		clearscreen.
		if first9
		{
			set first9 to false.
		}
		else
		{
			set input to input + "9".
		}
		set output to "".
	}
	on ag10
	{
		clearscreen.
		if first10
		{
			set first10 to false.
		}
		else
		{
			set input to input + "0".
		}
		set output to "".
	}
	on ag11
	{
		clearscreen.
		if input = "100"
		{
			set input to "".
			set timelaunch to time:seconds + 240.
			set runmode to -1.
			set program to 100.
			set output to "Running Pre Launch Program".
		}
		else if input = "101"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Launch Sequence".
			set p_seek to 90.
			set y_seek to 0.
			set r_seek to 0.
			set program to 101.
			set output to "Running Launch Program".
		}
		else if input = "102"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Drifting to Space".
			set p_seek to ship:velocity:orbit:x.
			set y_seek to 90.
			set r_seek to 0.
			set program to 102.
			set output to "Running Kerbin Circularization".
		}
		else if input = "103"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Computing Trans-Munar Node".
			set p_seek to 999.
			set y_seek to 999.
			set r_seek to 999.
			set program to 103.
			set output to "Running Trans-Munar Burn".
		}
		else if input = "104"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Positioning Ship for Sep".
			set p_seek to 999.
			set y_seek to 999.
			set r_seek to 999.
			set program to 104.
			set output to "Running Docking Program".
		}
		else if input = "105"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Calculating First Correction Burn".
			set p_seek to 999.
			set y_seek to 999.
			set r_seek to 999.
			set program to 105.
			set output to "Running Munar Burns Program".
		}
		else if input = "106"
		{
			set input to "".
			set runmode to -1.
			set current_action to "Maneuvering to Retrograde".
			set p_seek to 999.
			set y_seek to 999.
			set r_seek to 999.
			set program to 106.
			set output to "Running Pre Undocking Program".
		}
		else if input = "200"
		{
			set input to "".
			set displaymode to 0.
			set output to "Showing Initial".
		}
		else if input = "201"
		{
			set input to "".
			set displaymode to 1.
			set output to "Showing Systems".
		}
		else if input = "202"
		{
			set input to "".
			set displaymode to 2.
			set output to "Showing Launch".
		}
		else if input = "203"
		{
			set input to "".
			set displaymode to 3.
			set output to "Showing Orbit".
		}
		else if input = "204"
		{
			set input to "".
			set displaymode to 4.
			set output to "Showing Docking".
		}
		else if input = "301"
		{
			set abortmode to 1.
			set output to "Abort Mode Set to 1".
		}
		else if input = "302"
		{
			set abortmode to 2.
			set output to "Abort Mode Set to 2".
		}
		else if input = "303"
		{
			set abortmode to 3.
			set output to "Abort Mode Set to 3".
		}
		else if input = "401"
		{
			set navmode to "surface".
			set output to "Navmode is Surface".
		}
		else if input = "402"
		{
			set navmode to "orbit".
			set output to "Navmode is Orbit".
		}
		else if input = "403"
		{
			set navmode to "target".
			set output to "Navmode is Target".
		}
		else if input = "500"
		{
			unset target.
			set output to "Target Unset".
		}
		else if input = "501"
		{
			local tgtlist is list().
			list targets in tgtlist.
			for tgt in tgtlist
			{
				if tgt:name = "Kerbol XI Lander"
				{
					set target to vessel("Kerbol XI Lander"):dockingports[0].
					set output to "Target Set as Munar Module".
					break.
				}
			}
			if hastarget = false
			{
				set output to "No Such Target".
			}
			else if target:ship:name = "Kerbol XI"
			{
				set output to "No Such Target".
			}
		}
		else if input = "502"
		{
			local tgtlist is list().
			list targets in tgtlist.
			for tgt in tgtList
			{
				if tgt:name = "Kerbol XI"
				{
					set target to vessel("Kerbol XI"):dockingports[0].
					set output to "Target Set as Command Module".
					break.
				}
			}
			if hastarget = false
			{
				set output to "No Such Target".
			}
			else if target:ship:name = "Kerbol XI Lander"
			{
				set output to "No Such Target".
			}
		}
		else if input = "503"
		{
			unset target.
			if hastarget
			{
				set output to "Targets Unset".
			}
			else
			{
				set output to "No Targets to Unset".
			}
		}
		else if input = "600"
		{
			unlock steering.
			set output to "Steering Unlocked".
		}
		else if input = "601"
		{
			unlock throttle.
			set output to "Throttle Unlocked".
		}
		else if input = "602"
		{
			if hastarget
			{
				local d to target.
				lock steering to d:portfacing:forevector * -1.
				set output to "Steering Locked For Docking".
			}
			else
			{
				set output to "No Target To Lock Steering To".
			}
		}
		else if input = "999"
		{
			set runmode to -1.
		}
		else if input:startswith("0")
		{
			local length to input:length - 1.
			set runmode to input:substring(1, length).
			set output to "Runmode is now " + runmode.
		}
		else if input = "EXECUTE?"
		{
			set canexecute to true.
			set output to "CLEAR TO CANCEL".
		}
		else
		{
			if first11
			{
				set first11 to false.
			}
			else
			{
				set output to "Error: No Executable Found".
			}
		}
		set input to "".
		clearscreen.
	}
	on ag12
	{
		if input = "EXECUTE?" or output = "CLEAR TO CANCEL"
		{
			set canexecute to false.
			remove node1.
			lock throttle to 0.
			unlock steering.
			sas on.
			set output to "Node Execution Cancled".
			set p_seek to 999.
			set y_seek to 999.
			set r_seek to 999.
		}
		set input to "".
	}
	on ag13
	{
		clearscreen.
	}
	on ag14
	{
		set runmode to -1.
	}
	on abort
	{
		set input to "".
		set abortisactive to true.
		set output to "ABORTING " + abortmode.
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////RUNNING CODE/////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if runmode = 4
	{
		if (timelaunch - time:seconds <= 10)
		{
			stage.
			set current_action to "Engine Start Sequence".
			set runmode to 5.
		}
	}
	else if runmode = 5
	{
		if (timelaunch - time:seconds <= 7)
		{
			stage.
			set runmode to 6.
		}
	}
	else if runmode = 6
	{
		lock throttle to (1.28 - (0.14 * (timelaunch - time:seconds))).
		if (timelaunch - time:seconds) <= 2
		{
			lock throttle to 1.
			set runmode to 7.
		}
	}
	else if runmode = 7
	{
		if (timelaunch - time:seconds) <= 0
		{
			stage.
			set current_action to "Vertical Ascent".
			set runmode to 8.
			clearscreen.
		}
	}
	else if runmode = 8
	{
		if ship:altitude > 180
		{
			sas off.
			set current_action to "Roll Maneuver".
			set y_seek to 90.
			set r_seek to 180.
			set runmode to 9.
			clearscreen.
		}
	}
	else if runmode = 9
	{
		lock steering to up + R(0, 0, 90).
		if ship:altitude > 500
		{
			set current_action to "Variable Pitch Ascent".
			set runmode to 10.
			clearscreen.
		}
	}
	else if runmode = 10
	{
		set p_seek to 91.5 - (0.0031 * ship:altitude).
		lock steering to up + R(0, p_seek - 90, 90).
		if ship:altitude >= 15000
		{
			set runmode to 11.
			clearscreen.
		}
	}
	else if runmode = 11
	{
		set p_seek to 67.5 - (0.0015 * ship:altitude).
		lock steering to up + R(0, p_seek - 90, 90).
		if stage:liquidfuel = 0 and (staged = 0 or staged = 1)
		{
			if staged = 0
			{
				set outfuel to time:seconds.
				set staged to 1.
			}
			else if time:seconds - outfuel >= 1
			{
				set staged to 2.
				stage.
			}
		}
		if ship:altitude >= 45000
		{
			set current_action to "Steady Pitch Ascent".
			set p_seek to 0.
			set runmode to 12.
			clearscreen.
		}
	}
	else if runmode = 12
	{
		lock steering to up + R(0, p_seek - 90, 90).
		if ship:apoapsis >= 100000
		{
			lock throttle to 0.
			ag69 on.
			set steeringmanager:maxstoppingtime to 7.
			set steeringmanager:pitchts to 7.
			set steeringmanager:yawts to 7.
			set steeringmanager:pitchpid:kp to 0.3.
			set steeringmanager:pitchpid:ki to 0.0.
			set steeringmanager:pitchpid:kd to 0.1.
			set steeringmanager:yawpid:kp to 0.3.
			set steeringmanager:yawpid:ki to 0.0.
			set steeringmanager:yawpid:kd to 0.1.
			set steeringmanager:rollpid:kp to 0.3.
			set steeringmanager:rollpid:ki to 0.0.
			set steeringmanager:rollpid:kd to 0.1.
			lock steering to ship:velocity:orbit.
			set current_action to "Engine Cut: Crew Action".
			set runmode to 13.
		}
	}
	else if runmode = 13
	{
		
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////PROGRAM RUNS/////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if program = 100
{
	set runmode to 1.
	runpath("kxicm1100", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 101
{
	set runmode to 4.
	runpath("kxicm1101", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 102
{
	set runmode to 14.
	runpath("kxicm1102", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 103
{
	set runmode to 17.
	runpath("kxicm1103", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 104
{
	set runmode to 21.
	runpath("kxicm1104", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 105
{
	set runmode to 25.
	runpath("kxicm1105", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}
else if program = 106
{
	set runmode to 35.
	runpath("kxicm1106", input, output, timelaunch, runmode, displaymode, abortmode, abortisactive, current_action, p_seek, y_seek, r_seek).
}