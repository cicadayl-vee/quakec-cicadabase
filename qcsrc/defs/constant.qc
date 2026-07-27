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

CONSTANTS

============================================================================*/

const float FALSE = 0;
const float TRUE = 1;

// edict.flags
const float FL_FLY				= 1;
const float FL_SWIM				= 2;
const float FL_CLIENT			= 8;	// set for all client edicts
const float FL_INWATER			= 16;	// for enter / leave water splash
const float FL_MONSTER			= 32;
const float FL_GODMODE			= 64;	// player cheat
const float FL_NOTARGET			= 128;	// player cheat
const float FL_ITEM				= 256;	// extra wide size for bonus items
const float FL_ONGROUND			= 512;	// standing on something
const float FL_PARTIALGROUND	= 1024;	// not all corners are valid
const float FL_WATERJUMP		= 2048;	// player jumping out of water
const float FL_JUMPRELEASED		= 4096;	// for jump debouncing

// edict.movetype values
const float MOVETYPE_NONE				= 0;	// never moves
const float MOVETYPE_ANGLENOCLIP		= 1;
const float MOVETYPE_ANGLECLIP			= 2;
const float MOVETYPE_WALK				= 3;	// players only
const float MOVETYPE_STEP				= 4;	// discrete, not real time unless fall
const float MOVETYPE_FLY				= 5;
const float MOVETYPE_TOSS				= 6;	// gravity
const float MOVETYPE_PUSH				= 7;	// no clip to world, push and crush
const float MOVETYPE_NOCLIP				= 8;
const float MOVETYPE_FLYMISSILE			= 9;	// fly with extra size against monsters
const float MOVETYPE_BOUNCE				= 10;
const float MOVETYPE_BOUNCEMISSILE		= 11;	// bounce with extra size

// edict.solid values
const float SOLID_NOT					= 0;	// no interaction with other objects
const float SOLID_TRIGGER				= 1;	// touch on edge, but not blocking
const float SOLID_BBOX					= 2;	// touch on edge, block
const float SOLID_SLIDEBOX				= 3;	// touch on edge, but not an onground
const float SOLID_BSP					= 4;	// bsp clip, touch on edge, block

const float AS_STRAIGHT 	= 1;
const float AS_SLIDING 		= 2;
const float AS_MELEE 		= 3;
const float AS_MISSILE 		= 4;

// range values
const float RANGE_MELEE			= 0;
const float RANGE_NEAR			= 1;
const float RANGE_MID			= 2;
const float RANGE_FAR			= 3;

// deadflag values
const float DEAD_NO				= 0;
const float DEAD_DYING			= 1;
const float DEAD_DEAD			= 2;
const float DEAD_RESPAWNABLE	= 3;

// takedamage values
const float DAMAGE_NO			= 0;
const float DAMAGE_YES			= 1;
const float DAMAGE_AIM			= 2;

// items
const float IT_AXE					= 4096;
const float IT_SHOTGUN				= 1;
const float IT_SUPER_SHOTGUN		= 2;
const float IT_NAILGUN				= 4;
const float IT_SUPER_NAILGUN		= 8;
const float IT_GRENADE_LAUNCHER		= 16;
const float IT_ROCKET_LAUNCHER		= 32;
const float IT_LIGHTNING			= 64;
const float IT_EXTRA_WEAPON			= 128;

const float IT_SHELLS				= 256;
const float IT_NAILS				= 512;
const float IT_ROCKETS				= 1024;
const float IT_CELLS				= 2048;

const float IT_ARMOR1				= 8192;
const float IT_ARMOR2				= 16384;
const float IT_ARMOR3				= 32768;
const float IT_SUPERHEALTH			= 65536;

const float IT_KEY1 				= 131072;
const float IT_KEY2 				= 262144;

const float IT_INVISIBILITY			= 524288;
const float IT_INVULNERABILITY		= 1048576;
const float IT_SUIT					= 2097152;
const float IT_QUAD					= 4194304;

// point content values
const float CONTENT_EMPTY		= -1;
const float CONTENT_SOLID		= -2;
const float CONTENT_WATER		= -3;
const float CONTENT_SLIME		= -4;
const float CONTENT_LAVA		= -5;
const float CONTENT_SKY			= -6;

const float STATE_TOP			= 0;
const float STATE_BOTTOM		= 1;
const float STATE_UP			= 2;
const float STATE_DOWN			= 3;

const vector	VEC_ORIGIN	= '0 0 0';
const vector	VEC_HULL_MIN	= '-16 -16 -24';
const vector	VEC_HULL_MAX	= '16 16 32';

const vector	VEC_HULL2_MIN	= '-32 -32 -24';
const vector	VEC_HULL2_MAX	= '32 32 64';

// protocol bytes
const float SVC_SETVIEWPORT			= 5;
const float SVC_SETVIEWANGLES		= 10;
const float SVC_TEMPENTITY			= 23;
const float SVC_KILLEDMONSTER		= 27;
const float SVC_FOUNDSECRET			= 28;
const float SVC_INTERMISSION		= 30;
const float SVC_FINALE				= 31;
const float SVC_CDTRACK				= 32;
const float SVC_SELLSCREEN			= 33;

const float TE_SPIKE			= 0;
const float TE_SUPERSPIKE		= 1;
const float TE_GUNSHOT			= 2;
const float TE_EXPLOSION		= 3;
const float TE_TAREXPLOSION		= 4;
const float TE_LIGHTNING1		= 5;
const float TE_LIGHTNING2		= 6;
const float TE_WIZSPIKE			= 7;
const float TE_KNIGHTSPIKE		= 8;
const float TE_LIGHTNING3		= 9;
const float TE_LAVASPLASH		= 10;
const float TE_TELEPORT			= 11;
const float TE_EXPLOSION2   	= 12;
const float TE_BEAM				= 13;

// sound channels
// channel 0 never willingly overrides
// other channels (1 - 7) always override a playing sound on that channel
const float CHAN_AUTO			= 0;
const float CHAN_WEAPON			= 1;
const float CHAN_VOICE			= 2;
const float CHAN_ITEM			= 3;
const float CHAN_BODY			= 4;

const float ATTN_NONE			= 0;
const float ATTN_NORM			= 1;
const float ATTN_IDLE			= 2;
const float ATTN_STATIC			= 3;

// update types
const float UPDATE_GENERAL		= 0;
const float UPDATE_STATIC		= 1;
const float UPDATE_BINARY		= 2;
const float UPDATE_TEMP			= 3;

// entity effects
const float EF_BRIGHTFIELD		= 1;
const float EF_MUZZLEFLASH		= 2;
const float EF_BRIGHTLIGHT		= 4;
const float EF_DIMLIGHT			= 8;

// messages
const float MSG_BROADCAST		= 0; // unreliable to all
const float MSG_ONE				= 1; // reliable to one (msg_entity)
const float MSG_ALL				= 2; // reliable to all
const float MSG_INIT			= 3; // write to the init string

// spawning
float IDEAL_DIST_FROM_DM_SPAWN_POINT = 384;
float MIN_DIST_FROM_DM_SPAWN_POINT = 84;