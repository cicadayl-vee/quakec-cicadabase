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

/*============================================================================

T_Heal

Add health to an entity, limiting health to max_health
"ignore" will ignore max_health limit

=========================================================================
*/
float(entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;

	if (e.health > 250)
		e.health = 250;
	return 1;
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
};

float H_ROTTEN = 1;
float H_MEGA = 2;
.float healamount, healtype;
void() health_touch;

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5 - 10 points,
Megahealth will add 100 health, then
rot you down to your maximum health limit,
one point per second.
*/
void() item_health =
{
	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");

		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() health_touch =
{
	string s;

	if (other.classname != "player")
		return;

	// Megahealth? Ignore max_health...
	if (self.healtype == 2)
	{
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			return;
	}

	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");

	// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd(other, "bf\n");

	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
		other.items = other.items | IT_SUPERHEALTH;
		other.healthrot_nextcheck = time + 5;
	}
	
	// deathmatch 2 is silly old rules
	if ( deathmatch && deathmatch != 2 ) 
	{	
		if ( self.healtype == 2 ) 
		{
			self.nextthink = time + 120;
		} 
		else 
		{
			self.nextthink = time + 20;
		}
	}

	self.think = SUB_regen;
	
	activator = other;
	// fire all targets/killtargets
	SUB_UseTargets();
};
