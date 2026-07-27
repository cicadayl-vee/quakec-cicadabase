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

PLAYER - PAIN/DEATH

============================================================================*/

/*============================================================================

PainSound

============================================================================*/

void() PainSound =
{
	float rs;

	if (self.health < 0)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5)
			sound(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

	// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
		// FIXME put in some steam here
		if (random() > 0.5)
			sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;

	// don't make multiple pain sounds right after each other

	// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound(self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}

	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else if (rs == 4)
		self.noise = "player/pain4.wav";
	else if (rs == 5)
		self.noise = "player/pain5.wav";
	else
		self.noise = "player/pain6.wav";

	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void(entity attacker, float damage) player_pain =
{
	if (self.weaponframe)
		return;

	// eyes don't have pain frames
	if (self.invisible_finished > time)
		return;

	if (self.weapon == IT_AXE)
		player_axpain1();
	else
		player_pain1();
};

void() DeathBubblesSpawn =
{
	entity bubble;
	
	if (self.owner.watertype == CONTENT_SLIME || self.owner.watertype == CONTENT_LAVA)
		return;
	
	if (self.owner.waterlevel != 3 && (self.owner.health > 0))
	{
		// remove bubble spawner
		remove(self);
		return;
	}
	
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

/*============================================================================

DeathBubbles

============================================================================*/

void(float num_bubbles) DeathBubbles =
{
	entity bubble_spawner;

	bubble_spawner = spawn();
	setorigin(bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};

/*============================================================================

DeathSound

============================================================================*/

void() DeathSound =
{
	float rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(5);
		sound(self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
		return;
	}

	rs = rint((random() * 4) + 1);
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};

void() PlayerDead =
{
	self.nextthink = -1;

	// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

/*============================================================================

GibPlayer

============================================================================*/

void() GibPlayer =
{
	ThrowHead("progs/h_player.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (random() < 0.5)
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

/*============================================================================

PlayerDie

============================================================================*/

void() PlayerDie =
{
	float i;

	self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
	// don't die as eyes
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.effects = 0;
	// don't use eyes
	self.modelindex = modelindex_player;

	if (deathmatch || coop)
		DropBackpack();

	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random() * 300;

	if (self.health < -40)
	{
		GibPlayer();
		return;
	}

	DeathSound();

	self.angles_x = 0;
	self.angles_z = 0;

	if (self.weapon == IT_AXE)
	{
		player_die_ax1();
		return;
	}

	i = cvar("temp1");
	if (!i)
		i = 1 + floor(random() * 6);

	if (i == 1)
		player_diea1();
	else if (i == 2)
		player_dieb1();
	else if (i == 3)
		player_diec1();
	else if (i == 4)
		player_died1();
	else
		player_diee1();

};

// used by kill command and diconnect command
void() set_suicide_frame =
{
	self.model = "progs/h_player.mdl";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};

/*============================================================================

PlayerDeathThink

============================================================================*/

void() PlayerDeathThink =
{
	float forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward * normalize(self.velocity);
	}

	// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};