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

W_FireAxe

============================================================================*/
void() W_FireAxe =
{
	vector source;
	vector org;
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * 64, FALSE, self);

	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward * 4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood(org, '0 0 0', 20);
		T_Damage(trace_ent, self, self, 20);
	}
	else
	{
		// hit wall
		sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};
