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

SPAWNFLAGS

============================================================================*/

/*============================================================================

ITEMS

============================================================================*/

const float SPAWNFLAG_HEATH_ROTTEN = 1;
const float SPAWNFLAG_HEATH_MEGA = 2;

const float SPAWNFLAG_WEAPON_BIG2 = 1;
const float SPAWNFLAG_WEAPON_SHOTGUN = 1;
const float SPAWNFLAG_WEAPON_ROCKET = 2;
const float SPAWNFLAG_WEAPON_SPIKES = 4;
const float SPAWNFLAG_WEAPON_BIG = 8;

/*============================================================================

BMODELS

============================================================================*/

const float SPAWNFLAG_DOOR_START_OPEN = 1;
const float SPAWNFLAG_DOOR_DONT_LINK = 4;
const float SPAWNFLAG_DOOR_GOLD_KEY = 8;
const float SPAWNFLAG_DOOR_SILVER_KEY = 16;
const float SPAWNFLAG_DOOR_TOGGLE = 32;

const float SPAWNFLAG_SECRET_OPEN_ONCE = 1;		// stays open
const float SPAWNFLAG_SECRET_1ST_LEFT = 2;		// 1st move is left of arrow
const float SPAWNFLAG_SECRET_1ST_DOWN = 4;		// 1st move is down from arrow
const float SPAWNFLAG_SECRET_NO_SHOOT = 8;		// only opened by trigger
const float SPAWNFLAG_SECRET_YES_SHOOT = 16;		// shootable even if targeted

const float SPAWNFLAG_PLAT_LOW_TRIGGER = 1;

/*============================================================================

TRIGGERS

============================================================================*/

const float SPAWNFLAG_TRIG_NOTOUCH = 1;
const float SPAWNFLAG_TRIG_NOMESSAGE = 1;

const float SPAWNFLAG_PUSH_ONCE = 1;

const float SPAWNFLAG_TELE_PLAYER_ONLY = 1;
const float SPAWNFLAG_TELE_NO_AMBIENCE = 2;

/*============================================================================

ENTITIES

============================================================================*/

const float SPAWNFLAG_LIT_START_OFF = 1;

const float SPAWNFLAG_TRAP_SUPERSPIKE = 1;
const float SPAWNFLAG_TRAP_LASER = 2;

/*============================================================================

MONSTERS

============================================================================*/

const float SPAWN_CRUCIFIED = 1; // TODO: rename
