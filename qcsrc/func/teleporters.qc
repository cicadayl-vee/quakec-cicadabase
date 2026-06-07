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

TELEPORT TRIGGERS

============================================================================*/

entity s;

float SPAWNFLAG_TELE_PLAYER_ONLY = 1;
float SPAWNFLAG_TELE_NO_AMBIENCE = 2;

void() play_teleport =
{
	float v;
	string tmpstr;

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

	sound(self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove(self);
};

void(vector org) spawn_tfog =
{
	s = spawn();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
};

void() tdeath_touch =
{
	entity other2;
	
	if (other == self.owner)
		return;

	// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time && self.owner.invincible_finished > time) 
		{
			self.classname = "teledeath3";
			other.invincible_finished = 0;
			self.owner.invincible_finished = 0;
			T_Damage (other, self, self, 50000);
			other2 = self.owner;
			self.owner = other;
			T_Damage (other2, self, self, 50000);
			return;
		}
		
		if (other.invincible_finished > time)
		{
			self.classname = "teledeath2";
			T_Damage (self.owner, self, self, 50000);
			return;
		}
		
		if (self.owner.classname != "player")
		{
			// other monsters explode themselves
			T_Damage(self.owner, self, self, 50000);
			return;
		}
	}

	if (other.health)
		T_Damage(other, self, self, 50000);
};

void(vector org, entity death_owner) spawn_tdeath =
{
	entity death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize(death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin(death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;

	// make sure even still objects get hit
	force_retouch = 2;
};

void() teleport_touch =
{
	entity t;
	vector org;

	if (self.targetname)
	{
		// not fired yet
		if (self.nextthink < time)
			return;
	}

	if (self.spawnflags & SPAWNFLAG_TELE_PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

	// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets();

	// put a tfog where the player was
	spawn_tfog(other.origin);

	t = find(world, targetname, self.target);
	if (!t)
		objerror("couldn't find target");

	// spawn a tfog flash in front of the destination
	makevectors(t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog(org);
	spawn_tdeath(t.origin, other);

	// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin(other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		// turn this way immediately
		other.fixangle = 1;
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*============================================================================

info_teleport_destination

This is the destination marker for a teleporter. 
It should have a "targetname" field with the same value as a teleporter's "target" field.

============================================================================*/

void() info_teleport_destination =
{
	// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	// make sure even still objects get hit
	force_retouch = 2;
	self.think = SUB_Null;
};

/*============================================================================

trigger_teleport

Any object touching this will be transported to the corresponding info_teleport_destination entity. 
You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.

============================================================================*/

void() trigger_teleport =
{
	vector o;

	InitTrigger();
	self.touch = teleport_touch;
	// find the destination
	if (!self.target)
		objerror("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SPAWNFLAG_TELE_NO_AMBIENCE))
	{
		precache_sound("ambience/hum1.wav");
		o = (self.mins + self.maxs) * 0.5;
		ambientsound(o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
	}
};