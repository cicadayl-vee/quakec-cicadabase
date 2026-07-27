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

BUILT-IN FUNCTIONS

============================================================================*/

// sets v_forward, etc globals
void(vector ang) makevectors = #1;

void(entity e, vector o) setorigin = #2;

// set movetype and solid first
void(entity e, string m) setmodel = #3;

void(entity e, vector min, vector max) setsize = #4;

// #5 was removed

void() break = #6;

// returns 0 - 1
float() random = #7;

void(entity e, float chan, string samp, float vol, float atten) sound = #8;
vector(vector v) normalize = #9;
void(string e) error = #10;
void(string e) objerror = #11;
float(vector v) vlen = #12;
float(vector v) vectoyaw = #13;
entity() spawn = #14;
void(entity e) remove = #15;

// sets trace_* globals
// nomonsters can be:
// An entity will also be ignored for testing if forent == test,
// forent->owner == test, or test->owner == forent
// a forent of world is ignored
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16;

// returns a client to look for
entity() checkclient = #17;

entity(entity start, .string fld, string match) find = #18;
string(string s) precache_sound = #19;
string(string s) precache_model = #20;
void(entity client, string s)stuffcmd = #21;
entity(vector org, float rad) findradius = #22;
void(string s) bprint = #23;
void(entity client, string s) sprint = #24;
void(string s) dprint = #25;
string(float f) ftos = #26;
string(vector v) vtos = #27;
// prints all edicts
void() coredump = #28;

// turns statment trace on
void() traceon = #29;

void() traceoff = #30;

// prints an entire edict
void(entity e) eprint = #31;

// returns TRUE or FALSE
float(float yaw, float dist) walkmove = #32;

// #33 was removed

// The engine code doesn't indicate the params to be used
// float(float yaw, float dist) droptofloor= #34;

// TRUE if landed on floor
float() droptofloor = #34;

void(float style, string value) lightstyle = #35;

// round to nearest int
float(float v) rint = #36;

// largest integer <= v
float(float v) floor = #37;
// smallest integer >= v
float(float v) ceil = #38;

// #39 was removed

// true if self is on ground
float(entity e) checkbottom = #40;

// returns a CONTENT_*
float(vector v) pointcontents = #41;

// #42 was removed

float(float f) fabs = #43;

// returns the shooting vector
vector(entity e) aim = #44;

// return cvar.value
float(string s) cvar = #45;

// put string into local que
void(string s) localcmd = #46;

// for looping through all ents
entity(entity e) nextent = #47;

// start a particle effect
void(vector o, vector d, float color, float count) particle = #48;

// turn towards self.ideal_yaw
// at self.yaw_speed
void() ChangeYaw = #49;

// #50 was removed

vector(vector v) vectoangles = #51;

// direct client message generation
void(float to, float f) WriteByte = #52;
void(float to, float f) WriteChar = #53;
void(float to, float f) WriteShort = #54;
void(float to, float f) WriteLong = #55;
void(float to, float f) WriteCoord = #56;
void(float to, float f) WriteAngle = #57;
void(float to, string s) WriteString = #58;
void(float to, entity s) WriteEntity = #59;

// broadcast client message generation
//void(float f) bWriteByte = #59;
//void(float f) bWriteChar = #60;
//void(float f) bWriteShort = #61;
//void(float f) bWriteLong = #62;
//void(float f) bWriteCoord = #63;
//void(float f) bWriteAngle = #64;
//void(string s) bWriteString = #65;
//void(entity e) bWriteEntity = #66;

void(float step) movetogoal = #67;

// no effect except for -copy
string(string s) precache_file = #68;

void(entity e) makestatic = #69;
void(string s) changelevel = #70;

//#71 was removed

// sets cvar.value
void(string var, string val) cvar_set = #72;

// sprint, but in middle
void(entity client, string s) centerprint = #73;

void(vector pos, string samp, float vol, float atten) ambientsound = #74;

// registered version only
string(string s) precache_model2 = #75;
string(string s) precache_sound2 = #76;
string(string s) precache_file2 = #77;

// set parm1... to the
// values at level start
// for coop respawn
void(entity e) setspawnparms = #78;