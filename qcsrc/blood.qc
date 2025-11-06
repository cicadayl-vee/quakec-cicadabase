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

/*============================================================================

SpawnChunk

============================================================================*/
void(vector org, vector vel) SpawnChunk =
{
	particle(org, vel * 0.02, 0, 10);
};
