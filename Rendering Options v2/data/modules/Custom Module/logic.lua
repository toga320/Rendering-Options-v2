window_height= globalPropertyi("sim/graphics/view/window_height")
window_width= globalPropertyi("sim/graphics/view/window_width")
wheight=get(window_height)
wwidth=get(window_width)
stages=0
timevarlogic=0
timevarlogiconreload=0
ro_sett=globalPropertyfa ( "pnv/ro/ro_sett", false )
wave_length=globalPropertyf("sim/weather/wave_length")
altitude=globalPropertyf(	"sim/flightmodel/position/elevation")
clouds_base_0=globalPropertyf("sim/weather/cloud_base_msl_m[0]")
clouds_base_1=globalPropertyf("sim/weather/cloud_base_msl_m[1]")
clouds_base_2=globalPropertyf("sim/weather/cloud_base_msl_m[2]")
clouds_top_0=globalPropertyf("sim/weather/cloud_tops_msl_m[0]")
clouds_top_1=globalPropertyf("sim/weather/cloud_tops_msl_m[1]")
clouds_top_2=globalPropertyf("sim/weather/cloud_tops_msl_m[2]")
clouds_type_0=globalPropertyi("sim/weather/cloud_type[0]")
clouds_type_1=globalPropertyi("sim/weather/cloud_type[1]")
clouds_type_2=globalPropertyi("sim/weather/cloud_type[2]")
reload_aircraft = sasl.findCommand("sim/operation/reload_aircraft")
prev_livery = sasl.findCommand("sim/operation/prev_livery")
next_livery = sasl.findCommand("sim/operation/next_livery")

startup_running= globalPropertyi("sim/operation/prefs/startup_running")

id_env = sasl.findPluginBySignature("css.aero.xenviro")
id_env2 = sasl.findPluginBySignature("dark.space.xenviro")
version = sasl.getXPVersion()
--print(version)
if id_env~=-1 then
	env_active= globalPropertyi("env/active", true)
elseif id_env2~=-1 then
	env_active= globalPropertyi("env/active", true)
else
	env_active=0
end
local apply_pushed=false


ro_refs_values=globalPropertyfa ( "pnv/ro/ro_refs_values", false )
temp_ro_ref_values={}
LOD_xp_paused= globalPropertyi("sim/time/paused")
LOD_xp_framerate=globalPropertyf("sim/operation/misc/frame_rate_period")   -- 1/frame_rate_period = FPS
need_reload=globalPropertyia ( "pnv/ro/need_reload", false )
reload_scenery = sasl.findCommand("sim/operation/reload_scenery")
StartTimerIDLogic = sasl.createTimer ()
sasl.startTimer(StartTimerIDLogic)
local ii=1
local load_at_start=0
local steps_logic=0
reload_true_false={}
temp_data_to_reload={}
function readrefslogic()
	LOD_xp_aif_akt= globalPropertyi("sim/private/controls/reno/aniso_filter")
	LOD_xp_obf_akt=	globalPropertyf("sim/private/controls/tex/ortho_boost_factor")
	white_out_in_clouds=globalPropertyf("sim/private/controls/skyc/white_out_in_clouds")
	LOD_fsaa_x=	globalPropertyf("sim/private/controls/hdr/fsaa_ratio_x")
	LOD_fsaa_y=	globalPropertyf("sim/private/controls/hdr/fsaa_ratio_y")
	LOD_post_aa= globalPropertyf("sim/private/controls/hdr/use_post_aa")
	fft_amp1_ref=globalProperty("sim/private/controls/water/fft_amp1")
	fft_amp2_ref=globalProperty("sim/private/controls/water/fft_amp2")
	fft_amp3_ref=globalProperty("sim/private/controls/water/fft_amp3")
	fft_amp4_ref=globalProperty("sim/private/controls/water/fft_amp4")
	fft_scale1_ref=globalPropertyf("sim/private/controls/water/fft_scale1")
	fft_scale2_ref=globalPropertyf("sim/private/controls/water/fft_scale2")
	fft_scale3_ref=globalPropertyf("sim/private/controls/water/fft_scale3")
	fft_scale4_ref=globalPropertyf("sim/private/controls/water/fft_scale4")
	noise_speed_ref=globalPropertyf("sim/private/controls/water/noise_speed")
	LOD_bias_rat_ref=globalPropertyf("sim/private/controls/reno/LOD_bias_rat")
	draw_deer_birds_ref=globalPropertyi("sim/private/controls/reno/draw_deer_birds")
	draw_fire_ball_ref=globalPropertyi("sim/private/controls/reno/draw_fire_ball")
	draw_boats_ref=globalPropertyi("sim/private/controls/reno/draw_boats")
	draw_aurora_ref=globalPropertyi("sim/private/controls/reno/draw_aurora") ---------ENVIRO
	draw_scattering_ref=globalPropertyi("sim/private/controls/reno/draw_scattering")
	draw_volume_fog01_ref=globalPropertyi("sim/private/controls/reno/draw_volume_fog01")
	draw_per_pix_liting_ref=globalPropertyi("sim/private/controls/reno/draw_per_pix_liting")
	static_plane_build_vis=globalPropertyf("sim/private/controls/park/static_plane_build_dis")
	static_plane_density=globalPropertyf("sim/private/controls/park/static_plane_density")
	---water and reflection
	use_reflective_water=globalPropertyf("sim/private/controls/caps/use_reflective_water")
	draw_fft_water=globalPropertyi("sim/private/controls/reno/draw_fft_water")
	draw_reflect_water05=globalPropertyi("sim/private/controls/reno/draw_reflect_water05")
	--use_3dwater_ref=globalPropertyf("sim/private/controls/caps/use_3dwater")
	noise_bias_gen_x_ref=globalPropertyf("sim/private/controls/water/noise_bias_gen_x")
	noise_bias_gen_y_ref=globalPropertyf("sim/private/controls/water/noise_bias_gen_y")
	---SHADOWS
	csm_split_exterior=globalPropertyf("sim/private/controls/shadow/csm_split_exterior")
	csm_split_interior=globalPropertyf("sim/private/controls/shadow/csm_split_interior")
	far_limit=globalPropertyf("sim/private/controls/shadow/csm/far_limit")
	scenery_shadows=globalPropertyf("sim/private/controls/shadow/scenery_shadows")
	shadow_cam_size=globalPropertyf("sim/private/controls/fbo/shadow_cam_size")
	shadow_size=globalPropertyf("sim/private/controls/clouds/shadow_size")
	cockpit_near_adjust=globalPropertyf("sim/private/controls/shadow/cockpit_near_adjust")
	cockpit_near_proxy=globalPropertyf("sim/private/controls/shadow/cockpit_near_proxy")
	disable_shadow_prep=globalPropertyf("sim/private/controls/perf/disable_shadow_prep")
	last_3d_pass=globalPropertyf("sim/private/controls/shadow/last_3d_pass")  ------------------------------------------------------------------------------------------------
	----NUMBER OF OBJECTS
	draw_objs_06_ref=globalPropertyi("sim/private/controls/reno/draw_objs_06")--
	draw_cars_05_ref=globalPropertyi("sim/private/controls/reno/draw_cars_05")--
	draw_vecs_03_ref=globalPropertyi("sim/private/controls/reno/draw_vecs_03")--
	draw_for_05_ref=globalPropertyi("sim/private/controls/reno/draw_for_05")--
	inn_ring_density_ref=globalPropertyf("sim/private/controls/forest/inn_ring_density")--
	mid_ring_density_ref=globalPropertyf("sim/private/controls/forest/mid_ring_density")--
	out_ring_density_ref=globalPropertyf("sim/private/controls/forest/out_ring_density")--
	draw_detail_apt_03_ref=globalPropertyi("sim/private/controls/reno/draw_detail_apt_03")
	extended_dsfs_ref=globalPropertyf("sim/private/controls/geoid/extended_dsfs")
	---TEXTURE QUALITY
	draw_HDR_ref=globalPropertyi("sim/private/controls/reno/draw_HDR")
	comp_texes_ref=globalPropertyi("sim/private/controls/reno/comp_texes")				--to apply
	use_bump_maps_ref=globalPropertyi("sim/private/controls/reno/use_bump_maps")				--0/1
	use_detail_textures_ref=globalPropertyi("sim/private/controls/reno/use_detail_textures")		
	ssao_enable_ref=globalPropertyf("sim/private/controls/ssao/enable")  
	---CLOUDS AND Atmo
	first_res_3d_ref=globalPropertyf("sim/private/controls/clouds/first_res_3d") --1
	last_res_3d_ref=globalPropertyf("sim/private/controls/clouds/last_res_3d") --1
	cloud_shadow_lighten_ratio_ref=globalPropertyf("sim/private/controls/clouds/cloud_shadow_lighten_ratio")  --0.1
	plot_radius_ref=globalPropertyf("sim/private/controls/clouds/plot_radius") --0.1
	overdraw_control_ref=globalPropertyf("sim/private/controls/clouds/overdraw_control")  --0.01
	ambient_gain_ref=globalPropertyf("sim/private/controls/clouds/ambient_gain")  --0.01
	diffuse_gain_ref=globalPropertyf("sim/private/controls/clouds/diffuse_gain")--0.01
	white_point_ref=globalPropertyf("sim/private/controls/hdr/white_point") 	--0.1
	atmo_scale_raleigh_ref=globalPropertyf("sim/private/controls/atmo/atmo_scale_raleigh")---------ENVIRO --0.1
	inscatter_gain_raleigh_ref=globalPropertyf("sim/private/controls/atmo/inscatter_gain_raleigh")---------ENVIRO --0.1
	max_shadow_angle_ref=globalPropertyf("sim/private/controls/skyc/max_shadow_angle")  --1     -180+180
	min_shadow_angle_ref=globalPropertyf("sim/private/controls/skyc/min_shadow_angle") --1      -180+180
	max_dsf_vis_ever_ref=globalPropertyf("sim/private/controls/skyc/max_dsf_vis_ever") --100
	dsf_fade_ratio_ref=globalPropertyf("sim/private/controls/skyc/dsf_fade_ratio") --0.01   0 - 1
	dsf_cutover_scale_ref=globalPropertyf("sim/private/controls/skyc/dsf_cutover_scale") --0.1   0 - 2
	min_tone_angle_ref=globalPropertyf("sim/private/controls/skyc/min_tone_angle")---------ENVIRO --1      -100+100
	max_tone_angle_ref=globalPropertyf("sim/private/controls/skyc/max_tone_angle")---------ENVIRO --1      -100+100
	tone_ratio_clean_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_clean")---------ENVIRO --0.1      -50+50
	tone_ratio_foggy_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_foggy")---------ENVIRO --0.1      -50+50
	tone_ratio_hazy_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_hazy")---------ENVIRO --0.1      -50+50
	tone_ratio_snowy_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_snowy")---------ENVIRO --0.1      -50+50
	tone_ratio_ocast_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_ocast")---------ENVIRO --0.1      -50+50
	tone_ratio_strat_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_strat")---------ENVIRO --0.1      -50+50
	tone_ratio_hialt_ref=globalPropertyf("sim/private/controls/skyc/tone_ratio_hialt")---------ENVIRO --0.1      -50+50
	inscatter_gain_mie=globalPropertyf("sim/private/controls/atmo/inscatter_gain_mie")--1.0 
	scatter_raleigh_r=globalPropertyf("sim/private/controls/atmo/scatter_raleigh_r")--5.00 )
	scatter_raleigh_g=globalPropertyf("sim/private/controls/atmo/scatter_raleigh_g")--20.00 )
	scatter_raleigh_b=globalPropertyf("sim/private/controls/atmo/scatter_raleigh_b")--46.0 )
	sky_gain=globalPropertyf("sim/private/controls/hdr/sky_gain")--2.9 )
	---Visibility and Lights
	visibility_reported_m_ref=globalPropertyf("sim/weather/visibility_reported_m")
	cars_lod_min_ref=globalPropertyf("sim/private/controls/cars/lod_min")  -- 100 0-100000 cars visibility
	tile_lod_bias_ref=globalPropertyf("sim/private/controls/ag/tile_lod_bias")   ----0.1-1  obj vis reload needed
	fade_start_rat_ref=globalPropertyf("sim/private/controls/terrain/fade_start_rat")----0-1  0.1 terrain objects (trees) visibl 
	composite_far_dist_bias_ref=globalPropertyf("sim/private/controls/terrain/composite_far_dist_bias")  -- 0-1 0.1 terrain details visibility reload needed
	fog_be_gone_ref=globalPropertyf("sim/private/controls/fog/fog_be_gone")  -- 0-5 0.01 enviro
	--car_lod_boost_ref=globalPropertyf("sim/private/controls/terrain/car_lod_boost")
	--lights
	exponent_far_ref=globalPropertyf("sim/private/controls/lights/exponent_far")
	exponent_near_ref=globalPropertyf("sim/private/controls/lights/exponent_near")
	bloom_far_ref=globalPropertyf("sim/private/controls/lights/bloom_far")
	bloom_near_ref=globalPropertyf("sim/private/controls/lights/bloom_near")
	dist_far_ref=globalPropertyf("sim/private/controls/lights/dist_far")
	dist_near_ref=globalPropertyf("sim/private/controls/lights/dist_near")
	scale_far_ref=globalPropertyf("sim/private/controls/lights/scale_far") ---------ENVIRO
	scale_near_ref=globalPropertyf("sim/private/controls/lights/scale_near")
end

local LOD_fps_average = 0
local LOD_version = "Auto_LOD 1.3"
local LOD_akt_time = os.clock()
local count = 0
local grayhor=0
function assign_values()
	temp_data_to_reload[1]=get(draw_deer_birds_ref)
	temp_data_to_reload[2]=get(draw_fire_ball_ref)
	temp_data_to_reload[3]=get(draw_boats_ref)
	temp_data_to_reload[4]=get(draw_aurora_ref)
	temp_data_to_reload[5]=get(draw_scattering_ref)
	temp_data_to_reload[6]=get(draw_volume_fog01_ref)
	temp_data_to_reload[7]=get(draw_per_pix_liting_ref)
	temp_data_to_reload[8]=get(draw_objs_06_ref)
	temp_data_to_reload[9]=get(draw_vecs_03_ref)
	temp_data_to_reload[10]=get(draw_for_05_ref)
	temp_data_to_reload[11]=get(inn_ring_density_ref)
	temp_data_to_reload[12]=get(mid_ring_density_ref)
	temp_data_to_reload[13]=get(out_ring_density_ref)
	temp_data_to_reload[14]=get(draw_detail_apt_03_ref)
	temp_data_to_reload[15]=get(comp_texes_ref)
	temp_data_to_reload[16]=get(extended_dsfs_ref)
	temp_data_to_reload[17]=get(tile_lod_bias_ref)
	temp_data_to_reload[18]=get(composite_far_dist_bias_ref)
end

function check_need_reload(locvar, drf)
if locvar==drf then return true
else return false
end
end

function need_reload_func()
	reload_true_false[1]=check_need_reload(temp_data_to_reload[1], get(draw_deer_birds_ref))
	reload_true_false[2]=check_need_reload(temp_data_to_reload[2], get(draw_fire_ball_ref))
	reload_true_false[3]=check_need_reload(temp_data_to_reload[3], get(draw_boats_ref))
	reload_true_false[4]=check_need_reload(temp_data_to_reload[4], get(draw_aurora_ref))
	reload_true_false[5]=check_need_reload(temp_data_to_reload[5], get(draw_scattering_ref))
	reload_true_false[6]=check_need_reload(temp_data_to_reload[6], get(draw_volume_fog01_ref))
	reload_true_false[7]=check_need_reload(temp_data_to_reload[7], get(draw_per_pix_liting_ref))
	reload_true_false[8]=check_need_reload(temp_data_to_reload[8], get(draw_objs_06_ref))
	reload_true_false[9]=check_need_reload(temp_data_to_reload[9], get(draw_vecs_03_ref))
	reload_true_false[10]=check_need_reload(temp_data_to_reload[10], get(draw_for_05_ref))
	reload_true_false[11]=check_need_reload(temp_data_to_reload[11], get(inn_ring_density_ref))
	reload_true_false[12]=check_need_reload(temp_data_to_reload[12], get(mid_ring_density_ref))
	reload_true_false[13]=check_need_reload(temp_data_to_reload[13], get(out_ring_density_ref))
	reload_true_false[14]=check_need_reload(temp_data_to_reload[14], get(draw_detail_apt_03_ref))
	reload_true_false[15]=check_need_reload(temp_data_to_reload[15], get(comp_texes_ref))
	reload_true_false[16]=check_need_reload(temp_data_to_reload[16], get(extended_dsfs_ref))
	reload_true_false[17]=check_need_reload(temp_data_to_reload[17], get(tile_lod_bias_ref))
	reload_true_false[18]=check_need_reload(temp_data_to_reload[18], get(composite_far_dist_bias_ref))
	for iii = 1, 18, 1 do
		if reload_true_false[iii]==false then
			set(need_reload,1,1)
			break
		else
			set(need_reload,0,1)
		end
	
	end
end

function loading_preset_at_start(pr_num)
	settingsfilepath = moduleDirectory.."/settings and presets/preset_"..pr_num..".txt"
	existfile = isFileExists (settingsfilepath)
	settingsfile = io.open(settingsfilepath, "r")
	if existfile then
		local lines = settingsfile:read("*a")
		for k, v in string.gmatch(lines, "([%w%s%(%-%)]+)=([%d%p%-]+)") do
			set(ro_refs_values, tonumber(v), ii)
			ii=ii+1
		end
		settingsfile:close()
		ii=1
		set(static_plane_build_vis,get(ro_refs_values,8))
		set(static_plane_density,get(ro_refs_values,9))
		set(use_reflective_water,get(ro_refs_values,10))
		set(draw_fft_water,get(ro_refs_values,11))
		set(draw_reflect_water05,get(ro_refs_values,12))
		set(fft_amp1_ref,get(ro_refs_values,13))
		set(fft_amp2_ref,get(ro_refs_values,14))
		set(fft_amp3_ref,get(ro_refs_values,15))
		set(fft_amp4_ref,get(ro_refs_values,16))
		set(fft_scale1_ref,get(ro_refs_values,17))
		set(fft_scale2_ref,get(ro_refs_values,18))
		set(fft_scale3_ref,get(ro_refs_values,19))
		set(fft_scale4_ref,get(ro_refs_values,20))
		set(noise_speed_ref,get(ro_refs_values,21))
		set(noise_bias_gen_x_ref,get(ro_refs_values,22))
		set(noise_bias_gen_y_ref,get(ro_refs_values,23))
		set(csm_split_exterior,get(ro_refs_values,24))
		set(csm_split_interior,get(ro_refs_values,25))
		set(far_limit,get(ro_refs_values,26))
		set(scenery_shadows,get(ro_refs_values,27))
		set(cockpit_near_adjust,get(ro_refs_values,28))
		set(cockpit_near_proxy,get(ro_refs_values,29))
		set(shadow_cam_size,get(ro_refs_values,30))
		set(shadow_size,get(ro_refs_values,31))
		set(disable_shadow_prep,get(ro_refs_values,32))
		set(last_3d_pass,get(ro_refs_values,33))
		set(draw_cars_05_ref,get(ro_refs_values,35))
		set(draw_HDR_ref,get(ro_refs_values,43))
		set(use_bump_maps_ref,get(ro_refs_values,45))
		set(use_detail_textures_ref,get(ro_refs_values,46))
		set(ssao_enable_ref,get(ro_refs_values,47))
		set(first_res_3d_ref,get(ro_refs_values,48))
		set(last_res_3d_ref,get(ro_refs_values,49))
		set(cloud_shadow_lighten_ratio_ref,get(ro_refs_values,50))
		set(plot_radius_ref,get(ro_refs_values,51))
		set(overdraw_control_ref,get(ro_refs_values,52))
		set(ambient_gain_ref,get(ro_refs_values,53))
		set(diffuse_gain_ref,get(ro_refs_values,54))
		set(white_point_ref,get(ro_refs_values,55))
		set(atmo_scale_raleigh_ref,get(ro_refs_values,56))
		set(inscatter_gain_raleigh_ref,get(ro_refs_values,57))
		set(min_shadow_angle_ref,get(ro_refs_values,58))
		set(max_shadow_angle_ref,get(ro_refs_values,59))
		set(max_dsf_vis_ever_ref,get(ro_refs_values,60))
		set(dsf_fade_ratio_ref,get(ro_refs_values,61))
		set(dsf_cutover_scale_ref,get(ro_refs_values,62))
		set(min_tone_angle_ref,get(ro_refs_values,63))
		set(max_tone_angle_ref,get(ro_refs_values,64))
		set(tone_ratio_clean_ref,get(ro_refs_values,65))
		set(tone_ratio_foggy_ref,get(ro_refs_values,66))
		set(tone_ratio_hazy_ref,get(ro_refs_values,67))
		set(tone_ratio_snowy_ref,get(ro_refs_values,68))
		set(tone_ratio_ocast_ref,get(ro_refs_values,69))
		set(tone_ratio_strat_ref,get(ro_refs_values,70))
		set(tone_ratio_hialt_ref,get(ro_refs_values,71))
		set(inscatter_gain_mie,get(ro_refs_values,72))
		set(scatter_raleigh_r,get(ro_refs_values,73))
		set(scatter_raleigh_g,get(ro_refs_values,74))
		set(scatter_raleigh_b,get(ro_refs_values,75))
		set(sky_gain,get(ro_refs_values,76))
		set(visibility_reported_m_ref,get(ro_refs_values,77))
		set(LOD_bias_rat_ref,get(ro_refs_values,78))
		set(cars_lod_min_ref,get(ro_refs_values,79))
		set(fade_start_rat_ref,get(ro_refs_values,81))
		set(fog_be_gone_ref,get(ro_refs_values,83))
		set(scale_near_ref,get(ro_refs_values,84))
		set(scale_far_ref,get(ro_refs_values,85))
		set(dist_near_ref,get(ro_refs_values,86))
		set(dist_far_ref,get(ro_refs_values,87))
		set(exponent_near_ref,get(ro_refs_values,88))
		set(exponent_far_ref,get(ro_refs_values,89))
		set(bloom_near_ref,get(ro_refs_values,90))
		set(bloom_far_ref,get(ro_refs_values,91))
	end
end
function read_refs_on_apply()
	temp_ro_ref_values[1]=get(draw_deer_birds_ref)
	temp_ro_ref_values[2]=get(draw_fire_ball_ref)
	temp_ro_ref_values[3]=get(draw_boats_ref)
	temp_ro_ref_values[4]=get(draw_aurora_ref)
	temp_ro_ref_values[5]=get(draw_scattering_ref)
	temp_ro_ref_values[6]=get(draw_volume_fog01_ref)
	temp_ro_ref_values[7]=get(draw_per_pix_liting_ref)
	temp_ro_ref_values[8]=get(draw_objs_06_ref)
	temp_ro_ref_values[9]=get(draw_vecs_03_ref)
	temp_ro_ref_values[10]=get(draw_for_05_ref)
	temp_ro_ref_values[11]=get(inn_ring_density_ref)
	temp_ro_ref_values[12]=get(mid_ring_density_ref)
	temp_ro_ref_values[13]=get(out_ring_density_ref)
	temp_ro_ref_values[14]=get(draw_detail_apt_03_ref)
	temp_ro_ref_values[15]=get(comp_texes_ref)
	temp_ro_ref_values[16]=get(extended_dsfs_ref)
	temp_ro_ref_values[17]=get(tile_lod_bias_ref)
	temp_ro_ref_values[18]=get(composite_far_dist_bias_ref)
	temp_ro_ref_values[19]=get(static_plane_build_vis)
	temp_ro_ref_values[20]=get(static_plane_density)
	temp_ro_ref_values[21]=get(use_reflective_water)
	temp_ro_ref_values[22]=get(draw_fft_water)
	temp_ro_ref_values[23]=get(draw_reflect_water05)
	temp_ro_ref_values[24]=get(fft_amp1_ref)
	temp_ro_ref_values[25]=get(fft_amp2_ref)
	temp_ro_ref_values[26]=get(fft_amp3_ref)
	temp_ro_ref_values[27]=get(fft_amp4_ref)
	temp_ro_ref_values[28]=get(fft_scale1_ref)
	temp_ro_ref_values[29]=get(fft_scale2_ref)
	temp_ro_ref_values[30]=get(fft_scale3_ref)
	temp_ro_ref_values[31]=get(fft_scale4_ref)
	temp_ro_ref_values[32]=get(noise_speed_ref)
	temp_ro_ref_values[33]=get(noise_bias_gen_x_ref)
	temp_ro_ref_values[34]=get(noise_bias_gen_y_ref)
	temp_ro_ref_values[35]=get(csm_split_exterior)
	temp_ro_ref_values[36]=get(csm_split_interior)
	temp_ro_ref_values[37]=get(far_limit)
	temp_ro_ref_values[38]=get(scenery_shadows)
	temp_ro_ref_values[39]=get(cockpit_near_adjust)
	temp_ro_ref_values[40]=get(cockpit_near_proxy)
	temp_ro_ref_values[41]=get(shadow_cam_size)
	temp_ro_ref_values[42]=get(shadow_size)
	temp_ro_ref_values[43]=get(disable_shadow_prep)
	temp_ro_ref_values[44]=get(last_3d_pass)
	temp_ro_ref_values[45]=get(draw_cars_05_ref)
	temp_ro_ref_values[46]=get(draw_HDR_ref)
	temp_ro_ref_values[47]=get(use_bump_maps_ref)
	temp_ro_ref_values[48]=get(use_detail_textures_ref)
	temp_ro_ref_values[49]=get(ssao_enable_ref)
	temp_ro_ref_values[50]=get(first_res_3d_ref)
	temp_ro_ref_values[51]=get(last_res_3d_ref)
	temp_ro_ref_values[52]=get(cloud_shadow_lighten_ratio_ref)
	temp_ro_ref_values[53]=get(plot_radius_ref)
	temp_ro_ref_values[54]=get(overdraw_control_ref)
	temp_ro_ref_values[55]=get(ambient_gain_ref)
	temp_ro_ref_values[56]=get(diffuse_gain_ref)
	temp_ro_ref_values[57]=get(white_point_ref)
	temp_ro_ref_values[58]=get(atmo_scale_raleigh_ref)
	temp_ro_ref_values[59]=get(inscatter_gain_raleigh_ref)
	temp_ro_ref_values[60]=get(min_shadow_angle_ref)
	temp_ro_ref_values[61]=get(max_shadow_angle_ref)
	temp_ro_ref_values[62]=get(max_dsf_vis_ever_ref)
	temp_ro_ref_values[63]=get(dsf_fade_ratio_ref)
	temp_ro_ref_values[64]=get(dsf_cutover_scale_ref)
	temp_ro_ref_values[65]=get(min_tone_angle_ref)
	temp_ro_ref_values[66]=get(max_tone_angle_ref)
	temp_ro_ref_values[67]=get(tone_ratio_clean_ref)
	temp_ro_ref_values[68]=get(tone_ratio_foggy_ref)
	temp_ro_ref_values[69]=get(tone_ratio_hazy_ref)
	temp_ro_ref_values[70]=get(tone_ratio_snowy_ref)
	temp_ro_ref_values[71]=get(tone_ratio_ocast_ref)
	temp_ro_ref_values[72]=get(tone_ratio_strat_ref)
	temp_ro_ref_values[73]=get(tone_ratio_hialt_ref)
	temp_ro_ref_values[74]=get(inscatter_gain_mie)
	temp_ro_ref_values[75]=get(scatter_raleigh_r)
	temp_ro_ref_values[76]=get(scatter_raleigh_g)
	temp_ro_ref_values[77]=get(scatter_raleigh_b)
	temp_ro_ref_values[78]=get(sky_gain)
	temp_ro_ref_values[79]=get(visibility_reported_m_ref)
	temp_ro_ref_values[80]=get(LOD_bias_rat_ref)
	temp_ro_ref_values[81]=get(cars_lod_min_ref)
	temp_ro_ref_values[82]=get(fade_start_rat_ref)
	temp_ro_ref_values[83]=get(fog_be_gone_ref)
	temp_ro_ref_values[84]=get(scale_near_ref)
	temp_ro_ref_values[85]=get(scale_far_ref)
	temp_ro_ref_values[86]=get(dist_near_ref)
	temp_ro_ref_values[87]=get(dist_far_ref)
	temp_ro_ref_values[88]=get(exponent_near_ref)
	temp_ro_ref_values[89]=get(exponent_far_ref)
	temp_ro_ref_values[90]=get(bloom_near_ref)
	temp_ro_ref_values[91]=get(bloom_far_ref)

end
function set_refs_on_apply()
	set(draw_deer_birds_ref,	temp_ro_ref_values[1])
	set(draw_fire_ball_ref,	temp_ro_ref_values[2])
	set(draw_boats_ref,	temp_ro_ref_values[3])
	set(draw_aurora_ref,	temp_ro_ref_values[4])
	set(draw_scattering_ref,	temp_ro_ref_values[5])
	set(draw_volume_fog01_ref,	temp_ro_ref_values[6])
	set(draw_per_pix_liting_ref,	temp_ro_ref_values[7])
	set(draw_objs_06_ref,	temp_ro_ref_values[8])
	set(draw_vecs_03_ref,	temp_ro_ref_values[9])
	set(draw_for_05_ref,	temp_ro_ref_values[10])
	set(inn_ring_density_ref,	temp_ro_ref_values[11])
	set(mid_ring_density_ref,	temp_ro_ref_values[12])
	set(out_ring_density_ref,	temp_ro_ref_values[13])
	set(draw_detail_apt_03_ref,	temp_ro_ref_values[14])
	set(comp_texes_ref,	temp_ro_ref_values[15])
	set(extended_dsfs_ref,	temp_ro_ref_values[16])
	set(tile_lod_bias_ref,	temp_ro_ref_values[17])
	set(composite_far_dist_bias_ref,	temp_ro_ref_values[18])
	set(static_plane_build_vis,	temp_ro_ref_values[19])
	set(static_plane_density,	temp_ro_ref_values[20])
	set(use_reflective_water,	temp_ro_ref_values[21])
	set(draw_fft_water,	temp_ro_ref_values[22])
	set(draw_reflect_water05,	temp_ro_ref_values[23])
	set(fft_amp1_ref,	temp_ro_ref_values[24])
	set(fft_amp2_ref,	temp_ro_ref_values[25])
	set(fft_amp3_ref,	temp_ro_ref_values[26])
	set(fft_amp4_ref,	temp_ro_ref_values[27])
	set(fft_scale1_ref,	temp_ro_ref_values[28])
	set(fft_scale2_ref,	temp_ro_ref_values[29])
	set(fft_scale3_ref,	temp_ro_ref_values[30])
	set(fft_scale4_ref,	temp_ro_ref_values[31])
	set(noise_speed_ref,	temp_ro_ref_values[32])
	set(noise_bias_gen_x_ref,	temp_ro_ref_values[33])
	set(noise_bias_gen_y_ref,	temp_ro_ref_values[34])
	set(csm_split_exterior,	temp_ro_ref_values[35])
	set(csm_split_interior,	temp_ro_ref_values[36])
	set(far_limit,	temp_ro_ref_values[37])
	set(scenery_shadows,	temp_ro_ref_values[38])
	set(cockpit_near_adjust,	temp_ro_ref_values[39])
	set(cockpit_near_proxy,	temp_ro_ref_values[40])
	set(shadow_cam_size,	temp_ro_ref_values[41])
	set(shadow_size,	temp_ro_ref_values[42])
	set(disable_shadow_prep,	temp_ro_ref_values[43])
	set(last_3d_pass,	temp_ro_ref_values[44])
	set(draw_cars_05_ref,	temp_ro_ref_values[45])
	set(draw_HDR_ref,	temp_ro_ref_values[46])
	set(use_bump_maps_ref,	temp_ro_ref_values[47])
	set(use_detail_textures_ref,	temp_ro_ref_values[48])
	set(ssao_enable_ref,	temp_ro_ref_values[49])
	set(first_res_3d_ref,	temp_ro_ref_values[50])
	set(last_res_3d_ref,	temp_ro_ref_values[51])
	set(cloud_shadow_lighten_ratio_ref,	temp_ro_ref_values[52])
	set(plot_radius_ref,	temp_ro_ref_values[53])
	set(overdraw_control_ref,	temp_ro_ref_values[54])
	set(ambient_gain_ref,	temp_ro_ref_values[55])
	set(diffuse_gain_ref,	temp_ro_ref_values[56])
	set(white_point_ref,	temp_ro_ref_values[57])
	set(atmo_scale_raleigh_ref,	temp_ro_ref_values[58])
	set(inscatter_gain_raleigh_ref,	temp_ro_ref_values[59])
	set(min_shadow_angle_ref,	temp_ro_ref_values[60])
	set(max_shadow_angle_ref,	temp_ro_ref_values[61])
	set(max_dsf_vis_ever_ref,	temp_ro_ref_values[62])
	set(dsf_fade_ratio_ref,	temp_ro_ref_values[63])
	set(dsf_cutover_scale_ref,	temp_ro_ref_values[64])
	set(min_tone_angle_ref,	temp_ro_ref_values[65])
	set(max_tone_angle_ref,	temp_ro_ref_values[66])
	set(tone_ratio_clean_ref,	temp_ro_ref_values[67])
	set(tone_ratio_foggy_ref,	temp_ro_ref_values[68])
	set(tone_ratio_hazy_ref,	temp_ro_ref_values[69])
	set(tone_ratio_snowy_ref,	temp_ro_ref_values[70])
	set(tone_ratio_ocast_ref,	temp_ro_ref_values[71])
	set(tone_ratio_strat_ref,	temp_ro_ref_values[72])
	set(tone_ratio_hialt_ref,	temp_ro_ref_values[73])
	set(inscatter_gain_mie,	temp_ro_ref_values[74])
	set(scatter_raleigh_r,	temp_ro_ref_values[75])
	set(scatter_raleigh_g,	temp_ro_ref_values[76])
	set(scatter_raleigh_b,	temp_ro_ref_values[77])
	set(sky_gain,	temp_ro_ref_values[78])
	set(visibility_reported_m_ref,	temp_ro_ref_values[79])
	set(LOD_bias_rat_ref,	temp_ro_ref_values[80])
	set(cars_lod_min_ref,	temp_ro_ref_values[81])
	set(fade_start_rat_ref,	temp_ro_ref_values[82])
	set(fog_be_gone_ref,	temp_ro_ref_values[83])
	set(scale_near_ref,	temp_ro_ref_values[84])
	set(scale_far_ref,	temp_ro_ref_values[85])
	set(dist_near_ref,	temp_ro_ref_values[86])
	set(dist_far_ref,	temp_ro_ref_values[87])
	set(exponent_near_ref,	temp_ro_ref_values[88])
	set(exponent_far_ref,	temp_ro_ref_values[89])
	set(bloom_near_ref,	temp_ro_ref_values[90])
	set(bloom_far_ref,	temp_ro_ref_values[91])

end
function onPlaneUnloaded()
	if apply_pushed==false and load_at_start==1 then
		timevarlogic=10
	end
end

function onPlaneLoaded()
	if timevarlogic==10 then
		timevarlogic=11
	end
	if apply_pushed then
		apply_pushed=false
	end
	
end
function onAirportLoaded()
	
end
function onSceneryLoaded()
	
	if apply_pushed==true then
		if version>11110 then
			sasl.commandOnce(reload_aircraft)
			set_refs_on_apply()
		else
			set_refs_on_apply()
		end
		timevarlogiconreload=5
		set(ro_sett,10,20) -- show pic
	end
end

function update()
	if timevarlogiconreload>0 then
		timevarlogiconreload=timevarlogiconreload-0.02
		
	end
	if timevarlogiconreload>4 and get(ro_sett,19)==0 then
		print("1")
		sasl.commandOnce(next_livery)
		set(ro_sett,1,19)
	elseif timevarlogiconreload>2 and timevarlogiconreload<3 and get(ro_sett,19)==1 then
		print("2")
		sasl.commandOnce(prev_livery)	
		apply_pushed=false
		set(ro_sett,3,19)
	elseif timevarlogiconreload>0 and timevarlogiconreload<0.2 and get(ro_sett,19)==3 then
		set(ro_sett,2,19)
		
	end
	
	if get(need_reload,2)==1 then
		assign_values()
		set(need_reload,0,2)
		set(need_reload,0,1)
		apply_pushed=true
		read_refs_on_apply()
		sasl.commandOnce(reload_scenery)
		
		
	end	
	if StartTimerIDLogic ~= 0 then
		timevarlogic = sasl.getElapsedSeconds(StartTimerIDLogic)
	end
	-------------------------логика - если старт сима - сначала перезагруз самолета, а потом загруз рефов
	
	if load_at_start==0 then
		if timevarlogic>3 and get(ro_sett,19)==0 and get(ro_sett,2)>0 then
			if get(need_reload,3)==1 then
				
				if version>11110 then
					sasl.commandOnce(reload_aircraft)
					set(need_reload,2,3)
				else
					print("3")
					sasl.commandOnce(next_livery)
					--sasl.commandOnce(prev_livery)	
				end
			end
			readrefslogic()
			assign_values()
			loading_preset_at_start(get(ro_sett,2))
			set(ro_sett,1,19)
		elseif timevarlogic>3 and get(ro_sett,19)==0 and get(ro_sett,2)==0 then
			readrefslogic()
			assign_values()
			set(ro_sett,1,19)
			
		elseif timevarlogic>5 and get(ro_sett,19)==1 and timevarlogic<7 then					------LOADING TIMER
			if get(need_reload,3)==1 then
				if version>11110 then
				else
					print("8")
					sasl.commandOnce(prev_livery)
				end
			end
			sasl.stopTimer(StartTimerIDLogic)
			sasl.deleteTimer(StartTimerIDLogic)
			StartTimerIDLogic=0
			timevarlogic=0
			load_at_start=1
			set(ro_sett,0,19)
		end
	else
		if timevarlogic==11 and get(ro_sett,2)>0 then
			readrefslogic()
			assign_values()
			loading_preset_at_start(get(ro_sett,2))
			if version>11110 then
			else
				print("6")
				sasl.commandOnce(next_livery)
			end
			timevarlogic=12
		elseif timevarlogic>14 then
			if version>11110 then
			else
				print("7")
				sasl.commandOnce(prev_livery)
			end
			timevarlogic=0
		end
		if timevarlogic>=12 then
			timevarlogic=timevarlogic+0.05
		end
	end
	
	
	if StartTimerIDLogic==0 then
	--print(get(startup_running))
		need_reload_func()
		if get(ro_sett,3) == 1 and get(LOD_xp_paused) == 0 then                                              -- do it only when in "auto"-mode
			if os.clock() > LOD_akt_time + (get(ro_sett,8)/1000) then                  -- check if wait-time is over
			  local akt_fps = 1/get(LOD_xp_framerate)
			  if akt_fps > get(ro_sett,7) then 
				set(LOD_bias_rat_ref, get(LOD_bias_rat_ref)-0.1)
			  end
			  if akt_fps < get(ro_sett,6) then 
				set(LOD_bias_rat_ref, get(LOD_bias_rat_ref)+0.1)
			  end
			  if LOD_fps_average > get(ro_sett,6) + 1 and akt_fps > get(ro_sett,6) then
				set(LOD_bias_rat_ref, get(LOD_bias_rat_ref) - ((LOD_fps_average - get(ro_sett,6)) / 200))
			  end
			  LOD_akt_time = os.clock()
			end
			if get(LOD_bias_rat_ref) > 9.9 then set(LOD_bias_rat_ref, 9.9) end
			if get(LOD_bias_rat_ref) < 0 then set(LOD_bias_rat_ref,0) end
			if get(LOD_xp_obf_akt) > 1.0 then set(LOD_xp_obf_akt, 1.0) end
			if get(LOD_xp_obf_akt) < 0 then set(LOD_xp_obf_akt, 0) end
		end
	  
	  
		if get(LOD_xp_paused) == 0 then 
			LOD_fps_average = ((LOD_fps_average * count) + (1/get(LOD_xp_framerate))) / (count + 1)
			count = count + 1
			if count > 5 then count = 5 end
		end
	  -----GrayHorizon
		if get(ro_sett,4) == 1 then
			if (get(altitude) > (get(clouds_base_0) - 50)) and (get(altitude) < get(clouds_top_0)) and (get(clouds_type_0) > 0)	then grayhor = 0
				
			elseif (get(altitude) > (get(clouds_base_1) - 50)) and (get(altitude) < get(clouds_top_1)) and (get(clouds_type_1) > 0)	then grayhor = 0
				
			elseif (get(altitude) > (get(clouds_base_2) - 50)) and (get(altitude) < get(clouds_top_2)) and (get(clouds_type_2) > 0)	then grayhor = 0
					
			else grayhor = 1
					
			end
			set(white_out_in_clouds, grayhor)
		end
		if get(env_active)==1 then set(ro_sett,1,1) elseif get(env_active)==0 then set(ro_sett,0,1) end
		if get(ro_sett,10)==1 then
			if get(wave_length) < 12 then
				set(fft_amp1_ref, 0.5)
				set(fft_amp2_ref, 1.0)
				set(fft_amp3_ref, 0.5)
				set(fft_amp4_ref, 0.5)
				set(fft_scale1_ref, 5)
				set(fft_scale2_ref, 1)
				set(fft_scale3_ref, 20)
				set(fft_scale4_ref, 128)
				set(noise_speed_ref,8.809999)
			elseif get(wave_length) >= 12 and get(wave_length) < 45 then
				set(fft_amp1_ref, 0.5)
				set(fft_amp2_ref, 1.0)
				set(fft_amp3_ref, 0.5)
				set(fft_amp4_ref, 1)
				set(fft_scale1_ref, 5)
				set(fft_scale2_ref, 2)
				set(fft_scale3_ref, 20)
				set(fft_scale4_ref, 64)
				set(noise_speed_ref,6.809999)
			else
				set(fft_amp1_ref, 0.5)
				set(fft_amp2_ref, 1.0)
				set(fft_amp3_ref, 0.5)
				set(fft_amp4_ref, 1)
				set(fft_scale1_ref, 5)
				set(fft_scale2_ref, 3)
				set(fft_scale3_ref, 20)
				set(fft_scale4_ref, 64)
				set(noise_speed_ref,3.809999)
			end
		end
	end
end	
