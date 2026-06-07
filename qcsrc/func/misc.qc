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

MISC ENTITIES

============================================================================*/

void() info_null = { remove(self); };

void() info_notnull = {};

void() viewthing =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model("progs/player.mdl");
	setmodel(self, "progs/player.mdl");
};

void() noise_think =
{
	self.nextthink = time + 0.5;
	sound(self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound(self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound(self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound(self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound(self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound(self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound(self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

void() misc_noisemaker =
{
	precache_sound2("enforcer/enfire.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("enforcer/sight1.wav");
	precache_sound2("enforcer/sight2.wav");
	precache_sound2("enforcer/sight3.wav");
	precache_sound2("enforcer/sight4.wav");
	precache_sound2("enforcer/pain1.wav");
	precache_sound2("enforcer/pain2.wav");
	precache_sound2("enforcer/death1.wav");
	precache_sound2("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};