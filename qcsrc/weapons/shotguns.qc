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

MULTI-DAMAGE

Collects multiple small damages into a single damage

============================================================================*/

entity multi_ent;
float multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage(multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*============================================================================

TraceAttack

============================================================================*/
void(float damage, vector dir) TraceAttack =
{
	vector vel, org;

	vel = normalize(dir + v_up * crandom() + v_right * crandom());
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir * 4;

	if (trace_ent.takedamage)
	{
		SpawnBlood(org, vel * 0.2, damage);
		AddMultiDamage(trace_ent, damage);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

/*============================================================================

FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.

============================================================================*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	vector direction;
	vector src;

	makevectors(self.v_angle);

	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage();
	while (shotcount > 0)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;

		traceline(src, src + direction * 2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack(4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage();
};

/*============================================================================

W_FireShotgun

============================================================================*/
void() W_FireShotgun =
{
	vector dir;

	sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim(self, 100000);
	FireBullets(6, dir, '0.04 0.04 0');
};

/*============================================================================

W_FireSuperShotgun

============================================================================*/
void() W_FireSuperShotgun =
{
	vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun();
		return;
	}

	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

	self.punchangle_x = -4;

	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim(self, 100000);
	FireBullets(14, dir, '0.14 0.08 0');
};
