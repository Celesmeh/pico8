pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--declarations
--transition
--timer for transition
tm=0
--tweak the transition
swap_speed=5
swap_start=30
swap_complete=60 
--first scene swap
current_draw=draw_logo
next_draw=draw_menu
next_scene=""
--mouse
mx=0
my=0
clicked=false

--stars
stars={}
scol={1,13,6,7,2}
warp_factor=3
--battles
counter=1
tim=0
counter+=.03
hit=false
--thruster animation
thrust=171
--wh
gxn=""
	--player---
	p={
	--currently equipped ship
	ship = curr_ship,
	--location
	loc=1,
	--money
	credits = 100,
	--start inv
	inventory = {
		iron=10,
		silica=5,
		palladium=0
	},
}
 battle=false
--enemies
enemies={}
--different enemies
enemy_spr=
{
{sp=128,wh=1},
{sp=128,wh=1},
{sp=129,wh=1},
{sp=130,wh=2},
{sp=132,wh=2},
{sp=134,wh=4}
}
--damage multiplier
mult=0
--bases
--not sure if ill use this
base = {
	features = {
		trade = true,
		missions = true,
		upgrades = true,
		parts = true,
		mods = true,
	},
	current_mission = nil,
}

--space systems--------------------------
--starter galaxies, eventually 
--to be replaced with seeded rnd
--generation
galaxies = {
{
	--starter galaxy
	difficulty=1,
	faction ="order of the silver twilight",
	basenum=2,
	col= 3,
	name = "andromeda;s realm",
	systems = {
		"centauri void",
		"sothoth's expanse"
	},
	asteroidmax=2,
	beaconmax=2,
	enemymax=2,
	ores = {"IRON ALLOY "}
},
{
	--mid tier
	difficulty=2,
	faction = "order of the jade serpent",
	basenum=12,
	col= 9,
	name = "white river",
	systems = {
		"black sun",
		"serpents eye",
		"vega's expanse"
	},
	asteroidmax=4,
	beaconmax=3,
	enemymax=6,
	ores = {"SILICA    "}
},
{
	--hardmode
	difficulty=3,
	faction = "cult of the nameless",
	basenum=7,
	col= 8,
	name = "mad god's realm",
	systems = {
		"haunted nebula",
		"accursed cluster"
	},
	asteroidmax=6,
	beaconmax=3,
	enemymax=8,
	ores = { "PALLADIUM "}
}
}


--ships-------------------------
--[[name = cannon ship name,
	sprite
	w
	h
	hp= value that changes
	maxhp= saved max value
	capacity = value that changes
	maxcapacity = max
	main_slots = mod slots
	atk
	def
	mining
	mineboost= %muliply to mining
	atkboost=% multi to atk
	defboost=%multi to def
	ability = probably wont use
	atk_spd= used to modify attack speed
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods=will likely have the boosts in it ]]--	
--ship table
ships = {
--starter ships--
{
	--base ship
	name = "MOONLIGHT",
	sprite=001,
	w=1,
	h=1,
	hp=15,
	maxhp= 15,
	capacity = 0,
	maxcapacity = 12,
	main_slots = 1,
	atk=1,
	def = 1,
	mining=1,
	mineboost=.1,
	atkboost=.1,
	defboost=.1,
	ability = "",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
	--mining ship
	name = "VOID REAVER",
	sprite=002,
	w=1,
	h=1,
	hp=30,
	maxhp= 30,
	capacity = 80,
	maxcapacity = 80,
	main_slots = 1,
	atk=1,
	def = 1,
	mining=5,
	mineboost=2,
	atkboost=0,
	defboost=0,
	ability = "MINING 200%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
	--atk ship
	name = "COSMOS CRUSHER",
	sprite=003,
	w=1,
	h=1,
	hp=25,
	maxhp= 25,
	capacity = 15,
	maxcapacity = 15,
	main_slots = 1,
	atk=5,
	def =1,
	mining=1,
	mineboost=0,
	atkboost=.33,
	defboost=-.25,
	ability = "ATTACK +33%, DEFENSE -25%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
	--def ship
	name = "TIME WEAVER",
	sprite=004,
	w=1,
	h=1,
	hp=30,
	maxhp= 30,
	capacity = 100,
	maxcapacity = 100,
	main_slots = 1,
	atk=1,
	def = 5,
	mining=1,
	mineboost=0,
	atkboost=0,
	defboost=2,
	ability = "DEFENSE +100% ",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
--specialized ships--
{
--good allrounder
	name = "ELDRITCH EXILE",
	sprite=017,
	w=2,
	h=2,
	hp=65,
	maxhp= 65,
	capacity = 40,
	maxcapacity = 40,
	main_slots = 1,
	atk=15,
	def = 15,
	mining=10,
	mineboost=0,
	atkboost=0,
	defboost=1,
	ability = "DEFENSE +100%",
	atk_spd=0,
	inventory = {
	iron=10,
	silica=0,
	palladium=0
	},
	mods={}
},
{
--miney dreadnought
	name = "CELESTIAL TITAN",
	sprite=019,
	w=2,
	h=2,
	hp=80,
	maxhp= 80,
	capacity = 150,
	maxcapacity = 150,
	main_slots = 2,
	atk=5,
	def = 15,
	mining=25,
	mineboost=.1,
	atkboost=0,
	defboost=.1,
	ability = "DEFENSE +10%, MINING +10%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
	--attack ship
	name = "DREAMING DREADNOUGHT",
	sprite=021,
	w=2,
	h=2,
	hp=75,
	maxhp= 75,
	capacity = 40,
	maxcapacity = 40,
	main_slots = 2,
	atk=25,
	def = 15,
	mining=5,
	mineboost=0,
	atkboost=.25,
	defboost=0,
	ability = "ATTACK +25%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
--def ship
	name = "SETLLAR SENTINEL",
	sprite=023,
	w=2,
	h=2,
	hp=150,
	maxhp= 150,
	capacity = 20,
	maxcapacity = 20,
	main_slots = 2,
	atk=5,
	def = 25,
	mining=10,
	mineboost=0,
	atkboost=0,
	defboost=2,
	ability = "DEFENSE 200% EFFECTIVE",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
--big boi ships--
{
	name = "CELESTIAL CORSAIR",
	sprite=009,
	w=4,
	h=2,
	hp=200,
	maxhp= 200,
	capacity = 60,
	maxcapacity = 60,
	main_slots = 4,
	atk=30,
	def = 20,
	mining=10,
	mineboost=0,
	atkboost=.2,
	defboost=.2,
	ability = "ATTACK +40 DEFENSE +20%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
{
	name = "COSMIC LEVIATHAN",
	sprite=041,
	w=4,
	h=2,
	hp=250,
	maxhp= 250,
	capacity = 100,
	maxcapacity = 100,
	main_slots = 4,
	atk=15,
	def = 30,
	mining=20,
	mineboost=.5,
	atkboost=0,
	defboost=.25,
	ability = "DEFENSE +25% MINING +50%",
	atk_spd=0,
	inventory = {
	iron=0,
	silica=0,
	palladium=0
	},
	mods={}
},
--pirate ships
{
 name = "SHOGGOTH'S SHADOW",
	sprite = 128,
	w = 1,
	h = 1,
	hp=20,
	maxhp= 20,
	capacity = 15,
	maxcapacity = 15,
	main_slots = 1,
	atk = 4,
	def = 4,
	mining = 3,
	mineboost = 0.15,
	atkboost = 0.1,
	defboost = 0.1,
	ability = "A STRANGE SMALL SHIP",
	atk_spd = 0,
	inventory = {
		iron=0,
		silica=0,
		palladium=0
	},
	mods={}
},
{
name = "CRIMSON CUTTER",
	sprite = 130,
	w = 2,
	h = 2,
	hp=70,
	maxhp= 70,
	capacity = 70,
	maxcapacity = 70,
	main_slots = 1,
	atk = 17,
	def = 17,
	mining = 15,
	mineboost = 0.1,
	atkboost = 0.2,
	defboost = 0,
	ability = "IT SEEMS TO CUT THE DARNESS",
	atk_spd = 0,
	inventory = {
		iron=0,
		silica=0,
		palladium=0
	},
	mods={}
},
{
	name = "DAGON'S FURY",
	sprite = 134,
	w = 4,
	h = 4,
	hp=250,
	maxhp= 250,
	capacity = 75,
	maxcapacity = 75,
	main_slots = 2,
	atk = 35,
	def = 30,
	mining = 20,
	mineboost = 0.2,
	atkboost = 0,
	defboost = 0.2,
	ability = "RABID DARKNESS",
	atk_spd = 0,
	inventory = {
		iron=0,
		silica=0,
		palladium=0
	},
	mods={}
}
}




-->8
--basic functions & scenes

--init--------------------------
function _init()
	--init player
	player={}
	--scene
	scene="game"
	--enable mouse
	poke(0x5f2d,1)
	--star bg stars
	init_star()
	--rotation
	rot=.125
	--debug assign ship
	curr_ship=ships[13]
	--debug
	curr_enemy=(flr(rnd(4)+1))
	
end

--update--------------------------
function _update60()
	--update state machine
	local update_funcs = {
	  fade = update_swap,
	  logo = update_logo,
	  menu = update_menu,
	  galaxy = update_galaxy,
	  system = update_system,
	  base = update_base,
	  wormhole = update_wormhole,
	  game = update_game
	}
 local update_func = update_funcs[scene]
 if update_func then
   update_func()
 end
	--universal counters
	tm += 0.085 
	rot+=1/360
	tim+=1
	counter+=.02
	--star movement w/warp 
	move_star()
	--battle logic
	battle_start()
 -- update mouse position 
 get_mouse()
 if clicked then sfx(00)  end
end
--draw--------------------------

function _draw()
	--draw state machine
	local draw_funcs = {
	  fade = draw_swap,
	  logo = draw_logo,
	  menu = draw_menu,
	  galaxy = draw_galaxy,
	  system = draw_system,
	  base = draw_base,
	  wormhole = draw_wormhole,
	  game = draw_game
	}
 local draw_func = draw_funcs[scene]
 if draw_func then
   draw_func()
 end
	--colors
	opacity(0,15)
 pal_swap(11,130)
 pal_swap(14,128)
 pal_swap(4,133)
 pal_swap(4,128)
 -- draw mouse cursor & click
 if lclick() then
		circfill(mx,my,5,8)
	end
	spr(16,mx,my)
end

--logo and menu not in use
--logo--------------------------
function update_logo()
	if btnp(❎) then
		init_swap(draw_logo,draw_menu,"menu")
	end
end

function draw_logo()
	cls()
	print("logo", 54,5,13)
	--transition()
end


--menu--------------------------
function update_menu()
	if btnp(❎) then
		init_swap(draw_menu, draw_game,"game")
	end
end

function draw_menu()
	cls(1)
	print("menu", 54,5,13)
	print("press",32,70,13)
	print("❎",55,71-1+sin(time()),13)
	print("to start",65,70,13)
end

-->8
--game update 

--update------------------------
function update_game()
	--debug spawn enemy
 if btnp(❎) then
		--randomize an enemy
	 curr_enemy=flr(rnd(5)+1)
	 add_enemy()
 end
 if btnp(🅾️) then

 end
	--animate the fiiiire
	anim_thrust()
end

--draw--------------------------
	function draw_game()
	cls()
	--ui stuff
	draw_ui()
	place_star()
	--system and ship info
	print("system:"..gxn, 5,5,9)
	print(
		sformat("HP:%\nATK:%\nDEF:",
		curr_ship.hp,
		curr_ship.atk,
		curr_ship.def),
		90,3,7)
		--is enemy created?
	if nme then
		print(enemies[1].name.." hp:"..enemies[1].hp.." def:"..enemies[1].def,5,70,7)
		spr(144,118,68) 
		if mouseover(118,69,124,75) then
			spr(145,118,68)
			if lclick() then 
				battle=true
				tim=3
				counter=1
			end
		end
	end
	--are you fightin' son?
	if battle then
		--slow stars
		warp_factor=1.5
		--draw enemy ship
		spr(thrust,90+(curr_ship.w*4),36+sin(tm*.1),1,1,true)
		spr(enemies[1].sprite,100-(enemies[1].w*4),41-enemies[1].h*4+sin(tm*.1),enemies[1].w,enemies[1].h,true)
		--draw battle ui
		draw_battle()	
	end
	--draw ship
	spr(curr_ship.sprite,35-(curr_ship.w*4),41-curr_ship.h*4+sin(tm*.1),curr_ship.w,curr_ship.h)
	spr(thrust,35-(curr_ship.w*4)-8,36+sin(tm*.1),1,1)
	--debug
	print(enemy_spr[curr_enemy].sp,10,30)
	print(enemy_spr[curr_enemy].wh,10,40)
end



-->8
--base
--init--------------------------
function init_base()
end

--update--------------------------
function update_base()
 mouse_state()
end

--draw--------------------------
function draw_base()
	--ui/background
	cls()
	place_star()
	draw_ui()
	--draw base
	pd_rotate(64, 39, rot, 2,20, 4, false, 1)
	print("base:"..galaxies[p.loc].name, 5,5,3)
	--draw menu
	base_menu()
	--debug
	print(mx,10,30)
	print(my,10,40)

end

--draw menu--------------------------
function base_menu()
	--print menu
	print("    ship  |  trade  |  upgrade", 1,60,7)
	--if below y
		if mouseover(11,58,42,66) then
			print("    ship  ", 1,60,8)
			if clicked then 
				sh= not sh 
				tr, up = false
			end
		--if tab2/trade
		elseif mouseover(43,58,84,66) then
			print("  trade  ", 45,60,8)
			if clicked then 
				tr= not tr
				sh, up = false 
			end
		--if tab3/upgrade
		elseif mouseover(86,58,126,66) then
			print("  upgrade", 85,60,8)    
			if clicked then 
				up= not up
				sh, tr = false 
			end
		end
	--go to each 
	if sh then ship() end
	if tr then trade() end
	if up then upgrade() end
end

--menu tabs--------------------------
--ship

function ship()
	--ship frame
	rectfill(10,87,61,116,13)
	rect(10,87,61,116,71)
	--transfer button
	spr(053,103,74,2,1)
	--transfer mouse

	--ship info txt
	print("SHIP INFORMATION ",32,70,7)
	print("NAME: "..curr_ship.name,5,79,7)
	--format list
	print(sformat("HP:   %\nATK:  %\ndEF:  %\nMINE: %\nCARGO:",curr_ship.hp,curr_ship.atk,curr_ship.def,curr_ship.mining,curr_ship.storage),70,87,7)
	--print ability
	print(curr_ship.ability,64-(64-#curr_ship.ability)/2,120,7)
	--ship sprite
	outline_sprite(0,.3,curr_ship.sprite,35-(curr_ship.w*4),102-curr_ship.h*4,curr_ship.w,curr_ship.h)
		if mouseover(105,74,116,80) then
		--mouseover
			outline("TRANSFER\nINVENTORY",mx-25,my-13,7,8)
			print(p.inventory.iron)
			print(p.inventory.silica)
			print(p.inventory.palladium)
			print(curr_ship.inventory.iron)
			print(curr_ship.inventory.silica) 
    
			if clicked==true then
			--click
			inv_transfer()
			if cavl==curr_ship.maxcapacity then
	cval=0
	end
			end
		end
end

--trade
function trade()
--debug price
local amt=10
--print ui
	print("TRADE CENTRE ",40,70,7)
 print("CREDITS: "..p.credits,5,15,7)
 print("PLAYER           BASE",20,76,7)      
	price=10*galaxies[3].difficulty
	print(sformat(unpack(galaxies[p.loc].ores),price),70,85,7)
	print(sformat("IRON ALLOY:%\nSILICA:    %\nPALLADIUM: ",p.inventory.iron,p.inventory.silica,p.inventory.palladium),5,85,7)
	print("SELL              BUY",20,110,7)
	--mouse highlight
	if mouseover(19,111,33,114) then
		print("SELL",20,110,8)
		if lclick() then
			print("sell",10,10,10)
		end
	elseif mouseover(91,111,103,114)then
		print("BUY",92,110,8)
		if lclick() then
			print("buy",10,10,10)
		end
	end
end

--upgrade
function upgrade()
	print(" UPGRADE STATION ",32,70,7)
       
end

--inventory transfer
--from ship
function inv_transfer()
 for k,v in pairs(curr_ship.inventory) do
 	p.inventory[k]=p.inventory[k]+v
 	curr_ship.inventory[k]=0
 end
end 

--to ship
function inv_transfertop()
	local resources = {"iron", "silica", "palladium"}
	local cval = curr_ship.capacity
	for i = 1, curr_ship.maxcapacity do
		for _, resource in ipairs(resources) do
			if cval < curr_ship.maxcapacity and p.inventory[resource] > 0 then
				curr_ship.inventory[resource] += 1
				p.inventory[resource] -= 1
				cval += 1
			end
		end
	end
	curr_ship.capacity = cval
end




-->8
--hold for future scene



-->8
--current code being worked on

function hp_change
	--takes player curr hp
	--changed current hp to hp-dmg
	--assigns new hp
	--same for enemy, 
	--first to hit 0
	--player die- go to base/lost ship
	--enemy die get loot
end


-->8
--tools

--mouse-------------------------
function get_mouse()
    mx,my=stat(32), stat(33)
    mx=min(max(mx,0),128)
    my=min(max(my,0),128)
end

function mousepress()
	return stat(34)!=0
end

function lclick()
	return stat(34)&1!=0
end

function rclick()
	return stat(34)&2!=0
end

function mouse_state()
  clicked = lclick() and not lstate
  lstate = lclick()
end

function mouseover(x1,y1,x2,y2)
	return mx>x1 and mx<x2 and my>y1 and my<y2
end
--rotation & animation----------------------
--animate the ship thrust
function anim_thrust()
	thrust=thrust+1
	if thrust>175 then
		thrust=171
	end
end

--rotate sprites on map
function pd_rotate(x,y,rot,mx,my,w,flip,scale)
  scale=scale or 1
  w*=scale*4
  local cs, ss = cos(rot)*.125/scale,sin(rot)*.125/scale
  local sx, sy = mx+cs*-w, my+ss*-w
  local hx = flip and -w or w
  local halfw = -w
  for py=y-w, y+w do
    tline(x-hx, py, x+hx, py, sx-ss*halfw, sy+cs*halfw, cs, ss)
    halfw+=1
  end
end

--palette stuff-----------------
--swap opacity
function opacity(col1,col2)
	palt(col1,false)
	palt(col2,true)
end

--pal swap
function pal_swap(col1,col2)
 	pal(col1,col2,1)
end

--transition--------------------
--sawp to transition scene
function init_swap(cd,nd,ns)
	swap={cnt=0}
	scene="fade"
	current_draw=cd
	next_draw=nd
	next_scene=ns
end

--pre draw scene
function draw_swap()
	--pre-draw
	if swap.cnt<swap_start then
		current_draw()
	else
		next_draw()
	end
	-- transition animation
		transition()
end

--update scene
function update_swap()
	swap.cnt+=1
	if swap.cnt>swap_complete then
		scene=next_scene
	end
end

--circle transition
function transition()
 for i=0,8 do -- column loop
  for j=0,8 do -- row loop
    local x = i*16
    local swing1 = sin(tm+i*0.1)
    local swing2 = sin(tm/4+j*0.03)
    local y = j*16 + swing1*10
    if tm>.7 then
    	circfill(x, y, swing2*15, 7)
  		end
  end
 end
end

--outlining---------------------
--outline text
function outline(s,x,y,c1,c2)
	for i=0,2 do
		for j=0,2 do
			if not(i==1 and j==1) then
				print(s,x+i,y+j,c1)
			end
		end
	end
	print(s,x+1,y+1,c2)
end

--outline sprites
function outline_sprite(outcol,thicc,n,x,y,...)
	memset(0x5f01,outcol,0xe) --nice
	for a=0,1,.25/thicc do
		spr(n,x+mid(-1,cos(a)*2,1),y+mid(-1,sin(a)*20,1),...)
	end
	pal()
	opacity(0,15)
	spr(n,x,y,...)
end

--format------------------------
function sformat(s, ...)
	local args, rs = {...}, ""
	for i,seg in ipairs(split(s, "%")) do
		rs ..= seg .. (args[i] or "")
	end
	return rs
end

--graphics----------------------
--ui
function draw_ui()
	map(0,0,0,0,16,16)
	rect(1,1,126,22,7)
	rect(1,57,126,126,7)
	rect(1,57,126,67,7)
end

--stars
--start the stars/fill table
function init_star()
	for i=1,#scol do
		for j=1,4 do
			local s={
			x=flr(rnd(128)),
			y=24+flr(rnd(32)),
			z=i,
			c=scol[i]
			}
			add(stars,s)
		end 
	end
end

--place on ui
function move_star()
	for s in all(stars) do
		-- move star, based on z-order depth
		s.x+=-s.z*warp_factor/10
		-- wrap star around the screen
		if s.x<0 then
			s.x=128
			s.y=24+flr(rnd(32))
		end
	end
end


--animate
function place_star()
	for s in all(stars) do
		pset(s.x,s.y,s.c)
		if warp_factor>3 then
			rectfill(1,57,126,126,11)
			rect(1,57,126,126,7)
			print("\^w\^twarping!",35,85,flr(sin(time(9)*1.2)+8))
			for i=0,5 do
				pset(s.x+(i),s.y,s.c)
			end
		end
	end
end
----battle----------------------
--battle/bullet animations
function battle_start()
--janky shit for shooting
	if counter>2 then
		counter=1
		tim=0
		hit,shoot=true,true
	end
end

function draw_battle()
	--damage= 
	--player ship atk*atkboost
	dmg=flr(counter)*5
	if shoot then
		--player shot
		spr(5,35+tim,37+sin(tm*.1),1,1)
		--enemy shot
		spr(7,90-tim,37+sin(tm*.1),1,1)
		if counter==1	 then
		--pewpew
			spr(6,36,37+sin(tm*.1),1,1)
			spr(6,88,37+sin(tm*.1),1,1)
			sfx(01)
		end
	end
end

function add_enemy()
--adds enemy table
	--change difficulty based on ship size
	if curr_enemy==sm or curr_enemy==sm2 then
		mult=10
 elseif curr_enemy==md or curr_enemy==md2 then
 	mult=20
 elseif curr_enemy==lg then
 	mult=40
 end
 --enemy table
 new_enemy={
		name="enemy",
		--ship is our maxhp+random
		hp=curr_ship.maxhp+flr(10+rnd(mult*curr_ship.w)),
		sprite=enemy_spr[curr_enemy].sp,
		w=enemy_spr[curr_enemy].wh,
		h=enemy_spr[curr_enemy].wh,
		--matches current atk
		atk=curr_ship.atk,
		--matches def+
		def=curr_ship.def+flr(rnd(2*curr_ship.w)),
	}
	--adds enemies and tells you 
	--they exist
	add(enemies, new_enemy)
	nme=true
end

-->8
--space logic
--galaxies---------------------
--systems----------------------
--wormholes--------------------
--generate random wh name
function gen_wh_name()
  local consonants = {"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "q", "r", "s", "t", "v", "w", "x", "y", "z"}
  local vowels = {"a", "e", "i", "o", "u"}
  -- name will be 2 to 6 letters long
  local name_length = flr(rnd(4) + 2) 
  local name = ""
  --add consonants and vowels
  for i = 1, name_length do
    if i % 2 == 1 then
      -- add a consonant
      name = name .. consonants[flr(rnd(#consonants)) + 1]
    else
      -- add a vowel
      name = name .. vowels[flr(rnd(#vowels)) + 1]
    end
  end
  -- add two random numbers to the end of the name
  name = name .." ".. flr(rnd(10)) .. flr(rnd(10))
  return name
end
__gfx__
00000000ff5555affff2dffffffffffffddffdffffffffffff6666ffffffffff00000000ffffffffffbbbbbbbbb9bb7fffffffff000000000000000000000000
00000000f555efffff2dd5ff2f222fff6ddddfdffff1fffff677776ffff2ffff00000000fffffffffbb6bbeeeee9ffffffffffff000000000000000000000000
00700700ae55fffff2dfff5f612222ff5dd11fffff1c1fff67777776ff282fff00000000ffffffffbbbbbbffffffffffffffffff000000000000000000000000
000770009e5c75af62dfffff51cc726f51dc7d9ff1c7c1ff67777776f28782ff00000000fffffffebbeeefabb6bbffffffffffff000000000000000000000000
000770009e5cc59f52ddffff51ccc26f5dd11fffff1c1fff67777776ff282fff00000000fff9aaebb6bbbabbbbbbbbffffffffff000000000000000000000000
007007009e55ffff522c7dff511222ff51dddfdffff1ffff67777776fff2ffff00000000fff99eebbbbbbab6bbbbbbbbffffffff000000000000000000000000
00000000fee55ffff22ccdff1f111ffff11ffdfffffffffff677776fffffffff00000000ffffeebbbbbbbab000555bbbbeffffff000000000000000000000000
00000000ffeeed9fff2dffffffffffffffffffffffffffffff6666ffffffffff00000000ffffeeb6bbbbba000000006bbeefffff000000000000000000000000
17ffffffffffffffffffffffffffff8888ffffffffffffffffffffffffffffffffffffffffffeeebbbbbbab000000bbbbeffffff000000000000000000000000
177fffffffff111111dffffffffff288885fffffffff22dddd29fffffff1cccccc1ffffffff9aeeeebbbb9bb6bbbbbbbffffffff000000000000000000000000
1771ffffffffffff111d6fffffffff22fffffffffff22dddddd29fffff1111111111fffffff99aeeee6ee9eeeeeeeeffffffffff000000000000000000000000
171ffffffffffffdd6ffffffffff88888888fffffffffff222fffffff00161616000ffffffffffffeeeeef9eeeeeffffffffffff000000000000000000000000
f1fffffffffffddddd6ffffff68888a8a8a88ffffffff22fffffffffff0011000ccc6fffffffffffebbbbbffffffffffffffffff000000000000000000000000
ffffffffffffdddd1dd6fffff688a8888888885ffff222222222fffffff00111111cc6fffffffffffebb6beeeeee9fffffffffff000000000000000000000000
ffffffffff61ddddcc6d6fff662888888cc78895f2d0dd0dddddd2fffffff0110511c6ffffffffffffeeeeeeeebb9b7fffffffff000000000000000000000000
fffffffffff611dccc766d6ff56228888ccccc8a52ddddddd005dddd9fffff0110011c6fffffffffffffffffffffffffffffffff000000000000000000000000
eeeeeeeeff611ddcccc6d6ff552288888ccc88952ddddddd000ddd29fffff0110011c6ffffffffffffffffffffffffffffffffff000000000000000000000000
eeeeeeeeff5111ddcc6ddffff52292888888885ff220dd0ddddd22fffffff011111cc6ffffffffffffffff9fffffffffffffffff000000000000000000000000
eeeeeeeeffff111dddddfffff522229298a88ffffff222222222fffffff1110000ccc5fffffffffffff9ffffffffffffffffffff000000000000000000000000
eeeeeeeefffff1111ddfffffffff22222222fffffffff22fffffffffff11616160005fffffffff1111fffff9999999999ffff9ff000000000000000000000000
eeeeeeeefffffff11dffffffffffff28fffffffffffffff222fffffff00111111111fffffff99199991f99979ff9777779999fff000000000000000000000000
eeeeeeeeffffffff111d6ffffffff288885ffffffff22dddddd29fffff001ccccc11ffffff9000999af97779ffff99777779ffff000000000000000000000000
eeeeeeeeffff111111dfffffffffff2288ffffffffff22dddd29fffffff00000000fffffff9900096c67779ffffff9999999ffff000000000000000000000000
eeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666acdc6666ff11fffffffffffff000000000000000000000000
fffffffffffffffffffffffffffffffffffffffffff7777777777fff0000000000000000ff9977796c60001ffffff1111111ffff000000000000000000000000
ffffffffffffffffffffffff5555555ffffffffffff7ffffffff7fff0000000000000000ff9777999af10001ffff10000001ffff000000000000000000000000
ffffffff66ffffff566666ff5fffff5fffffffffffffffffff77777f0000000000000000fff99199991f11101ff1000001111fff000000000000000000000000
5555ffff566fffff566666ff5ff5ff5fff5555fffff7fffffff777ff0000000000000000ffffff1111fffff1111111111ffff1ff000000000000000000000000
55ffff5ff566ffff566666ff5f555f5ff5a9985fff777fffffff7fff0000000000000000fffffffffff1ffffffffffffffffffff000000000000000000000000
5f4ff555ff5669ff566666ff5ff5ff5f5affff85f77777ffffffffff0000000000000000ffffffffffffff1fffffffffffffffff000000000000000000000000
5ff4ff5ffff59ffff5666fff5fffff5f53fff525fff7ffffffff7fff0000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000
ffff4ffffff9f9ffff55ffff5555555f53f55f25fff7777777777fff0000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffaffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffafffffff99999999ffffffffffffffffffffffffffffffffffffffffffbf
fffffffffff666777777ffffffffffffffffffffffffffffaffffffffffffffffffffffff99999999999999fffffffff8fffffbfffff77ffffffffffffffffff
ffffff9ffff6666666677ff9fffffffffffffffffffffff999fffffffffffffffffffff999aaaaaaaaaaa9999ffffffffffffffffff67777fffff333ffffffff
ffffffffffff556666666ffffffffffffffffffffffffffdddfffffffffffffffaffff77777777777777777777ffffaffffff333fff66f66ffff13aaf33fffff
f9fffffffffffffffffffffffff9ffffffffffffffffffdddddffffffffffffffffff5677777777777777777765ffffffff333331ffffffffff1333a333a3fff
fffff555666666666777777667fffffffffffffffffffdddddddffffffffffffffff555677799999999997777655ffffff3331331ffff555555133333333afff
ffff56566666666666667777767ffffffffffffffffffdddddddfffffffffffffff55556777799999999777765555ffffff33311fff555111151113311333fff
ffff55666666666666666666666ffffffffffbffffffdddddddddffffffffffffff11111677779999997777611111fffff333314455151117715111113333fff
fff11111111cccccccccccccccc6fffffffffffffff6666666666ffffff8ffffff5555667777779999777777665555ffff1331145111511111151111333affff
fff9569966aa66aa66a766a766a7ffffffffffffff111111111111ffffffffffff5666777777777997777777776655fffff111f45111511111151111333affff
ff595699666a66aa66aa66aa66aa5ffffff8ffffff1111111111111fffffffffff6777777777111111111777777766fffffffff5111151111115111153a3ffff
ff555666666666666666666666665ffffffffffff11111111111111ffffffbfff777777771111111111111117777776ffffffff51115f511115f5111555fffff
ff595699669a66a766a766a766aa5fffffffffff111a111aa111a111fffffffff777111111111111111111111111177fffffff51555fff5555fff55551555fff
fff95699669966aa66aa66aa66aaffffffffffff11111111111111111ffffffff777ffff11111ffffff11111fffff77fffffff511115f500005f5111115444ff
fff11111111cccccccccccccccc5fffffffffff111111111111111111ffffffff777fffffffffffffffffffffffff77fffffff5111115000000511111444444f
ffff55566666666666666666655fffffffffff11111111111111111111fffffff777ffffffffafffffffaffffffff77fffbfff5111115000000511111155454f
ff9f55655666666666666666565fffffffffff111111166666661111111ffffff777fffffafffffffffffffafffff77fffffff551111500000051111714444ff
fffff555555555555555555555fffffffffff1111111611111116111111ffffff777ffafffffffffffffffffffaff77fffffff511111500000051117115444ff
fffffffffffffffffffffffffff9ffffffff611111161110001116111116fffff777afffffffffffffffffffffffa77fffffff511115f500005f51111544ffff
ffffff9fffff666666666ff9fffffffffffd611111611000000011611116ffffff6777777fffffffffffffff777776fffffffff5555fff5555fff5551fffffff
fffffffffff6666666676ffffffffffffffdd6111116100000001611116ddfffff5667777777fffffffff777777665fffffffffffff5f511115f5115ff67ffff
ffffffffff666a6611676fffffffffffffddd6111116100000001611116dddffff5556677777777777777777766555ffffffffffffff511117151115ff67ffff
ffffffffff66666611ff6ffffffffffffdddd6111116100000001611116dddfffff55556677777777777777665555ffffffffff68fff51111115155f6676ffff
ffffffffff5666661fff6ffffffffffff9dddd61111611100011161116dddd9ffff11111167777777777776111111fffffffff6666ff511111155fff6777ffff
ffffffffff5666661fff6fffffffffffa9dddd61111611111111161116dddd9affff555567777777777777765555ffffffffff6666fff555555fff666777ffff
ffffffffff566a6611ff6ffffffffffffffffffffffffffffffffffffffffffffffff5567777777777777777665ffffffffffffb6fffffffffffff677677ffff
ffffffffff56666611676ffffffffffffffffffffffffffffffffffffffffffffaffff67777777777777777777ffffffffffffffffffffffffffff777fffffff
ffffffffff55666666676ffffffffffffffffffffffffffffffffffffffffffffffffff999aaaaaaaaaaaa999ffffaffffffffffffffffffffffffffffffffff
ffffffffff55566666665ffffffffffffffffffffffffffffffffffffffffffffffffffff99999999999999ffffffffffff8ffffffffffffffffffffffff8fff
fffffffffff555555555fffffffffffffffffffffffffffbfff8fffffffffffffffaffffffff99999999fffffffaffffffffffffffffffffffffbfffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff844fffff6666ffffff4444fffffffffffff1111ccfffffffffffffffffffffffffffffffffffff00000000ffffffffffffffffffffffffffffffffffffffff
f408fffff665656ffff404ff4ffffffffff6511111c56fffffffffffffffffffffffffffffffffff00000000ffffffffffffffffffff888fffffffffffffffff
40004fff56522756ff404fffffffffffff665111111566ffffffffffffffffffffffffffffffffff00000000fffff88fffff888ffff89998ffff888ffffff88f
000004ff56628266ff4004fffffffffff66655111155666fffffffffff444444444444ffffffffff00000000ffff897ffff8999ff8899999fff8999fffff897f
40004fff56522256f40880444ff484fff66655222255666ffffff4444400000088888884ffffffff00000000fff8977fff89777f89977777ff89777ffff8977f
f408ffff55656566400000000440084f5666522227256666ffff4000000000000000000044ffffff00000000ffff897ffff8999ff8899999fff8999fffff897f
ff844ffff556666f40000000000000045616222882726166fff444444400000444444444444fffff00000000fffff88fffff888ffff89998ffff888ffffff88f
ffffffffff5555ff40000000000000045666228888226666fffffffff4000004ffffffffffffffff00000000ffffffffffffffffffff888fffffffffffffffff
ffffffffffffffff40000000000000045616228888226166fffffff44400004fffffffffffffffff00000000ffffffffffffffffffffffffffffffffffffffff
fff7fffffff8ffff400000000440084f5566222882226666ffff4440000000044444ffffffffffff00000000ffffffffffffffffffff111fffffffffffffffff
ff777fffff888ffff40880444ff484ff5566622222266666ffff400000000000000044ffffffffff00000000fffff11fffff111ffff1ddd1ffff111ffffff11f
f7fff7fff8fff8ffff4004fffffffffff55666222266666ff4480000000000000000044444444fff00000000ffff1d7ffff1dddff11dddddfff1dddfffff1d7f
77f7f77f88f8f88fff404ffffffffffff55166666666166fff4080000000000008888888000004ff00000000fff1d77fff1d777f1dd77777ff1d777ffff1d77f
f7fff7fff8fff8fffff404ff4fffffffff555666666666fffff4400000444440800000000000044f00000000ffff1d7ffff1dddff11dddddfff1dddfffff1d7f
ff777fffff888fffffff4444fffffffffff5556666666ffffffff40004444444444444444444444400000000fffff11fffff111ffff1ddd1ffff111ffffff11f
fff7fffffff8fffffffffffffffffffffffff555555ffffffffff4000444ffffffffffffffffffff00000000ffffffffffffffffffff111fffffffffffffffff
000000000000000000000000000000000000000000000000fffff40004444444444444444444444400000000ffffffffffffffffffffffffffffffffffffffff
000000000000000000000000000000000000000000000000fff4400000444440800000000000004f00000000ffffffffffffffffffff555fffffffffffffffff
000000000000000000000000000000000000000000000000ff4080000000000008888888000044ff00000000fffff55fffff555ffff5eee5ffff555ffffff55f
000000000000000000000000000000000000000000000000f4484000000000000000004444444fff00000000ffff5e7ffff5eeeff55eeeeefff5eeefffff5e7f
000000000000000000000000000000000000000000000000ffff400000000000000044ffffffffff00000000fff5e77fff5e777f5ee77777ff5e777ffff5e77f
000000000000000000000000000000000000000000000000ffff4444000000044444ffffffffffff00000000ffff5e7ffff5eeeff55eeeeefff5eeefffff5e7f
000000000000000000000000000000000000000000000000fffffff44400004fffffffffffffffff00000000fffff55fffff555ffff5eee5ffff555ffffff55f
000000000000000000000000000000000000000000000000fffffffff4000004ffffffffffffffff00000000ffffffffffffffffffff555fffffffffffffffff
000000000000000000000000000000000000000000000000fff444444400000044444444444fffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffff4000000000000000000044ffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000fffff4444400000088888884ffffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffffffffff444444444444ffffffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041424300444546470048494a4b004c4d4e4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525300545556570058595a5b005c5d5e5f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6061626300646566670068696a6b006c6d6e6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727300747576770078797a7b007c7d7e7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000f7100f71002730037200f7100f7100470004700047001170011700117000b7000470010050007000a7000c7000c70000700007000c7000d700007000070000700007000070000700007000070000700
00010000000002a55027550225501f5501d5501a550195501755014550115500f5500d5500a5500a5500315008550075500655005550035500155000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
