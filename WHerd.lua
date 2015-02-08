local s_data = gre.get_data("needle.hsNeedle.fStress", "needle.hsNeedle.sStress", "needle.hsNeedle.sRotValue", "Stress_Index.hsVal.sValStr", "base.ring_grove_face.hBase")	
local s_stress = s_data["needle.hsNeedle.sStress"]
local f_stress = s_data["needle.hsNeedle.fStress"]

local STRESS_MIN = 0.0
local STRESS_MAX = 180.0
local STRESS_ANGLE = 1.5
local STRESS_WAIT = 80

local s_step = 0

local t_data = gre.get_data("needle1.tNeedle.sTemp", "needle1.tNeedle.fTemp", "needle1.tNeedle.tRotValue", "Temperature.tVal.tValStr", "base1.ring_grove_face1.tBase")	
local s_temp = t_data["needle1.tNeedle.sTemp"]
local f_temp = t_data["needle1.tNeedle.fTemp"]

local TEMP_MIN = 0.0
local TEMP_MAX = 45.0
local TEMP_ANGLE = 6.0
local TEMP_WAIT = 250

local t_step = 0

local TEMP_THRESHOLD = 10.1
local STRESS_THRESHOLD = 22.7


function init_stress(mapargs)
	
	s_stress = round2(s_stress, 1)
	f_stress = round2(f_stress, 1)			

	check_stress_bounds()
	stress_set_angle()
	check_stress_threshold()
	
	gre.set_data(s_data)	
			
	gre.timer_set_timeout(move_stress, STRESS_WAIT)	
	
end

function move_stress()

	local stressVal = 0.0;

	if s_stress<f_stress then 	
		
		if (f_stress-s_stress)>1 then	
			
			if (s_stress-math.floor(s_stress)) > 0 then						
				s_step = round2(math.ceil(s_stress)-s_stress, 1)					
			else
				if (f_stress-s_stress)>=4 then								
					s_step = 4
				else
					s_step=1
				end
								
			end	
									
		else
			s_step = 0.1
		end				
		
		move_stress_up()
		
	elseif s_stress > f_stress then
	
		if (s_stress-f_stress)>1 then
		
			if (s_stress-math.floor(s_stress)) > 0 then						
				s_step = round2(s_stress - math.floor(s_stress), 1)																					
			else		
				if (s_stress-f_stress)>=4 then								
					s_step = 4
				else
					s_step=1
				end
								
			end
			
		else
			s_step = 0.1			
		end
		
		move_stress_down()
										
	end	

end

function move_stress_up()	
			
	if s_stress < f_stress then	
				
		s_stress = round2(s_stress + s_step*1, 1)
				
		s_data["needle.hsNeedle.sRotValue"] = s_data["needle.hsNeedle.sRotValue"] + s_step*STRESS_ANGLE
		s_data["Stress_Index.hsVal.sValStr"] = string.format("%.1f",s_stress)
				
		check_stress_threshold()				
		check_s_step(f_stress-s_stress)
				
		gre.set_data(s_data)					
		gre.timer_set_timeout(move_stress_up, s_step*STRESS_WAIT)
		
	end	
	
end

function move_stress_down()			
		
	if s_stress>f_stress then
		
		s_stress = round2(s_stress - s_step*1, 1)
		
		s_data["needle.hsNeedle.sRotValue"] = s_data["needle.hsNeedle.sRotValue"] - s_step*STRESS_ANGLE
		s_data["Stress_Index.hsVal.sValStr"] = string.format("%.1f",s_stress)		
		
		check_stress_threshold()		
		check_s_step(s_stress-f_stress)		
		
		gre.set_data(s_data)					
		gre.timer_set_timeout(move_stress_down, s_step*STRESS_WAIT)
						
	end
	
end

function check_stress_threshold()

	if s_stress > STRESS_THRESHOLD then	
		s_data["base.ring_grove_face.hBase"] = "images/underduress.png"	
	else
		s_data["base.ring_grove_face.hBase"] = "images/ringgroveface.png"
	end	
	
end

function check_stress_bounds()

	check_s_stress()
	check_f_stress()
	
end

function check_s_stress()

	if s_stress < STRESS_MIN then
		s_stress = STRESS_MIN		
	elseif s_stress > STRESS_MAX then
		s_stress = STRESS_MAX
	end

	s_data["needle.hsNeedle.sStress"] = s_stress
	s_data["Stress_Index.hsVal.sValStr"] = string.format("%.1f",s_stress)	
	
end

function check_f_stress()

	if f_stress < STRESS_MIN then
		f_stress = STRESS_MIN		
	elseif f_stress > STRESS_MAX then
		f_stress = STRESS_MAX
	end
	
	s_data["needle.hsNeedle.fStress"] = f_stress

end

function stress_set_angle()

	s_data["needle.hsNeedle.sRotValue"]= s_stress * STRESS_ANGLE
	
end

function check_s_step(val)

	val = round2(val, 1)

	if val<1 then
		s_step = 0.1
	elseif val>=4 then
		s_step = 4
	else
		s_step = 1 
	end

end

function init_temp(mapargs)

	s_temp = round2(s_temp, 1)
	f_temp = round2(f_temp, 1)	

	check_temp_bounds()
	temp_set_angle()
	check_temp_threshold()
	
	gre.set_data(t_data)
	
	gre.timer_set_timeout(move_temp, TEMP_WAIT)			
	
end

function move_temp()

	local tempVal = 0.0;

	if s_temp<f_temp then 	
		
		if (f_temp-s_temp)>=1 then	
			
			if (s_temp-math.floor(s_temp)) > 0 then						
				t_step = round2(math.ceil(s_temp)-s_temp, 1)								
			else								
				t_step = 1
			end				
						
		else
			t_step = 0.1
		end				
		
		move_temp_up()
		
	elseif s_temp > f_temp then
	
		if (s_temp-f_temp)>=1 then
		
			if (s_temp-math.floor(s_temp)) > 0 then						
				t_step = round2(s_temp - math.floor(s_temp), 1)																																																
			else		
				t_step = 1
			end
			
		else
			t_step = 0.1
		end
		
		move_temp_down()		
										
	end	

end

function move_temp_up()	
			
	if s_temp<f_temp then	
				
		s_temp = round2(s_temp + t_step*1, 1)
				
		t_data["needle1.tNeedle.tRotValue"] = t_data["needle1.tNeedle.tRotValue"] + t_step*TEMP_ANGLE
		t_data["Temperature.tVal.tValStr"] = string.format("%.1fC",s_temp)
				
		check_temp_threshold()				
		check_t_step(f_temp-s_temp)
				
		gre.set_data(t_data)		
		gre.timer_set_timeout(move_temp_up, t_step*TEMP_WAIT)		
		
	end	
	
end

function move_temp_down()			
		
	if s_temp>f_temp then
				
		s_temp = round2(s_temp - t_step*1, 1)
	
		t_data["needle1.tNeedle.tRotValue"] = t_data["needle1.tNeedle.tRotValue"] - t_step*TEMP_ANGLE
		t_data["Temperature.tVal.tValStr"] = string.format("%.1fC",s_temp)
		
		check_temp_threshold()		
		check_t_step(s_temp-f_temp)		
		
		gre.set_data(t_data)				
		gre.timer_set_timeout(move_temp_down, t_step*TEMP_WAIT)
						
	end
	
end

function check_temp_threshold()

	if s_temp > TEMP_THRESHOLD then	
		t_data["base1.ring_grove_face1.tBase"] = "images/underduress.png"	
	else
		t_data["base1.ring_grove_face1.tBase"] = "images/ringgroveface1.png"
	end		

end

function check_temp_bounds()

	check_s_temp()
	check_f_temp()
	
end

function check_s_temp()

	if s_temp < TEMP_MIN then
		s_temp = TEMP_MIN		
	elseif s_temp > TEMP_MAX then
		s_temp = TEMP_MAX
	end

	t_data["needle1.tNeedle.sTemp"] = s_temp
	t_data["Temperature.tVal.tValStr"] = string.format("%.1fC",s_temp)	
	
end

function check_f_temp()

	if f_temp < TEMP_MIN then
		f_temp = TEMP_MIN		
	elseif f_temp > TEMP_MAX then
		f_temp = TEMP_MAX
	end
	
	t_data["needle1.tNeedle.fTemp"] = f_temp

end

function temp_set_angle()

	t_data["needle1.tNeedle.tRotValue"]= s_temp * TEMP_ANGLE
	
end

function check_t_step(val)

	val = round2(val, 1)

	if val<1 then
		t_step = 0.1
	else
		t_step = 1
	end

end

function round2(num, idp)

  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
  
end