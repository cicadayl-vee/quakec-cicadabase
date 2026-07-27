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

TRIGGERS - SETSKILL

============================================================================*/

void() trigger_skill_touch =
{
	if (other.classname != "player")
		return;

	cvar_set("skill", self.message);
};

/*============================================================================

trigger_setskill

Sets skill level to the value of "message".
Only used on start map.

============================================================================*/

void() trigger_setskill =
{
	InitTrigger();
	self.touch = trigger_skill_touch;
};

