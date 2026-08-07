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

IMPULSES - CHEATS

============================================================================*/

/*============================================================================

WeaponsCheat

============================================================================*/

void() WeaponsCheat =
{
	if (deathmatch || coop)
		return;
	
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_LIGHTNING;
	
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.ammo_cells = 100;
	
	self.armortype = 0.8;
	self.armorvalue = 200;
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
	
	self.items = self.items | IT_KEY1 | IT_KEY2;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo();
};

/*============================================================================

QuadCheat

============================================================================*/

void() QuadCheat =
{
	if (deathmatch || coop)
		return;

	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	sound(self, CHAN_VOICE, "items/damage.wav", 1, ATTN_NORM);
	
	dprint("quad cheat\n");
};

/*============================================================================

OmnicideCheat

============================================================================*/

void() OmnicideCheat =
{
	entity head;

	if (deathmatch || coop)
		return;
	
	head = nextent(world);
	while (head != world)
	{
		if ((head.health > 0) && (head.flags & FL_MONSTER))
			T_Damage(head, world, world, (head.health * 3));
		
		head = nextent(head);
	}
	
	dprint("omnicide cheat\n");
};