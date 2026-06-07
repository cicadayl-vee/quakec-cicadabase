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

SIMPLE BMODELS

============================================================================*/

// change to alternate textures
void() func_wall_use = { self.frame = 1 - self.frame; };

/*============================================================================

func_wall

This is just a solid wall if not inhibitted.

============================================================================*/

void() func_wall =
{
	self.angles = '0 0 0';
	// so it doesn't get pushed by anything
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

/*============================================================================

func_illusionary

A simple entity that looks solid but lets you walk through it.

============================================================================*/

void() func_illusionary =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
};

/*============================================================================

func_episodegate

This bmodel will appear if the episode has already been completed, 
so players can't re-enter it.

============================================================================*/

void() func_episodegate =
{
	// can still enter episode
	if (!(serverflags & self.spawnflags))
		return;

	self.angles = '0 0 0';
	// so it doesn't get pushed by anything
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

/*============================================================================

func_bossgate

This bmodel appears unless players have all of the episode sigils.

============================================================================*/

void() func_bossgate =
{
	// all episodes completed
	if ((serverflags & 15) == 15)
		return;

	self.angles = '0 0 0';
	// so it doesn't get pushed by anything
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};