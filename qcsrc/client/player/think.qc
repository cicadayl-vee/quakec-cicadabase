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

PLAYER - THINK FUNCTIONS

============================================================================*/

/*============================================================================

PlayerPreThink

Called every frame before physics are run

============================================================================*/

void() PlayerPreThink =
{
	if (intermission_running)
	{
		// otherwise a button could be missed between the think tics
		IntermissionThink();
		return;
	}

	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;

	// is this still used?
	makevectors(self.v_angle);
	
	self.deathtype = "";

	CheckRules();
	WaterMove();

	if (self.waterlevel == 2)
		CheckWaterJump();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}

	// dying, so do nothing
	if (self.deadflag == DEAD_DYING)
		return;

	if (self.button2)
		PlayerJump();
	else
		self.flags = self.flags | FL_JUMPRELEASED;

	// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';
		
	if (time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};

/*============================================================================

PlayerPostThink

Called every frame after physics are run

============================================================================*/

void() PlayerPostThink =
{
	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;
	if (self.deadflag)
		return;

	// do weapon stuff
	W_WeaponFrame();
	
	PlayerFall();
	
	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups();
	CheckHealthRot();
};
