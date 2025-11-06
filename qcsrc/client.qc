/*  Copyright (C) 1996-2022 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

// prototypes
void() W_WeaponFrame;
void() W_SetCurrentAmmo;
void(entity attacker, float damage) player_pain;
void() player_stand1;
void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath;

float modelindex_eyes, modelindex_player;

/*============================================================================

LEVEL CHANGING/INTERMISSION

============================================================================*/

float intermission_running;
float intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};

void() SetChangeParms =
{
	if (self.health <= 0 || deathmatch)
	{
		SetNewParms();
		return;
	}
	
	// remove items
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));

	// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
};

void() SetNewParms =
{
	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
};

void() DecodeLevelParms =
{
	if (serverflags)
	{
		// take away all stuff on starting new episode
		if (world.model == "maps/start.bsp")
			SetNewParms();
	}

	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
};

/*============================================================================

FindIntermission

Returns the entity to view from

============================================================================*/
entity() FindIntermission =
{
	entity spot;
	float cyc;

	// look for info_intermission first
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
				spot = find(spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

	// then look for the start position
	spot = find(world, classname, "info_player_start");
	if (spot)
		return spot;

	// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;

	objerror("FindIntermission: no spot");
	return world;
};

string nextmap;
void() GotoNextMap =
{
	// if samelevel is set, stay on same level
	if (cvar("samelevel"))
		changelevel(mapname);
	else
		changelevel(nextmap);
};

void() ExitIntermission =
{
	// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap();
		return;
	}

	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

	//
	// run some text if at the end of an episode
	//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		}

		GotoNextMap();
	}

	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{
			// shareware episode has been completed, go to sell screen
			WriteByte(MSG_ALL, SVC_SELLSCREEN);
			return;
		}

		if ((serverflags & 15) == 15)
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}

	}

	GotoNextMap();
};

/*============================================================================

IntermissionThink

When the player presses attack or jump, change to the next level

============================================================================*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;

	ExitIntermission();
};

void() execute_changelevel =
{
	entity pos;

	intermission_running = 1;

	// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 3);
	WriteByte(MSG_ALL, 3);

	pos = FindIntermission();

	other = find(world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		// turn this way immediately
		other.fixangle = TRUE;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin(other, pos.origin);
		other = find(other, classname, "player");
	}

	WriteByte(MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch =
{
	if (other.classname != "player")
		return;
	
	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	
	if (coop || deathmatch)
	{
		bprint(other.netname);
		bprint(" exited the level\n");
	}

	nextmap = self.map;

	SUB_UseTargets();

	if ((self.spawnflags & 1) && (deathmatch == 0))
	{
		// NO_INTERMISSION
		GotoNextMap();
		return;
	}

	self.touch = SUB_Null;

	// we can't move people right now, because touch functions are called
	// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror("chagnelevel trigger doesn't have map");

	InitTrigger();
	self.touch = changelevel_touch;
};

/*============================================================================

PLAYER GAME EDGE FUNCTIONS

============================================================================*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue(self);
		// get the spawn parms as they were at level start
		setspawnparms(self);
		// respawn
		PutClientInServer();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue(self);
		// set default spawn parms
		SetNewParms();
		// respawn
		PutClientInServer();
	}
	else
	{
		// restart the entire server
		localcmd("restart\n");
	}
};

/*============================================================================

ClientKill

Player entered the suicide command

============================================================================*/
void() ClientKill =
{
	if (self.suicide_time > time)
	{
		sprint(self, "You can't commit suicide yet.\n");
		return;
	}
	
	if (self.killbind_count >= 3)
	{
		sprint(self, "You have suicided too much already.\n");
		return;
	}
	
	self.deathtype = "suicide";
	self.suicide_time = time + 10;
	self.killbind_count = self.killbind_count + 1;
	self.health = 0;
	Killed (self, self);
};

/*============================================================================

PlayerVisibleToSpawnPoint

Returns true if player can see this point

============================================================================*/
float PlayerVisibleToSpawnPoint(entity point) 
{
	local vector spot1, spot2;
	local entity player = find(world, classname, "player");
	while (player) 
	{
		if (player.health > 0) 
		{
			spot1 = point.origin + player.view_ofs;
			spot2 = player.origin + player.view_ofs;

			traceline(spot1, spot2, TRUE, point);
			if (trace_fraction >= 1.0f) 
			{
				return TRUE;
			}
		}

		player = find(player, classname, "player");
	}

	return FALSE;
}

/*============================================================================

SelectSpawnPoint

Returns the entity to spawn at

============================================================================*/
float IDEAL_DIST_FROM_DM_SPAWN_POINT = 384;
float MIN_DIST_FROM_DM_SPAWN_POINT = 84;

entity() SelectSpawnPoint =
{
	entity spot, thing;
	float numspots, totalspots;
	float pcount;
	entity spots;
	
	numspots = 0;
	totalspots = 0;

	// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;

	// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find(lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		// find all spots that don't have visible players nearby
		spots = world;
		spot = find (world, classname, "info_player_deathmatch");
		while (spot)
		{
			totalspots = totalspots + 1;

			thing = findradius(spot.origin, IDEAL_DIST_FROM_DM_SPAWN_POINT);
			pcount = 0;
			               
			while (thing)
			{
				if (thing.classname == "player" && thing.health > 0)
					pcount= pcount + 1;
				thing = thing.chain;      
			}
			if (pcount == 0) 
			{
				if (PlayerVisibleToSpawnPoint(spot)) 
				{
					pcount = pcount + 1;
				}
			}
			// good spot!
			if (pcount == 0) 
			{
				spot.goalentity = spots;
				spots = spot;
				numspots = numspots + 1;
			}

			// Get the next spot in the chain
			spot = find (spot, classname, "info_player_deathmatch");                
		}
		
		totalspots = totalspots - 1;
		
		// on small maps with few spawn points, our "ideal" spawn conditions may not be possible to meet
		// so fallback to just trying to pick a point without a player on top of it, so we don't start
		// a spawn frag loop
		if ( numspots == 0 ) 
		{
			spot = find(world, classname, "info_player_deathmatch");

			while(spot) 
			{
				thing = findradius(spot.origin, MIN_DIST_FROM_DM_SPAWN_POINT);
				pcount = 0;               

				while(thing) 
				{
					if (thing.classname == "player" && thing.health > 0) 
					{
						pcount = pcount + 1;                      
					}

					thing = thing.chain;      
				}
				// good spot!
				if (pcount == 0) 
				{
					spot.goalentity = spots;
					spots = spot;
					numspots = numspots + 1;
				}

				// Get the next spot in the chain
				spot = find(spot, classname, "info_player_deathmatch");                
			}             
		}
		
		if (!numspots) 
		{
			// no spots available so just pick one at random
			totalspots = rint((random() * totalspots));
			spot = find (world, classname, "info_player_deathmatch");       
			while (totalspots > 0) 
			{
				totalspots = totalspots - 1;
				spot = find (spot, classname, "info_player_deathmatch");
			}
			return spot;
		}
		
		// Generate a random number between 1 and numspots
		numspots = numspots - 1;
	
		numspots = rint((random() * numspots ));

		spot = spots;
		while (numspots > 0) 
		{
			spot = spot.goalentity;
			numspots = numspots - 1;
		}
		return spot;
	}

	if (serverflags)
	{
		// return with a rune to start
		spot = find(world, classname, "info_player_start2");
		if (spot)
			return spot;
	}

	spot = find(world, classname, "info_player_start");
	if (!spot)
		error("PutClientInServer: no info_player_start on level");

	return spot;
};

void() DecodeLevelParms;
void() PlayerDie;

/*============================================================================

PutClientInServer

Called each time a player is spawned

============================================================================*/
void() PutClientInServer =
{
	entity spot;
	
	spot = SelectSpawnPoint();

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	// initial water damage
	self.dmg = 2;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.healthrot_nextcheck = 0;

	DecodeLevelParms();

	W_SetCurrentAmmo();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;

	self.deadflag = DEAD_NO;
	// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	self.velocity = '0 0 0';

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	// turn this way immediately
	self.fixangle = TRUE;

	// oh, this is a hack!
	setmodel(self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel(self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.view_ofs = '0 0 22';

	player_stand1();

	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog(self.origin + v_forward * 20);
	}

	spawn_tdeath(self.origin, self);
};

/*============================================================================

QUAKED FUNCTIONS

============================================================================*/

/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};

/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};

/*
saved out by QuakeEd in region mode
*/
void() testplayerstart =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*============================================================================

RULES

============================================================================*/

/*
go to the next level for deathmatch
*/
void() NextLevel =
{
	entity o;

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}

		o = spawn();
		o.map = mapname;
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");

		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*============================================================================

CheckRules

Exit deathmatch games upon conditions

============================================================================*/
void() CheckRules =
{
	float timelimit;
	float fraglimit;

	// someone else quit the game already
	if (gameover)
		return;

	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");

	if (timelimit && time >= timelimit)
	{
		NextLevel();
		return;
	}

	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel();
		return;
	}
};

void() PlayerDeathThink =
{
	float forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward * normalize(self.velocity);
	}

	// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};

void() PlayerJump =
{
	if (self.flags & FL_WATERJUMP)
		return;

	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

		// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound(self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound(self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	// don't pogo stick
	if (!(self.flags & FL_JUMPRELEASED))
		return;

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	// don't stairwalk
	self.flags = self.flags - FL_ONGROUND;

	self.button2 = 0;
	// player jumping sound
	sound(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};

.float dmgtime;

/*============================================================================

WaterMove

============================================================================*/
void() WaterMove =
{
	//dprint(ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound(self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound(self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{
		// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage(self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}

	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{
			// play leave water sound
			sound(self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage(self, world, world, 10 * self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{
		// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage(self, world, world, 4 * self.waterlevel);
		}
	}

	if (!(self.flags & FL_INWATER))
	{
		// player enter water sound
		if (self.watertype == CONTENT_LAVA)
			sound(self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound(self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound(self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}

	if (!(self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8 * self.waterlevel * frametime * self.velocity;
};

void() CheckWaterJump =
{
	vector start, end;

	// check for a jump-out-of-water
	makevectors(self.angles);
	start = self.origin;
	start_z = start_z + 8;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, TRUE, self);
	if (trace_fraction < 1)
	{
		// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline(start, end, TRUE, self);
		if (trace_fraction == 1)
		{
			// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			// safety net
			self.teleport_time = time + 2;
			return;
		}
	}
};

/*============================================================================

PlayerPreThink

Called every frame before physics are run

============================================================================*/
void() PlayerPreThink =
{
	if (intermission_running)
	{
		// otherwise a button could be missed between the think tics
		IntermissionThink();
		return;
	}

	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;

	// is this still used?
	makevectors(self.v_angle);
	
	self.deathtype = "";

	CheckRules();
	WaterMove();

	if (self.waterlevel == 2)
		CheckWaterJump();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}

	// dying, so do nothing
	if (self.deadflag == DEAD_DYING)
		return;

	if (self.button2)
		PlayerJump();
	else
		self.flags = self.flags | FL_JUMPRELEASED;

	// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';
		
	if (time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};

/*============================================================================

CheckPowerups

Check for turning off powerups

============================================================================*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

	// invisibility
	if (self.invisible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound(self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}

		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint(self, "Ring of Shadows magic is fading\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}

			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{
			// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}

		// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
	{
		// don't use eyes
		self.modelindex = modelindex_player;
	}

	// invincibility
	if (self.invincible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint(self, "Protection is almost burned out\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{
			// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

	// super damage
	if (self.super_damage_finished)
	{

		// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint(self, "Quad Damage is wearing off\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{
			// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

	// suit
	if (self.radsuit_finished)
	{
		// don't drown
		self.air_finished = time + 12;

		// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint(self, "Air supply in Biosuit expiring\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{
			// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
};

/*============================================================================

CheckHealthRot

Checks for taking off health points from a player that recently used a Mega-Health.

============================================================================*/
void CheckHealthRot() 
{
	if (!(self.items & IT_SUPERHEALTH)) 
		return;

	if (self.healthrot_nextcheck > time)
		return;

	if (self.health > self.max_health) 
	{
		self.health = self.health - 1;
		self.healthrot_nextcheck = time + 1;
		return;
	}

	self.items = self.items - (self.items & IT_SUPERHEALTH);
	self.healthrot_nextcheck = 0;
}

/*============================================================================

PlayerPostThink

Called every frame after physics are run

============================================================================*/
void() PlayerPostThink =
{
	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;
	if (self.deadflag)
		return;

	// do weapon stuff
	W_WeaponFrame();

	// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound(self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			self.deathtype = "falling";
			T_Damage(self, world, world, 5);
			
			if (self.health > 0)
				sound(self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
		}
		else
			sound(self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups();
	CheckHealthRot();
};

/*============================================================================

ClientConnect

called when a player connects to a server

============================================================================*/
void() ClientConnect =
{
	bprint(self.netname);
	bprint(" entered the game\n");
	
	self.killbind_count = 0;

	// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission();
};

/*============================================================================

ClientDisconnect

Called when a player disconnects from a server

============================================================================*/
void() ClientDisconnect =
{
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving
	if (gameover)
		return;

	// let everyone else know
	bprint(self.netname);
	bprint(" left the game with ");
	bprint(ftos(self.frags));
	bprint(" frags\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame();
};
