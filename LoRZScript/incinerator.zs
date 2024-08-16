class JGP_Incinerator : Weapon replaces PlasmaRifle
{
	Default
	{
		Weapon.SlotNumber 6;
		Weapon.AmmoType1 'Cell';
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 50;
		Inventory.PickupMessage "$ID24_GOTINCINERATOR";
	}

	action void A_IncineratorFire()
	{
		A_StartSound("DoomRR/incinerator/fire", CHAN_WEAPON);
		A_FireProjectile('JGP_IncineratorFlame');
		A_Overlay(PSP_FLASH, "Flash");
		A_OverlayFlags(PSP_FLASH, PSPF_RenderStyle|PSPF_ForceAlpha, true);
		A_OverlayRenderStyle(PSP_FLASH, STYLE_Add);
	}
	
	States {
	Spawn:
		INCN A -1;
		stop;
	Select:
		FLMG A 1 A_Raise;
		loop;
	Deselect:
		FLMG A 1 A_Lower;
		loop;
	Ready:
		FLMG A 1 A_WeaponReady;
		loop;
	// The fire sequence is modified, because the original BCB flickering
	// every tic is pretty hard on the eyes. Instead it cycles between
	// B and C every time this sequence is called:
	Fire:
		FLMG B 3 
		{
			if (player.refire % 2 == 0)
			{
				let psp = player.FindPSprite(OverlayID());
				if (psp)
				{
					psp.frame = 2;
				}
			}
			A_IncineratorFire();
		}
		TNT1 A 0 A_ReFire;
		goto Ready;
	Flash:
		FLMF A 0
		{
			let psp = player.FindPSprite(OverlayID());
			let psw = player.FindPSprite(PSP_WEAPON);
			if (psp && psw)
			{
				switch (psw.frame)
				{
				// Flash for FLMGB uses FLMFA or FLMFB randomly
				case 1:
					psp.frame = random[incin](0,1);
					break;
				// Flash for FLMGC uses FLMFC or FLMFD randomly
				case 2:
					psp.frame = random[incin](2,3);
					break;
				}

			}
		}
		// Pulse the alpha with a sine wave every tic while
		// this flash exists:
		#### ### 1 bright
		{
			A_OverlayAlpha(OverlayID(), 0.75 + 0.25 * sin(360.0 * player.refire / 10));
		}
		goto LightDone;
	}
}

class JGP_IncineratorFlame : Actor
{
	Vector2 defscale;

	static const color partColors[] = 
	{
		"ffb37b",
		"f37317",
		"cb5707",
		"af4300"
	};	

	Default
	{
		Tag "Incinerator Flame";
		Projectile;
		Radius 13;
		Height 8;
		Damage DOOMRR_INCINERATOR_FLAME_DAMAGE;
		Speed DOOMRR_INCINERATOR_FLAME_VELOCITY;
		ExplosionDamage DOOMRR_INCINERATOR_BURN_DAMAGE;
		ExplosionRadius DOOMRR_INCINERATOR_BURN_RADIUS;
		+FORCERADIUSDMG
		+BRIGHT
		RenderStyle 'Add';
		Alpha 0.75;
	}

	// Randomly mirror the sprite and randomize
	// its scale a bit to add more variety:
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		bSPRITEFLIP = random[incin](0,1);
		scale *= frandom[incin](0.7, 1);
		defscale = scale; //record scale after randomization
	}

	override void Tick()
	{
		Super.Tick();
		// When the projectile dies, it sets its scale to 33%
		// of what it was. During death we'll gradually bring it back to scale:
		if (!isFrozen() && !bMissile)
		{
			scale.x = clamp(scale.x += 0.05, 0, defscale.x);
			scale.y = clamp(scale.y += 0.05, 0, defscale.y);
			// And we'll also raise its sprite every 2 tics:
			if (GetAge() % 2 == 0)
			{
				spriteoffset.y -= 1;
			}
			if (alpha >= default.alpha)
			{
				FSpawnParticleParams p;
				p.lifetime = random[incin](30, 40);
				p.size = random[incin](3, 6);
				p.style = STYLE_Add;
				p.flags = SPF_FULLBRIGHT;
				p.vel = (0, 0, frandom[incin](0.4, 0.6));
				p.accel.z = (-p.vel.z / p.lifetime);
				double vofs = 45 - (24 - frame*2); //the earlier in the animation, the lower the particles spawn.
				p.pos = level.Vec3Offset(pos, (frandom(-8, 8), frandom(-8, 8), 15 + frandom(0, vofs)));
				p.startalpha = alpha;
				p.fadestep = -1;
				p.color1 = partColors[ random[incin](0, partColors.Size()-1) ];
				level.SpawnParticle(p);
			}
		}
	}

	States {
	Spawn:
		TNT1 A 2;
		IFLM A 1;
		IFLM B 2 A_StartSound("DoomRR/incinerator/burn");
		IFLM CDEFGH 2 A_FadeOut(0.1, FTF_Clamp);
		stop;
	Death:
		// The death sequence uses modified sprites made from the original
		// with the TEXTURES lump. Again, Arch-Vile-style flickering
		// between current and previous flame that the original sequence
		// had is rather hard on the eyes and not particularly pretty.
		// I added extra sprites from the Spawn sequence, and with added
		// scale and spriteoffset changes it appears smoother.
		TNT1 A 0 
		{
			A_StartSound("DoomRR/IncineratorFlame/death");
			scale *= 0.3;
			alpha = default.alpha;
		}
		IFLR A 3 A_Explode;
		IFLR B 3;
		IFLR C 2 A_Explode;
		IFLR D 4;
		IFLR E 2 A_Explode;
		IFLR F 4;
		IFLR G 2 A_StartSound("DoomRR/IncineratorFlame/fizzle");
		IFLR H 2 A_Explode();
		IFLR I 4;
		IFLR J 2 A_Explode();
		IFLR K 2;
		IFLR L 2 A_Explode();
		IFLR L 2
		{
			A_FadeOut(0.1);
		}
		wait;
	}
}