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

ServerflagsCommand

Just for development

============================================================================*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};

/*============================================================================

W_ChangeWeapon

============================================================================*/
void() W_ChangeWeapon =
{
	float it, am, fl;

	it = self.items;
	am = 0;

	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;

	if (!(self.items & fl))
	{
		// don't have the weapon or the ammo
		sprint(self, "no weapon.\n");
		return;
	}

	if (am)
	{
		// don't have the ammo
		sprint(self, "not enough ammo.\n");
		return;
	}

	//
	// set weapon, set ammo
	//
	self.weapon = fl;
	W_SetCurrentAmmo();
};

/*============================================================================

CycleWeaponCommand

Go to the next weapon with ammo

============================================================================*/
void() CycleWeaponCommand =
{
	float it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

		if ((self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo();
			return;
		}
	}
};

/*============================================================================

CycleWeaponReverseCommand

Go to the prev weapon with ammo

============================================================================*/
void() CycleWeaponReverseCommand =
{
	float it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

		if ((self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo();
			return;
		}
	}

};

/*============================================================================

WeaponsCheat

============================================================================*/
void() WeaponsCheat =
{
	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 100;
	self.items = self.items | IT_LIGHTNING;
	
	self.armortype = 0.8;
	self.armorvalue = 200;
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;

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

/*============================================================================

ImpulseCommands

============================================================================*/
void() ImpulseCommands =
{
	// weapon switching
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon();
	if (self.impulse == 10)
		CycleWeaponCommand();
	if (self.impulse == 12)
		CycleWeaponReverseCommand();
	
	// cheats
	if (self.impulse == 9)
		WeaponsCheat();
	if (self.impulse == 255)
		QuadCheat();
	if (self.impulse == 205)
		OmnicideCheat();
	
	// dev
	if (self.impulse == 11)
		ServerflagsCommand();

	self.impulse = 0;
};