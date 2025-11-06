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

void(entity targ, entity attacker) ClientObituary =
{
	float rnum;
	string deathstring, deathstring2;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - 1;
			return;
		}
		
		if (attacker.classname == "teledeath3") 
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("'s Satan's power\n");
			
			targ.frags = targ.frags - 1;
			return;
		}
		
		if (targ.deathtype == "squish")
		{
			if (teamplay && targ.team == attacker.team && targ != attacker)
			{
				attacker.frags = attacker.frags - 1;
				bprint (attacker.netname);
				bprint (" squished a teammate\n");
				return;
			}
			else if (attacker.classname == "player" && targ != attacker)
			{
				bprint (attacker.netname);
				bprint (" squishes ");
				bprint (targ.netname);
				bprint ("\n");
				attacker.frags = attacker.frags + 1;
				return;
			}
			else
			{
				// killed self
				targ.frags = targ.frags - 1;
				bprint (targ.netname);
				bprint (" was squished\n");
				return;
			}
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				
				if (targ.deathtype == "suicide")
				{
					// extra penalty
					attacker.frags = attacker.frags - 1;
					bprint (" suicides\n");
					return;
				}
				
				if (targ.deathtype == "grenade")
					bprint (" tries to put the pin back in\n");
				else if (targ.deathtype == "rocket")
					if (rnum < 0.50)
						bprint (" becomes bored with life\n");
					else
						bprint (" checks if his weapon is loaded\n");
				else if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					if (targ.watertype == CONTENT_SLIME)
						bprint (" discharges into the slime\n");
					else if (targ.watertype == CONTENT_LAVA)
						bprint (" discharges into the lava\n");
					else
						bprint (" discharges into the water.\n");
				}
				else
					bprint (" becomes bored with life\n");
				return;
			}
			else if ((teamplay == 2) && (targ.team > 0) && (targ.team == attacker.team))
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;

				rnum = attacker.weapon;
				if (targ.deathtype == "nail")
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "supernail")
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "grenade")
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				else if (targ.deathtype == "rocket")
				{
					if (attacker.super_damage_finished > 0 && targ.health < -40)
					{
						rnum = random();
						if (rnum < 0.3)
							deathstring = " was brutalized by ";
						else if (rnum < 0.6)
							deathstring = " was smeared by ";
						else
						{
							bprint (attacker.netname);
							bprint (" rips ");
							bprint (targ.netname);
							bprint (" a new one\n");
							return;
						}
						deathstring2 = "'s quad rocket\n";
					}
					else
					{
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					}
				}
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";
					else
						deathstring2 = "'s shaft\n";
				}
				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;
			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army")
					bprint(" was shot by a Grunt\n");
				if (attacker.classname == "monster_demon1")
					bprint(" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog")
					bprint(" was mauled by a Rottweiler\n");
				/*
				if (attacker.classname == "monster_dragon")
					bprint(" was fried by a Dragon\n");
				*/
				if (attacker.classname == "monster_enforcer")
					bprint(" was blasted by an Enforcer\n");
				if (attacker.classname == "monster_fish")
					bprint(" was fed to the Rotfish\n");
				if (attacker.classname == "monster_hell_knight")
					bprint(" was slain by a Death Knight\n");
				if (attacker.classname == "monster_knight")
					bprint(" was slashed by a Knight\n");
				if (attacker.classname == "monster_ogre")
					bprint(" was destroyed by an Ogre\n");
				/*
				if (attacker.classname == "monster_oldone")
					bprint(" became one with Shub-Niggurath\n");
				*/
				if (attacker.classname == "monster_shalrath")
					bprint(" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler")
					bprint(" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby")
					bprint(" was slimed by a Spawn\n");
				/*
				if (attacker.classname == "monster_vomit")
					bprint(" was vomited on by a Vomitus\n");
				*/
				if (attacker.classname == "monster_wizard")
					bprint(" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombie")
					bprint(" joins the Zombies\n");
				if (attacker.classname == "monster_boss")
					bprint (" was shamefully killed by Chthon\n");

				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				bprint (" fell to his death\n");
				return;
			}
			if (targ.deathtype == "nail" || targ.deathtype == "supernail")
			{
				bprint (" was spiked\n");
				return;
			}
			if (targ.deathtype == "laser")
			{
				bprint (" was zapped\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");
				else
					bprint (" sucks it down\n");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				return;
			}

			// hell if I know; he's just dead!!!
			bprint (" died\n");
		}
	}
};
