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

void() s_explode1 = [ 0, s_explode2 ] {};
void() s_explode2 = [ 1, s_explode3 ] {};
void() s_explode3 = [ 2, s_explode4 ] {};
void() s_explode4 = [ 3, s_explode5 ] {};
void() s_explode5 = [ 4, s_explode6 ] {};
void() s_explode6 = [ 5, SUB_Remove ] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};


//=============================================================================


void() T_MissileTouch =
{
	float damg;

	// don't explode on owner
	if (other == self.owner)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random() * 20;

	if (other.health)
	{
		other.deathtype = "rocket";
		
		// mostly immune
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;

		T_Damage(other, self, self.owner, damg);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage(self, self.owner, 120, other, "rocket");

	//sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8 * normalize(self.velocity);

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);

	BecomeExplosion();
};

/*============================================================================

W_FireRocket

============================================================================*/
void() W_FireRocket =
{
	entity missile;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

	// set missile speed
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

	// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel(missile, "progs/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 16');
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage(self, self.owner, 120, world, "grenade");

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);

	BecomeExplosion();
};

void() GrenadeTouch =
{
	// don't explode on owner
	if (other == self.owner)
		return;

	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}

	// bounce sound
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);

	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*============================================================================

W_FireGrenade

============================================================================*/
void() W_FireGrenade =
{
	entity missile;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

	// set missile speed
	makevectors(self.v_angle);

	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

	// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin);
};