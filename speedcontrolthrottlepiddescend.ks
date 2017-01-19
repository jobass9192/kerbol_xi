@LAZYGLOBAL off.

declare function sctpd_init//takes in everything except speed_seek but also takes in current time
{
	parameter k_array.
	parameter t.
	local pid_array is list(0, 0, 0, k_array[0], k_array[1], k_array[2], t).
	return pid_array.
}

declare function sctpd_seek
{
	parameter speed_seek.
	parameter pid_array_init.
	
	local p_init is pid_array_init[0].
	local i_init is pid_array_init[1].
	local d_init is pid_array_init[2].
	local kp is pid_array_init[3].
	local ki is pid_array_init[4].
	local kd is pid_array_init[5].
	local t_init is pid_array_init[6].
	
	local t is time:seconds.
	local dt to t - t_init.
	
	local p is ship:airspeed - speed_seek.
	
	local i to i_init + p * dt.
	if i * ki < -1 or i * ki > 1
	{
		set i to i_init.//set i to p_init
	}
	
	local d to 0.
	if(dt > 0)
	{
		set d to (p - p_init) / dt.
	}
	
	local pid_array is list(p, i, d, kp, ki, kd, t).
	if t_init < 0
	{
		return list(0, 0, 0, kp, ki, kd, time:seconds).
	}
	else
	{
		return pid_array.
	}
}

declare function sctpd_control
{
	parameter speed_seek.
	parameter sctp_array.
	local pid_array to sctp_array.
	local throt to pid_array[0] * pid_array[3] + pid_array[1] * pid_array[4] + pid_array[2] * pid_array[5].
	if throt > 1
	{
		set throt to 1.
	}
	else if throt < 0
	{
		set throt to 0.
	}
	lock throttle to throt.
	print throt at (5, 16).
	print pid_array[0] at (5, 5).
	print pid_array[1] at (5, 6).
	print pid_array[2] at (5, 7).
	print pid_array[0] * pid_array[3] at (5, 8).
	print pid_array[1] * pid_array[4] at (5, 9).
	print pid_array[2] * pid_array[5] at (5, 10).
	return pid_array.
}

//USES VERTICAL SPEED
declare function sctpdv_init//takes in everything except speed_seek but also takes in current time
{
	parameter k_array.
	parameter t.
	local pid_array is list(0, 0, 0, k_array[0], k_array[1], k_array[2], t).
	return pid_array.
}

declare function sctpdv_seek
{
	parameter speed_seek.
	parameter pid_array_init.
	
	local p_init is pid_array_init[0].
	local i_init is pid_array_init[1].
	local d_init is pid_array_init[2].
	local kp is pid_array_init[3].
	local ki is pid_array_init[4].
	local kd is pid_array_init[5].
	local t_init is pid_array_init[6].
	
	local t is time:seconds.
	local dt to t - t_init.
	
	local p is -1 * ship:verticalspeed - speed_seek.
	
	local i to i_init + p * dt.
	if i * ki < -1 or i * ki > 1
	{
		set i to i_init.//set i to p_init
	}
	
	local d to 0.
	if(dt > 0)
	{
		set d to (p - p_init) / dt.
	}
	
	local pid_array is list(p, i, d, kp, ki, kd, t).
	if t_init < 0
	{
		return list(0, 0, 0, kp, ki, kd, time:seconds).
	}
	else
	{
		return pid_array.
	}
	
}

declare function sctpdv_control
{
	parameter speed_seek.
	parameter sctp_array.
	local pid_array to sctp_array.
	local throt to pid_array[0] * pid_array[3] + pid_array[1] * pid_array[4] + pid_array[2] * pid_array[5].
	if throt > 1
	{
		set throt to 1.
	}
	else if throt < 0
	{
		set throt to 0.
	}
	lock throttle to throt.
	//print throt at (5, 16).
	//print pid_array[0] at (5, 5).
	//print pid_array[1] at (5, 6).
	//print pid_array[2] at (5, 7).
	//print pid_array[0] * pid_array[3] at (5, 8).
	//print pid_array[1] * pid_array[4] at (5, 9).
	//print pid_array[2] * pid_array[5] at (5, 10).
	return pid_array.
}

