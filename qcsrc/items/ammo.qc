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

void() bound_other_ammo =
{
	if (other.ammo_shells > 100)
		other.ammo_shells = 100;
	if (other.ammo_nails > 200)
		other.ammo_nails = 200;
	if (other.ammo_rockets > 100)
		other.ammo_rockets = 100;
	if (other.ammo_cells > 100)
		other.ammo_cells = 100;
};

float(float w) RankForWeapon =
{
	if (self.waterlevel <= 1 && w == IT_LIGHTNING)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	return 7;
};

/*============================================================================
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
============================================================================*/
void(float old, float new) Deathmatch_Weapon =
{
	float or, nr;

	// change self.weapon if desired
	or = RankForWeapon(self.weapon);
	nr = RankForWeapon(new);
	if (nr < or)
		self.weapon = new;
};

float() W_BestWeapon;

/*============================================================================

weapon_touch

============================================================================*/
void() weapon_touch =
{
	float hadammo, best, new, old;
	entity stemp;
	float leave;

	if (!(other.flags & FL_CLIENT))
		return;

	// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (deathmatch == 2 || coop)
		leave = 1;
	else
		leave = 0;

	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN))
			return;
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN))
			return;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN))
			return;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER))
			return;
		hadammo = other.ammo_rockets;
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER))
			return;
		hadammo = other.ammo_rockets;
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING))
			return;
		hadammo = other.ammo_rockets;
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + 15;
	}
	else
		objerror("weapon_touch: unknown classname");

	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	// weapon touch sound
	sound(other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

	bound_other_ammo();

	// change to the weapon
	old = other.items;
	other.items = other.items | new;

	stemp = self;
	self = other;

	if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon(old, new);

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;
	self.think = SUB_regen;

	activator = other;

	// fire all targets/killtargets
	SUB_UseTargets();
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supershotgun =
{
	precache_model("progs/g_shot.mdl");
	setmodel(self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_nailgun =
{
	precache_model("progs/g_nail.mdl");
	setmodel(self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supernailgun =
{
	precache_model("progs/g_nail2.mdl");
	setmodel(self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Perforator";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_grenadelauncher =
{
	precache_model("progs/g_rock.mdl");
	setmodel(self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_rocketlauncher =
{
	precache_model("progs/g_rock2.mdl");
	setmodel(self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_lightning =
{
	precache_model("progs/g_light.mdl");
	setmodel(self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};


//=============================================================================


void() ammo_touch =
{
	entity stemp;
	float best;

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

	// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

	//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

	//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	bound_other_ammo();

	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");

	// ammo touch sound
	sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

	// change to a better weapon if appropriate
	if (other.weapon == best)
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		self = stemp;
	}

	// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;

	self.think = SUB_regen;

	activator = other;

	// fire all targets/killtargets
	SUB_UseTargets();
};

float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_shells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_shell1.bsp");
		setmodel(self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model("maps/b_shell0.bsp");
		setmodel(self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_spikes =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_nail1.bsp");
		setmodel(self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model("maps/b_nail0.bsp");
		setmodel(self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_rockets =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_rock1.bsp");
		setmodel(self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model("maps/b_rock0.bsp");
		setmodel(self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_cells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_batt1.bsp");
		setmodel(self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model("maps/b_batt0.bsp");
		setmodel(self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;

/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/
void() item_weapon =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_shell1.bsp");
			setmodel(self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model("maps/b_shell0.bsp");
			setmodel(self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_nail1.bsp");
			setmodel(self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model("maps/b_nail0.bsp");
			setmodel(self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "nails";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}

	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};
