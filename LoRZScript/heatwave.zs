// This weapon is officially called Calamity Blade,
// but it's also referred to as Heatwave Generator
// in DECOHACK.

class JGP_Heatwave : Weapon replaces BFG9000
{
	int heatwaveCharge;

	Default
	{
		Tag "Heatwave Generator";
		Inventory.PickupMessage "$ID24_GOTCALAMITYBLADE";
		Weapon.SlotNumber 7;
		Weapon.AmmoType "Cell";
		Weapon.AmmoUse 10;
		Weapon.AmmoGive 100;
	}

	action void A_FireIncinerator()
	{
		A_StartSound("DoomRR/heatwave/fire", CHAN_WEAPON);
		A_GunFlash("FlashEnd");

		double angle = 5;
		switch (invoker.heatwaveCharge)
		{
		case 2:
			angle = 12.5;
			break;
		case 3:
			angle = 20;
			break;
		case 4:
			angle = 27.5;
			break;
		case 5:
			angle = 35;
			break;
		}

		// In Legacy of Rust vertical autoaim is completely disabled for Heatwave,
		// presumably to prevent situations where a part of the "wave" is autoaimed
		// and a part isn't (supposedly ugly?)
		// Here instead we calculate the autoaim-affected slope with BulletSlope()
		// and then just unconditinally apply it to all projectiles, so if they
		// do get autoaimed, they'll be autoaimed together:
		double projPitch = BulletSlope();
		for (double ang = -angle; ang <= angle; ang += 5.0)
		{
			// Since autoaim is handled manually, we'll need FPF_NOAUTOAIM:
			A_FireProjectile("JGP_HeatWaveRipper", ang, useammo: false, flags: FPF_NOAUTOAIM, pitch: DeltaAngle(pitch, projPitch));
		}

		invoker.heatwaveCharge = 0;
		A_ClearRefire();
	}

	States {
	Spawn:
		CBLD A -1;
		stop;
	Ready:
		HETG A 1 
		{
			invoker.heatwaveCharge = 0;
			A_WeaponReady();
		}
		loop;
	Deselect:
		HETG A 1 A_Lower;
		loop;
	Select:
		HETG A 1 A_Raise;
		loop;
	Fire:
		HETG A 20
		{
			if (invoker.DepleteAmmo(false))
			{
				invoker.heatwaveCharge++;
				A_GunFlash();
				A_StartSound("DoomRR/heatwave/charge", CHAN_WEAPON);
			}
		}
		TNT1 A 0 
		{
			if (invoker.heatwaveCharge < 5 && invoker.CheckAmmo(PrimaryFire, false))
			{
				A_ReFire();
			}
		}
		HETF A 3 A_FireIncinerator;
		HETF B 5;
		HETG DCB 4;
		TNT1 A 0 A_ReFire;
		goto Ready;

	FlashEnd:
		HETD A 3 bright
		{
			A_OverlayRenderStyle(OverlayID(), STYLE_Add);
			A_Light1;
		}
		HETD B 5 bright A_Light2;
		goto LightDone;
	Flash:
		TNT1 A 0
		{
			A_OverlayRenderStyle(OverlayID(), STYLE_Add);
			return invoker.FindStateByString("FlashCharge"..clamp(invoker.heatwaveCharge, 1,5));
		}
	FlashCharge1:
		HETC A 6 bright;
		HETC BCD 5 bright;
		goto LightDone;
	FlashCharge2:
		HETC E 6 bright;
		HETC FGH 5 bright;
		goto LightDone;
	FlashCharge3:
		HETC I 6 bright;
		HETC JKL 5 bright;
		goto LightDone;
	FlashCharge4:
		HETC M 6 bright;
		HETC NOP 5 bright;
		goto LightDone;
	FlashCharge5:
		HETC Q 6 bright;
		HETC RST 5 bright;
		goto LightDone;
	}
}

class JGP_HeatWaveRipper : Actor
{
	static const color partColors[] =
	{
		"af4300",
		"d75f0b",
		"eb6f0f",
		"ff8f3b"
	};

	Default
	{
		Tag "Heatwave Ripper";
		Projectile;
		Damage DOOMRR_HEATWAVE_RIPPER_DAMAGE;
		Speed DOOMRR_HEATWAVE_RIPPER_VELOCITY;
		Radius 16;
		Height 8;
		+RIPPER
		+BRIGHT
		RenderStyle 'Add';
		Deathsound "DoomRR/heatwave/explode";
	}

	States {
	Spawn:
		TNT1 A 0 NoDelay A_FaceMovementDirection;
		HETB AABBCC 1
		{
			FSpawnParticleParams p;
			p.lifetime = 11;
			p.size = 18;
			p.sizestep = -p.size / p.lifetime;
			p.style = STYLE_Add;
			p.flags = SPF_FULLBRIGHT;
			p.startalpha = alpha;
			p.fadestep = -1;
			p.pos.z = pos.z;
			double hofs = -15;
			double step = (abs(hofs)*2) / 4;
			for (double d = hofs; d <= -hofs; d += step)
			{
				p.color1 = partColors[ random[incin](0, partColors.Size()-1) ];
				Vector2 ofs = Actor.RotateVector((0, d), angle);
				p.pos.xy = level.Vec2Offset(pos.xy, ofs);
				level.SpawnParticle(p);
			}
		}
		loop;
	Death:
		TNT1 A 0
		{
			FSpawnParticleParams p;
			p.lifetime = frandom[incin](25, 35);
			p.size = 18;
			p.sizestep = -p.size / p.lifetime;
			p.style = STYLE_Add;
			p.flags = SPF_FULLBRIGHT;
			p.startalpha = alpha;
			p.fadestep = -1;
			p.pos.z = pos.z;
			double hofs = -15;
			double step = (abs(hofs)*2) / 4;
			for (double d = hofs; d <= -hofs; d += step)
			{
				p.color1 = partColors[ random[incin](0, partColors.Size()-1) ];
				Vector2 ofs = Actor.RotateVector((0, d), angle);
				p.pos.xy = level.Vec2Offset(pos.xy, ofs);
				for (int i = 0; i < 2; i++)
				{
					p.vel = (0, 0, frandom[incin](2.5, 4.5)) * randompick[incin](-1, 1);
					p.accel.z = (-p.vel.z / p.lifetime);
					level.SpawnParticle(p);
				}
			}
		}
		HETB DEFGHI 3;
		stop;
	}
}