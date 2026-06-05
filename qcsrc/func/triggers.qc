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

TRIGGERS

============================================================================*/

void() trigger_reactivate = { self.solid = SOLID_TRIGGER; };

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};

// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	// already been triggered
	if (self.nextthink > time)
		return;

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;

		found_secrets = found_secrets + 1;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	SUB_UseTargets();

	if (self.wait > 0)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{
		// we can't just remove(self) here, because this is a touch function
		// called while C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors(other.angles);

		// not facing the right way
		if (v_forward * self.movedir < 0)
			return;
	}

	self.enemy = other;
	multi_trigger();
};

//============================================================================

float SPAWNFLAG_TRIG_NOTOUCH = 1;

void() trigger_multiple =
{
	if (self.sounds == 1)
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}

	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_TRIG_NOTOUCH)
			objerror("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;

		// make sure it links into the world
		setorigin(self, self.origin);
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_TRIG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
};

void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

void() trigger_relay =
{
	self.use = SUB_UseTargets;
};

void() trigger_secret =
{
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;

	if (self.sounds == 1)
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple();
};

//============================================================================

float SPAWNFLAG_TRIG_NOMESSAGE = 1;

void() counter_use =
{
	self.count = self.count - 1;
	if (self.count < 0)
		return;

	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_TRIG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint(activator, "There are more to go...");
			else if (self.count == 3)
				centerprint(activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint(activator, "Only 2 more to go...");
			else
				centerprint(activator, "Only 1 more to go...");
		}
		return;
	}

	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_TRIG_NOMESSAGE) == 0)
		centerprint(activator, "Sequence completed!");

	self.enemy = activator;
	multi_trigger();
};

void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};

//============================================================================

void() trigger_skill_touch =
{
	if (other.classname != "player")
		return;

	cvar_set("skill", self.message);
};

void() trigger_setskill =
{
	InitTrigger();
	self.touch = trigger_skill_touch;
};

//============================================================================

void() trigger_onlyregistered_touch =
{
	if (other.classname != "player")

		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets();
		remove(self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint(other, self.message);
			sound(other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

void() trigger_onlyregistered =
{
	precache_sound("misc/talk.wav");
	InitTrigger();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage(other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return;
};

void() trigger_hurt =
{
	InitTrigger();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================

float SPAWNFLAG_PUSH_ONCE = 1;

void() trigger_push_touch =
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound(other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & SPAWNFLAG_PUSH_ONCE)
		remove(self);
};

void() trigger_push =
{
	InitTrigger();
	precache_sound("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;

	// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if (!(other.flags & FL_ONGROUND))
		return;

	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger();
	self.touch = trigger_monsterjump_touch;
};

//============================================================================

void() execute_changelevel =
{
	entity pos;

	intermission_running = 1;

	// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 3);
	WriteByte(MSG_ALL, 3);

	pos = FindIntermission();

	other = find(world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		// turn this way immediately
		other.fixangle = TRUE;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin(other, pos.origin);
		other = find(other, classname, "player");
	}

	WriteByte(MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch =
{
	if (other.classname != "player")
		return;
	
	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	
	if (coop || deathmatch)
	{
		bprint(other.netname);
		bprint(" exited the level\n");
	}

	nextmap = self.map;

	SUB_UseTargets();

	if ((self.spawnflags & 1) && (deathmatch == 0))
	{
		// NO_INTERMISSION
		GotoNextMap();
		return;
	}

	self.touch = SUB_Null;

	// we can't move people right now, because touch functions are called
	// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

void() trigger_changelevel =
{
	if (!self.map)
		objerror("chagnelevel trigger doesn't have map");

	InitTrigger();
	self.touch = changelevel_touch;
};