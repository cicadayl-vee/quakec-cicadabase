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

SOURCE FOR GLOBALVARS_T C STRUCTURE

============================================================================*/

/*============================================================================

SYSTEM GLOBALS

============================================================================*/

entity self;
entity other;
entity world;
float time;
float frametime;

// force all entities to touch triggers
// next frame.  this is needed because
// non-moving things don't normally scan
// for triggers, and when a trigger is
// created(like a teleport trigger), it
// needs to catch everything.
// decremented each frame, so set to 2
// to guarantee everything is touched
float force_retouch;

string mapname;

float deathmatch;
float coop;
float teamplay;

// propagated from level to level, used to keep track of completed episodes
float serverflags;

float total_secrets;
float total_monsters;

// number of secrets found
float found_secrets;

// number of monsters killed
float killed_monsters;

// spawnparms are used to encode information about clients across server
// level changes
float parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

//
// global variables set by built in functions
//

// set by makevectors()
vector v_forward, v_up, v_right;

// set by traceline / tracebox
float trace_allsolid;
float trace_startsolid;
float trace_fraction;
vector trace_endpos;
vector trace_plane_normal;
float trace_plane_dist;
entity trace_ent;
float trace_inopen;
float trace_inwater;

// destination of single entity writes
entity msg_entity;

/*============================================================================

REQUIRED PROG FUNCTIONS

============================================================================*/

// only for testing
void() main;

void() StartFrame;

void() PlayerPreThink;
void() PlayerPostThink;

void() ClientKill;
void() ClientConnect;
// call after setting the parm1... parms
void() PutClientInServer;
void() ClientDisconnect;

// called when a client first connects to
// a server. sets parms so they can be
// saved off for restarts
void() SetNewParms;

// call to set parms for self so they can
// be saved for a level transition
void() SetChangeParms;

//================================================
// flag for structure dumping
void end_sys_globals;
//================================================

/*============================================================================

SOURCE FOR ENTVARS_T C STRUCTURE

============================================================================*/

/*============================================================================

SYSTEM FIELDS (*** = do not set in prog code, maintained by C code)

============================================================================*/

// *** model index in the precached list
.float modelindex;

// *** origin + mins / maxs
.vector absmin, absmax;

// local time for entity
.float ltime;
.float movetype;
.float solid;

.vector origin;
.vector oldorigin;
.vector velocity;
.vector angles;
.vector avelocity;

// temp angle adjust from damage or recoil
.vector punchangle;

// spawn function
.string classname;
.string model;
.float frame;
.float skin;
.float effects;

// bounding box extents reletive to origin
.vector mins, maxs;
// maxs - mins
.vector size;

.void() touch;
.void() use;
.void() think;
// for doors or plats, called when can't push other
.void() blocked;

.float nextthink;
.entity groundentity;

// stats
.float health;
.float frags;
// one of the IT_SHOTGUN, etc flags
.float weapon;
.string weaponmodel;
.float weaponframe;
.float currentammo;
.float ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

// bit flags
.float items;

.float takedamage;
.entity chain;
.float deadflag;

// add to origin to get eye point
.vector view_ofs;

.float button0; // fire
.float button1; // use
.float button2; // jump

// weapon changes
.float impulse;

.float fixangle;
// view/targeting angle for players
.vector v_angle;
// calculated pitch angle for lookup up slopes
.float idealpitch;

.string netname;

.entity enemy;

.float flags;

.float colormap;
.float team;

// players maximum health is stored here
.float max_health;

// don't back up
.float teleport_time;

// save this fraction of incoming damage
.float armortype;
.float armorvalue;

// 0 = not in, 1 = feet, 2 = wast, 3 = eyes
.float waterlevel;
// a contents value
.float watertype;

.float ideal_yaw;
.float yaw_speed;

.entity aiment;

// a movetarget or an enemy
.entity goalentity;

.float spawnflags;

.string target;
.string targetname;

// damage is accumulated through a frame. and sent as one single
// message, so the super shotgun doesn't generate huge messages
.float dmg_take;
.float dmg_save;
.entity dmg_inflictor;

// who launched a missile
.entity owner;
// mostly for doors, but also used for waterjump
.vector movedir;

// trigger messages
.string message;

// either a cd track number or sound number
.float sounds;

// contains names of wavs to play
.string noise, noise1, noise2, noise3;

//================================================
// flag for structure dumping
void end_sys_fields;
//================================================

/*============================================================================

GLOBALS

============================================================================*/

float movedist;

// set when a rule exits
float gameover;

// null string, nothing should be held here
string string_null;

// launch_spike sets this after spawning it
entity newmis;

// the entity that activated a trigger or brush
entity activator;

// set by T_Damage
entity damage_attacker;
float framecount;

float skill;

/*============================================================================

WORLD FIELDS
FIXME: make globals

============================================================================*/

.string wad;
.string map;
// 0 = medieval
// 1 = metal
// 2 = base
.float worldtype;

.string killtarget;

/*============================================================================

QUAKEED FIELDS

============================================================================*/

// not used by game, but parsed by light util
.float light_lev;
.float style;

/*============================================================================

MONSTER AI

============================================================================*/

.void() th_stand;
.void() th_walk;
.void() th_run;
.void() th_missile;
.void() th_melee;
.void(entity attacker, float damage) th_pain;
.void() th_die;

// mad at this player before taking damage
.entity oldenemy;

.float speed;

.float lefty;

.float search_time;
.float attack_state;

// zombies
.float inpain;

/*============================================================================

PLAYER ONLY FIELDS

============================================================================*/

.float walkframe;

.float attack_finished;
.float pain_finished;

.float invincible_finished;
.float invisible_finished;
.float super_damage_finished;
.float radsuit_finished;

.float invincible_time, invincible_sound;
.float invisible_time, invisible_sound;
.float super_time, super_sound;
.float rad_time;
.float fly_sound;

// if grabbed Mega-Health, the next time we'll rot the players health
.float healthrot_nextcheck;

.float axhitme;

// set to time + 0.2 whenever a client fires a
// weapon or takes damage.  Used to alert
// monsters that otherwise would let the player go
.float show_hostile;

// player jump flag
.float jump_flag;

// player swimming sound flag
.float swim_flag;

// when time > air_finished, start drowning
.float air_finished;

// keeps track of the number of bubbles
.float bubble_count;

// keeps track of how the player died
.string deathtype;

// players can't suicide within this time
.float suicide_time;

// keeps track of how many times the player used the kill command
.float killbind_count;

// drowning dmg
.float dmgtime;

/*============================================================================

OBJECT STUFF

============================================================================*/

.string mdl;

// angle at start
.vector mangle;

// only used by secret door
.vector oldorigin;

.float t_length, t_width;

/*============================================================================

DOORS, ETC

============================================================================*/

.vector dest, dest1, dest2;
// time from firing to restarting
.float wait;
// time from activation to firing
.float delay;
// door's trigger entity
.entity trigger_field;
.string noise4;

/*============================================================================

MONSTERS

============================================================================*/

.float pausetime;
.entity movetarget;

/*============================================================================

DOORS

============================================================================*/

.float aflag;
// damage done by door when hit
.float dmg;

/*============================================================================

MISC

============================================================================*/

// misc flag
.float cnt;

/*============================================================================

SUBS

============================================================================*/

.void() think1;
.vector finaldest, finalangle;

/*============================================================================

TRIGGERS

============================================================================*/

// for counting triggers
.float count;

/*============================================================================

PLATS/DOORs/BUTTONS

============================================================================*/

.float lip;
.float state;
// top and bottom positions
.vector pos1, pos2;
.float height;

/*============================================================================

SOUNDS

============================================================================*/

.float waitmin, waitmax;
.float distance;
.float volume;

/*============================================================================

ITEMS

============================================================================*/

.float healamount, healtype;

/*============================================================================

CHANGELEVEL/INTERMISSIONS

============================================================================*/

float intermission_running;
float intermission_exittime;
string nextmap;
