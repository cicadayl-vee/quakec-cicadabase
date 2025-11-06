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

void() sigil_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint(other, "You got the rune!");

	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);

	// so rune doors won't find it
	self.classname = "";

	activator = other;

	// fire all targets/killtargets
	SUB_UseTargets();
};

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/
void() item_sigil =
{
	if (!self.spawnflags)
		objerror("no spawnflags");

	precache_sound("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model("progs/end1.mdl");
		setmodel(self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2("progs/end2.mdl");
		setmodel(self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2("progs/end3.mdl");
		setmodel(self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2("progs/end4.mdl");
		setmodel(self, "progs/end4.mdl");
	}

	self.touch = sigil_touch;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};
