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

TRIGGERS - MULTIPLE

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

/*============================================================================

trigger_multiple

NOTOUCH has been obsoleted by trigger_relay!

Variable sized repeatable trigger.  Must be targeted at one or more entities.  
If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
If "notouch" is set, the trigger is only fired by other entities, not by touching.

"wait" : Seconds between triggerings. (.2 default)
"message" : set text string

sounds
1: secret
2: beep beep
3: large switch

============================================================================*/

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

/*============================================================================

trigger_once

Variable sized trigger. Triggers once, then removes itself.  

You must set the key "target" to the name of another object in the level that has a matching "targetname".
 
If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
If "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
If "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.

"message" : set text string

"sounds"
1: secret
2: beep beep
3: large switch

============================================================================*/

void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

/*============================================================================

trigger_secret

Secret counter trigger.

"message" : set text string

sounds
1: secret
2: beep beep

============================================================================*/

void() trigger_secret =
{
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
	
	total_secrets = total_secrets + 1;
	self.wait = -1;

	trigger_multiple();
};