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

IMPULSES - COMMANDS

============================================================================*/

/*============================================================================

ImpulseCommands

============================================================================*/

void() ImpulseCommands =
{
	// weapon switching
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon();
	if (self.impulse == 10)
		CycleWeaponCommand();
	if (self.impulse == 12)
		CycleWeaponReverseCommand();
	
	// cheats
	if (self.impulse == 9)
		WeaponsCheat();
	if (self.impulse == 255)
		QuadCheat();
	if (self.impulse == 205)
		OmnicideCheat();
	
	// dev
	if (self.impulse == 11)
		ServerflagsCommand();

	self.impulse = 0;
};