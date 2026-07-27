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

TRIGGERS - COUNTER

============================================================================*/

void() counter_use =
{
	self.count = self.count - 1;
	if (self.count < 0)
		return;

	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_TRIG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint(activator, "There are more to go...");
			else if (self.count == 3)
				centerprint(activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint(activator, "Only 2 more to go...");
			else
				centerprint(activator, "Only 1 more to go...");
		}
		return;
	}

	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_TRIG_NOMESSAGE) == 0)
		centerprint(activator, "Sequence completed!");

	self.enemy = activator;
	multi_trigger();
};

/*============================================================================

trigger_counter

Acts as an intermediary for an action that takes multiple inputs.
If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.
After the counter has been triggered "count" times (default 2), 
it will fire all of it's targets and remove itself.

============================================================================*/

void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};