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

LEVEL CHANGING/INTERMISSION

============================================================================*/

float intermission_running;
float intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};

/*============================================================================

FindIntermission

Returns the entity to view from

============================================================================*/
entity() FindIntermission =
{
	entity spot;
	float cyc;

	// look for info_intermission first
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
				spot = find(spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

	// then look for the start position
	spot = find(world, classname, "info_player_start");
	if (spot)
		return spot;

	// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;

	objerror("FindIntermission: no spot");
	return world;
};

string nextmap;
void() GotoNextMap =
{
	// if samelevel is set, stay on same level
	if (cvar("samelevel"))
		changelevel(mapname);
	else
		changelevel(nextmap);
};

void() ExitIntermission =
{
	// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap();
		return;
	}

	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

	//
	// run some text if at the end of an episode
	//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);

			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		}

		GotoNextMap();
	}

	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{
			// shareware episode has been completed, go to sell screen
			WriteByte(MSG_ALL, SVC_SELLSCREEN);
			return;
		}

		if ((serverflags & 15) == 15)
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}

	}

	GotoNextMap();
};

/*============================================================================

IntermissionThink

When the player presses attack or jump, change to the next level

============================================================================*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;

	ExitIntermission();
};
