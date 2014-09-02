--
--Fireworks by InfinityProject
--License code and textures WTFPL 
--Thanks to Mauvebic, Cornernote, and Neuromancer

--REWRITE BY: crayzginger72 (2014)

--Sound will be added soon

local colours_list = {
	{"rainbow", "Rainbow"},
	{"red",     "Red"},
	{"green",   "Green"},
	{"blue",    "Blue"},
	{"purple",  "Purple"},
	{"orange",  "Orange"},
	{"yellow",  "Yellow"},
	{"white",   ""} ,
 }

for i in ipairs(colours_list) do
	local colour = colours_list[i][1]
	local desc = colours_list[i][2]

	if colour == "white" then 
		minetest.register_node("fireworks:white", {
			drawtype = "airlike",
			--tiles = {"fireworks_"..colour..".png"},
			light_source = 14,
			--visual_scale = 2,
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = false,
			pointable = false,
			groups = {cracky=3,not_in_creative_inventory=1, falling_node=1},
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_abm({
			nodenames = {"fireworks:white"},
			interval =12,
			chance = 1,	
			
			action = function(pos, node, active_object_count, active_object_count_wider)
				if node.name == "fireworks:white" then
					minetest.remove_node(pos,{name="fireworks:white"})  
				end
			end
		})

		return
	end

	minetest.register_node("fireworks:firework_"..colour, {
		description = desc.." Fireworks",
		tiles = {"fireworks_firework_"..colour..".png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		mesecons = {effector = { action_on = function(pos, node)
			local f_colour = colour
			fireworks_activate(pos, node, f_colour)
			end}},

		on_rightclick = function(pos, node, clicker)
			local f_colour = colour
			fireworks_activate(pos, node, f_colour)
	 	end	
	})

	minetest.register_node("fireworks:"..colour, {
		drawtype = "plantlike",
		description = desc,
		tiles = {"fireworks_"..colour..".png"},
		light_source = 14,
		sunlight_propagates = true,
		walkable = false,
		is_ground_content = true,
		pointable = false,
		groups = {cracky=3,not_in_creative_inventory=1},--, hot=1, igniter=3}, --<<<<to enable fire
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("fireworks:2"..colour, {
		drawtype = "plantlike",
		description = desc,
		tiles = {"fireworks_"..colour..".png"},
		light_source = 14,
		sunlight_propagates = true,
		walkable = false,
		is_ground_content = true,
		pointable = false,
		groups = {cracky=3,not_in_creative_inventory=1},--, hot=1, igniter=3}, --<<<<to enable fire
		sounds = default.node_sound_stone_defaults(),
	})

	if colour ~= "rainbow" then
		minetest.register_craft({
			output = "fireworks:firework_"..colour.." 2",
			recipe = {
				{"default:wood", "default:wood",  "default:wood"},
				{"default:wood", "default:torch", "default:wood"},
				{"default:wood", "dye:"..colour,  "default:wood"}
			}
		})
	else
		minetest.register_craft({
			type = "shapeless",
			output = "fireworks:firework_rainbow 6",
			recipe = {"fireworks:firework_red", "fireworks:firework_green", "fireworks:firework_blue", "fireworks:firework_purple", "fireworks:firework_orange", "fireworks:firework_yellow"},
		})
	end

	function fireworks_activate (pos, node, f_colour)
	local zrand = math.random(-5, 5)
	local xrand = math.random(-5,5)
	local yrand = math.random(25, 40)
	minetest.sound_play("FireworkCombo44q5", {
		pos={x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		max_hear_distance = 90,
		gain = 3,
	})
	if minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name ~= "air" 
	and minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name ~= "fireworks:white"
	and minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name ~= "ignore" then return end
	minetest.remove_node(pos,{name="fireworks:firework_"..colour})
	minetest.add_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},{name='fireworks:white'})
	minetest.add_particlespawner({
		amount = 250,
		time = .1,
		minpos = {x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		maxpos = {x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		minvel = {x=-04, y=-04, z=-04},
 		maxvel = {x=04, y=04, z=04},
 		minacc = {x=0, y=-0.2, z=0},
  		maxacc = {x=0, y=-0.6, z=0},
  		minexptime = .6,
  		maxexptime = .6,
  		minsize = 1,
 		maxsize = 5,
 		collisiondetection = false,
  		vertical = false,
  		texture = "fireworks_yellow.png",
	})
	if node.name == "fireworks:firework_"..f_colour then
		local radius = math.random(5,8)
			for x=-radius,radius do
			for y=-radius,radius do
			for z=-radius,radius do
				local w = radius/2+5
		   		if x*x+y*y+z*z <= radius*radius then
		   			if minetest.get_node({x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand}).name == "air" 
		   			or minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name == "fireworks:white"
		   			or minetest.get_node({x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand}).name == "ignore" then
		    			minetest.add_node({x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand},{name="fireworks:white"}) 
		    			if x*x+y*y+z*z >= radius*radius-w then
		    				minetest.add_particle({
    							pos = {x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand},
    							vel = {x=0, y=0, z=0},
    							acc = {x=0, y=-0.5, z=0},
    							expirationtime = math.random((radius/3)+(yrand/6), (radius/3)+(yrand/6)-4) ,
    							size = math.random(3, 6),
    							collisiondetection = false,
    							vertical = false,
    							texture = "fireworks_"..f_colour..".png"
						})
		    			end
		    		end
				end
			end
			end
			end
		end
	end
end

print("Fireworks Mod Loaded v2.0!")
