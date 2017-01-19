@LAZYGLOBAL off.

clearscreen.
local runmode to 1.
local input to "".
local abortmode to 0.

until runmode = -1
{
	on ag1
	{
		set input to input + "1".
	}
	on ag2
	{
		set input to input + "2".
	}
	on ag3
	{
		set input to input + "3".
	}
	on ag9
	{
		set runmode to -1.
	}
	on ag10
	{
		set input to input + "0".
	}
	on ag11
	{
		if input = "301"
		{
			set abortmode to 1.
		}
		else if input = "302"
		{
			set abortmode to 2.
		}
		set input to "".
	}
	on abort
	{
		if abortmode = 1
		{
			ag57 on.//stages capsule from command module
			ag55 on.//fires launch abort engines
			wait 1.
			ag56 on.//releases launch abort engines
			wait 1.
			ag58 on.//deploys drogue chutes
			wait 2.
			ag59 on.//cuts drogue chutes
			ag60 on.//deploys main chutes
		}
		else if abortmode = 2
		{
			ag57 on.//stages capsule from command module
			ag55 on.//fires launch abort engines
			wait 1.
			ag56 on.//releases launch abort engines
			wait 0.1.
			sas on.
			wait 0.1.
			set sasmode to "retrograde".
			wait until ship:verticalspeed < 0 and alt:radar < 5000.
			ag58 on.//deploys drogue chutes
			sas off.
			wait until alt:radar < 1000.
			ag59 on.//cuts drogue chutes
			ag60 on.//deploys main chutes
		}
	}
}