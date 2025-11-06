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

void() key_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items & self.items)
		return;

	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");

	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	other.items = other.items | self.items;

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;

	// fire all targets/killtargets
	SUB_UseTargets();
};

void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/
void() item_key1 =
{
	if (world.worldtype == 0)
	{
		precache_model("progs/w_s_key.mdl");
		setmodel(self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		precache_model("progs/m_s_key.mdl");
		setmodel(self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		precache_model2("progs/b_s_key.mdl");
		setmodel(self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/
void() item_key2 =
{
	if (world.worldtype == 0)
	{
		precache_model("progs/w_g_key.mdl");
		setmodel(self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model("progs/m_g_key.mdl");
		setmodel(self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2("progs/b_g_key.mdl");
		setmodel(self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};
