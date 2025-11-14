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

void(entity attacker, float damage) player_pain;
void() player_stand1;

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
