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

void() spike_touch =
{
	if (other == self.owner)
		return;

	// trigger field, do nothing
	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood(9);
		other.deathtype = "nail";
		T_Damage(other, self, self.owner, 9);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte(MSG_BROADCAST, TE_SPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	// trigger field, do nothing
	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood(18);
		other.deathtype = "supernail";
		T_Damage(other, self, self.owner, 18);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};

/*============================================================================

launch_spike

Used for both the player and the ogre
============================================================================*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);

	newmis.velocity = dir * 1000;
};

/*============================================================================

W_FireSuperSpikes

============================================================================*/
void() W_FireSuperSpikes =
{
	vector dir;

	sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

/*============================================================================

W_FireSpikes

============================================================================*/
void(float ox) W_FireSpikes =
{
	vector dir;

	makevectors(self.v_angle);

	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}

	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16' + v_right * ox, dir);

	self.punchangle_x = -2;
};