--
--Fireworks by InfinityProject
--License code and textures WTFPL 
--Thanks to Mauvebic, Cornernote, and Neuromancer

--REWRITE BY: crayzginger72 (2014)

--Sound will be added soon

local pr = PseudoRandom(1562425)
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
			drawtype = "plantlike",
			tiles = {"fireworks_"..colour..".png"},
			light_source = 14,
			visual_scale = 2,
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = true,
			pointable = false,
			groups = {cracky=3,not_in_creative_inventory=1, falling_node=1},
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_abm({
			nodenames = {"fireworks:white"},
			interval =2,
			chance = 2,	
			
			action = function(pos, node, active_object_count, active_object_count_wider)
				if node.name == "fireworks:white" then
					minetest.remove_node(pos,{name="fireworks:white"})  
				end
			end
		})

		return
	end

	minetest.register_abm({
		nodenames = {"fireworks:"..colour},
		interval = 2,
		chance = 1,	
			
		action = function(pos, node, active_object_count, active_object_count_wider)
			if node.name == "fireworks:"..colour then
				minetest.add_node(pos,{name="fireworks:2"..colour})  
			end
		end
	})

	minetest.register_abm({
		nodenames = {"fireworks:2"..colour},
		interval = 1,
		chance = 2,	
			
		action = function(pos, node, active_object_count, active_object_count_wider)
			if node.name == "fireworks:2"..colour then
				minetest.remove_node(pos,{name="fireworks:2"..colour})  
			end
		end
	})

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
	local zrand = pr:next(-5, 5)
	local xrand = pr:next(-5,5)
	local yrand = pr:next(25, 40)
	minetest.sound_play("FireworkCombo44q5", {
		pos={x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		max_hear_distance = 90,
		gain = 3,
	})

	minetest.add_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},{name='fireworks:white'}) 
	if node.name == "fireworks:firework_"..f_colour then
		local radius = pr:next(5,8)
			for x=-radius,radius do
			for y=-radius,radius do
			for z=-radius,radius do
				local w = radius/2+5
		   		if x*x+y*y+z*z <= radius*radius and  x*x+y*y+z*z >= radius*radius-w then
		   			if minetest.get_node({x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand}).name == "air" then
		    			minetest.add_node({x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand},{name='fireworks:'..f_colour}) 
		    		end
				end
			end
			end
			end
			minetest.remove_node(pos,{name="fireworks:firework_"..colour})
		end
	end
end

print("Fireworks Mod Loaded v2.0!")