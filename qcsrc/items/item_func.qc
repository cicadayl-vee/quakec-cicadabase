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

ALL LIGHTS SHOULD BE 0 1 0 IN COLOR
ALL OTHER ITEMS SHOULD BE .8 .3 .4 IN COLOR

============================================================================*/

void() W_SetCurrentAmmo;

void() SUB_regen =
{
	// restore original model
	self.model = self.mdl;

	// allow it to be touched again
	self.solid = SOLID_TRIGGER;

	// play respawn sound
	sound(self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);

	setorigin(self, self.origin);
};

/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint("noclass spawned at");
	dprint(vtos(self.origin));
	dprint("\n");
	remove(self);
};

/*============================================================================

PlaceItem

Plants the object on the floor

============================================================================*/
void() PlaceItem =
{
	float oldz;

	// so it can be restored on respawn
	self.mdl = self.model;
	// make extra wide
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor())
	{
		dprint("Bonus item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}
};

/*============================================================================

StartItem

Sets the clipping size and plants the object on the floor

============================================================================*/
void() StartItem =
{
	// items start after other solids
	self.nextthink = time + 0.2;
	self.think = PlaceItem;
};
