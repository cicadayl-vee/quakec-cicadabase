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

/*=============================================================================

LightningDamage

=============================================================================*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	entity e1, e2;
	vector f;
	float t;

	f = p2 - p1;
	t = f_x;
	f_x = 0 - f_y;
	f_y = t;
	f_z = 0;
	f = normalize(f);
	f = f * 16;

	e1 = e2 = world;

	traceline(p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage(trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline(p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline(p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning =
{
	vector org;
	float cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo();
		T_RadiusDamage(self, self, 35 * cells, world, "");
		return;
	}

	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';

	traceline(org, org + v_forward * 600, TRUE, self);

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);

	LightningDamage(self.origin, trace_endpos + v_forward * 4, self, 30);
};

