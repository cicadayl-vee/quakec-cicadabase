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

void() train_next;
void() func_train_find;

void() train_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	other.deathtype = "squish";
	T_Damage(other, self, self, self.dmg);
};

void() train_use =
{
	// already activated
	if (self.think != func_train_find)
		return;
	train_next();
};

void() train_wait =
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else
		self.nextthink = self.ltime + 0.1;

	self.think = train_next;
};

void() train_next =
{
	entity targ;

	targ = find(world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror("train_next: no next target");
	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;
	sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove(targ.origin - self.mins, self.speed, train_wait);
};

void() func_train_find =

{
	entity targ;

	targ = find(world, targetname, self.target);
	self.target = targ.target;
	setorigin(self, targ.origin - self.mins);

	// not triggered, so start immediately
	if (!self.targetname)
	{
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

/*QUAKED func_train (0 .5 .8) ?
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.
speed default 100
dmg default 2
sounds
1) ratchet metal
*/
void() func_train =
{
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror("func_train without a target");
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound("plats/train1.wav");
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

/*QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
This is used for the final bos
*/
void() misc_teleporttrain =
{
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror("func_train without a target");

	self.cnt = 1;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';

	self.noise = ("misc/null.wav");
	precache_sound("misc/null.wav");
	self.noise1 = ("misc/null.wav");
	precache_sound("misc/null.wav");

	precache_model2("progs/teleport.mdl");
	setmodel(self, "progs/teleport.mdl");
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};
