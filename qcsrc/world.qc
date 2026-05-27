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

void() main =
{
	dprint("main function\n");
};

/*============================================================================

worldspawn

============================================================================*/

entity lastspawn;

void() worldspawn =
{
	lastspawn = world;
	InitBodyQue();

	// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set("sv_gravity", "100");
	else
		cvar_set("sv_gravity", "800");


	//=============================================================================
	
	// the area based ambient sounds MUST be the first precache_sounds

	// sounds used from C physics code
	sound_ccode_physics_precache();

	// setup precaches always needed
	
	// misc
	sound_misc_precache();
	model_misc_precache();
	
	// items
	sound_item_precache();
	
	// weapons
	sound_weapons_precache();
	model_weapons_precache();
	
	// player
	sound_player_precache();
	model_player_precache();
	
	// sprites
	model_sprites_precache();
	
	// etc.
	InitLightStyles();
}

void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;
};

/*============================================================================

BODY QUE

============================================================================*/

entity bodyque_head;

void() bodyque =
{
	// just here so spawn functions don't complain after the world creates bodyques
};

void() InitBodyQue =
{
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};

// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin(bodyque_head, ent.origin);
	setsize(bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};