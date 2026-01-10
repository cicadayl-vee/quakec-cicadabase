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

float() crandom =
{
	return 2 * (random() - 0.5);
};

vector() wall_velocity =
{
	vector vel;

	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;

	return vel;
};

/*============================================================================

SpawnMeatSpray

============================================================================*/
void(vector org, vector vel) SpawnMeatSpray =
{
	entity missile;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors(self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50 * random();

	missile.avelocity = '3000 1000 2000';

	// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, org);
};

/*============================================================================

SpawnBlood

============================================================================*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle(org, vel * 0.1, 73, damage * 2);
};

/*============================================================================

spawn_touchblood

============================================================================*/
void(float damage) spawn_touchblood =
{
	vector vel;

	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.01, vel, damage);
};

//=============================================================================


vector(float dm) VelocityForDamage =
{
	vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();

	if (dm > -50)
	{
		//dprint("level 1\n");
		v = v * 0.7;
	}
	else if (dm > -200)
	{
		//dprint("level 3\n");
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
};

/*============================================================================

ThrowGib

============================================================================*/
void(string gibname, float dm) ThrowGib =
{
	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random() * 10;
	new.frame = 0;
	new.flags = 0;
};

/*============================================================================

ThrowHead

============================================================================*/
void(string gibname, float dm) ThrowHead =
{
	setmodel(self, gibname);
	self.frame = 0;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize(self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage(dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
};
