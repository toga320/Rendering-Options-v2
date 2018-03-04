screen_height=globalPropertyi("sim/graphics/view/window_height",false)
screen_width=globalPropertyi("sim/graphics/view/window_width",false)
ro_sett=globalPropertyfa ( "pnv/ro/ro_sett", false )
MainFont = sasl.gl.loadFont ( "fonts/DejaVuSans.ttf" )
defineProperty("slider_img",  sasl.gl.loadImage("pic/slider.png"))
defineProperty("back_img",  sasl.gl.loadImage("pic/back.png"))
defineProperty("blue_img",  sasl.gl.loadImage("pic/blue.png"))
a=0
b=0
local start_pic=1
current_height=get(screen_height)
current_width=get(screen_width)
openmainwindow = sasl.findCommand("pnv/ro/popup")
set_pos=false
moving=false
mnm=""
timercount=0
timevar=0
StartTimerIDMain = sasl.createTimer ()
sasl.startTimer(StartTimerIDMain)
local xautolod=0

function draw()
	if get(ro_sett,20)>0 then	
		sasl.gl.drawTexture(get(back_img) , -get(screen_width)+10+a	 , -get(screen_height)*(get(ro_sett,11)/100) , get(screen_width) , get(screen_height), {1 , 1 , 1 , 1 })
	end
	if StartTimerIDMain~=0 then
		if timercount>1 then
			mnm=mnm.."."
			timercount=0
		end
		if mnm=="......" then
			mnm=""
		end
		sasl.gl.drawText ( MainFont , -get(screen_width)+20+a , -get(screen_height)*(get(ro_sett,11)/100)+20 , "Loading Advanced Rendering Options plugin"..mnm, 20 , false , false , TEXT_ALIGN_LEFT , {1 , 1 , 1 , 1 } )
	else
		if get(ro_sett,12)==1 then
			sasl.gl.drawTexture(get(slider_img) , 0 , 0 , 110 , 45, {1 , 1 , 1 , get(ro_sett,9) })
		else
			sasl.gl.drawTexture(get(slider_img) , 10 , 0 , 110 , 45, {1 , 1 , 1 , get(ro_sett,9) })
		end
	end
	
end
function onMouseMove(component, x, y, button, parentX, parentY)
	--set_pos=true
	--moving=true
	return true
end
function onMouseEnter()
	set_pos=true
	moving=true	
	return true
end
function onMouseLeave()
	set_pos = false
	moving=true
	return true
end
function onMouseDown(component, x, y, button, parentX, parentY)
	if button == MB_LEFT then
		sasl.commandOnce(openmainwindow)	
	end
	return true
end
function update()
	if get(ro_sett,20)>0 then
		set(ro_sett,get(ro_sett,20)-0.05,20)
	end
	if get(ro_sett,20)<=0 and get(ro_sett,19)==2 then
		sasl.commandOnce(openmainwindow)
		set(ro_sett,0,19)
	end
	if (current_height~=get(screen_height)) or (current_width~=get(screen_width)) then
		slidetab.position = {get(screen_width)-10-a, get(screen_height)*(get(ro_sett,11)/100), 110, 35}
		current_height=get(screen_height)
		current_width=get(screen_width)
	end
	if StartTimerIDMain==0 then
		if set_pos==true and moving==true then
			a=a+10
			slidetab.position = {get(screen_width)-10-a, get(screen_height)*(get(ro_sett,11)/100), 110, 35}
			if a>60 then
				moving=false
				--a=0
			end
		elseif set_pos==false and moving==true then
			a=a-10
			slidetab.position = {get(screen_width)-10-a, get(screen_height)*(get(ro_sett,11)/100), 110, 35}
			if a<10 then
				moving=false
				a=0
			end
		end
	end
	if StartTimerIDMain ~= 0 then
		timevar = sasl.getElapsedSeconds(StartTimerIDMain)
		timercount=timercount+0.1
	end
	if timevar>5 then					------LOADING TIMER
		sasl.stopTimer(StartTimerIDMain)
		sasl.deleteTimer(StartTimerIDMain)
		StartTimerIDMain=0
		set(ro_sett,0,20)
		timevar=0
	end
end