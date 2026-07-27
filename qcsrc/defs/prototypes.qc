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

PROTOTYPES

============================================================================*/

/*============================================================================

SUBS

============================================================================*/

void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void() SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_UseTargets;
void() SUB_Remove;
float(entity targ) visible;

/*============================================================================

WORLD

============================================================================*/

void() InitBodyQue;
void() InitLightStyles;

/*============================================================================

FIGHT

============================================================================*/

float(float v) anglemod;
void(vector dest) ChooseTurn;
void() ai_face;
float(entity targ, entity inflictor) CanDamage;
float() DemonCheckAttack;
void(float side) Demon_Melee;
void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;
void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;

/*============================================================================

AI

============================================================================*/

void() movetarget_f;
void() t_movetarget;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
float() WizardCheckAttack;
float() DogCheckAttack;
float() SoldierCheckAttack;
float() ShamCheckAttack;
float() OgreCheckAttack;

/*============================================================================

DAMAGE

============================================================================*/

void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;

/*============================================================================

ITEM_FUNC

============================================================================*/

void() W_SetCurrentAmmo;

/*============================================================================

AMMO

============================================================================*/

float() W_BestWeapon;

/*============================================================================

WEAPONS

============================================================================*/

void() player_run;
void() player_axe1;
void() player_axeb1;
void() player_axec1;
void() player_axed1;
void() player_shot1;
void() player_nail1;
void() player_light1;
void() player_rocket1;
void() ImpulseCommands;

/*============================================================================

DOORS

============================================================================*/

void() door_go_down;
void() door_go_up;
void() fd_secret_move1;
void() fd_secret_move2;
void() fd_secret_move3;
void() fd_secret_move4;
void() fd_secret_move5;
void() fd_secret_move6;
void() fd_secret_done;

/*============================================================================

BUTTONS

============================================================================*/

void() button_wait;
void() button_return;

/*============================================================================

PLATS

============================================================================*/

void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;

/*============================================================================

TRAINS

============================================================================*/

void() train_next;
void() func_train_find;

/*============================================================================

CHANGELEVEL/INTERMISSION

============================================================================*/

entity() FindIntermission;

/*============================================================================

TRAPS

============================================================================*/

void(vector org, vector vec) LaunchLaser;

/*============================================================================

LIGHTS

============================================================================*/

void() FireAmbient;

/*============================================================================

MISC

============================================================================*/

void() fire_fly;
void() fire_touch;
void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*============================================================================

CONNECT

============================================================================*/

void() DecodeLevelParms;
void() PlayerDie;
void() set_suicide_frame;
void(entity attacker, float damage) player_pain;
void() player_stand1;

/*============================================================================

PLAYER

============================================================================*/

void() PainSound;
void(float num_bubbles) DeathBubbles;
void() PlayerDead;
void() bubble_bob;
void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;

/*============================================================================

DEMON

============================================================================*/

void() Demon_JumpTouch;

/*============================================================================

SHAMBLER

============================================================================*/

void() sham_swingr1;

/*============================================================================

SOLDIER

============================================================================*/

void() army_fire;

/*============================================================================

WIZARD

============================================================================*/

void() wiz_run1;
void() wiz_side1;

/*============================================================================

DOG

============================================================================*/

void() dog_leap1;
void() dog_run1;

/*============================================================================

BOSS

============================================================================*/

void(vector p) boss_missile;

/*============================================================================

TARBABY

============================================================================*/

void() tbaby_jump1;
void() tbaby_jump5;

/*============================================================================

HKNIGHT

============================================================================*/

void() hknight_char_a1;
void() hknight_run1;
void() hk_idle_sound;

/*============================================================================

SHALRATH

============================================================================*/

void(entity attacker, float damage) shalrath_pain;
void() ShalMissile;
void() ShalMissileTouch;
void() ShalHome;

/*============================================================================

OLDONE

============================================================================*/

void() finale_1;
void() finale_2;
void() finale_3;
void() finale_4;
