package classes.Scenes.Places.Boat 
{
	import classes.*;
	import classes.internals.*;
	import classes.GlobalFlags.*;

	public class Marae extends Monster
	{
		
		//Corrupted Marae's specials
		public function tentacleAttack():void {
			
			outputText("You spot barrage of tentacles coming your way! You attempt to dodge your way out ", false);
			if (combatEvade() || combatFlexibility() || combatMisdirect())
			{
				outputText("and you successfully dodge her tentacles thanks to your superior evasion!", false);
			}
			else if (combatMiss())
			{
				outputText("and you successfully dodge her tentacles!", false);
			}
			else
			{
				outputText("but you fail and get hit instead! The feel of the tentacles left your groin slightly warmer. ", false);
				var damage:int = ((str + 100) + rand(50))
				game.dynStats("lust", rand(5) + 5);
				damage = player.reduceDamage(damage);
				player.takeDamage(damage, true);
			}
			combatRoundOver();
		}
		
		public function tentacleRape():void {
			
			outputText("You spot barrage of tentacles coming your way! The tentacles are coming your way, aiming for your groin! ", false);
			if (combatEvade() || combatFlexibility() || combatMisdirect())
			{
				outputText("You manage to avoid her tentacles thanks to your superior evasion!", false);
			}
			else if (combatMiss())
			{
				outputText("You manage to successfully run from her tentacles! ", false);
			}
			else
			{
				outputText("You attempt to slap away the tentacles but it's too late! The tentacles tickle your groin and you can feel your [ass] being teased! \"<i>You know you want me!</i>\" Marae giggles. ", false);
				var lustDmg:int = (20 + rand(player.cor / 10) + rand(player.sens / 5) + rand(player.lib / 10) + rand(10)) * (game.lustPercent() / 100);
				game.dynStats("lust", lustDmg, "resisted", false);
				outputText("(+" + lustDmg + " lust)");
				
			}
			combatRoundOver();
		}
		
		//Pure Marae's specials
		public function smite():void {
			outputText("Marae mouths a chant. The clouds gather and quickly darkens. <b>It looks like a lightning might strike you!</b>");
			createStatusAffect(StatusAffects.Uber, 1, 0, 0, 0);
			combatRoundOver();
		}
		public function smiteHit():void {
			if (game.flags[kFLAGS.IN_COMBAT_USE_PLAYER_WAITED_FLAG] == 1) {
				outputText("You look up in the sky to see the lightning incoming! Thanks to your preparedness, you manage to leap away before the lightning hits you! ");
			}
			else {
				outputText("Without warning, the lightning hits you! Surge of electricity rushes through you painfully. ");
				if (player.cor >= 50) outputText("The intensity of the pain is unbearable. ");
				var damage:int = 100 + str + (player.cor * 5);
				damage = player.reduceDamage(damage);
				player.takeDamage(damage, true);
			}
			if (findStatusAffect(StatusAffects.Uber) >= 0) removeStatusAffect(StatusAffects.Uber);
			combatRoundOver();
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			game.boat.marae.winAgainstMarae();
		}
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void
		{
			game.boat.marae.loseAgainstMarae();
		}
		
		override public function doAI():void {
			if (findStatusAffect(StatusAffects.Stunned) >= 0) {
				outputText("Your foe is too dazed from your last hit to strike back!", false)
				if (findStatusAffect(StatusAffects.Uber) >= 0) {
					outputText(" You've managed to interrupt her smite attack!");
					removeStatusAffect(StatusAffects.Uber);
				}
				if (statusAffectv1(StatusAffects.Stunned) <= 0) removeStatusAffect(StatusAffects.Stunned);
				else addStatusValue(StatusAffects.Stunned, 1, -1);
				combatRoundOver();
				return;
			}
			if (findStatusAffect(StatusAffects.Fear) >= 0) {
				game.outputText("\"<i>You think I'm afraid of anything? Foolish mortal.</i>\" Marae snarls.\n\n");
				removeStatusAffect(StatusAffects.Fear);
			}
			var chooser:int = rand(10);
			if (findStatusAffect(StatusAffects.Uber) >= 0) {
				smiteHit();
				return;
			}
			if (chooser < 4) {
				eAttack();
				return
			}
			else if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 1) {
				if (chooser >= 4 && chooser < 7) eAttack();
				if (chooser >= 7 && chooser < 10) smite();
			}
			else if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 2) {
				if (chooser >= 4 && chooser < 7) tentacleAttack();
				if (chooser >= 7 && chooser < 10) tentacleRape();
			}
		}
		
		public function Marae() 
		{
			this.a = "";
			this.short = "Marae";
			this.imageName = "marae";
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 2) {
				this.long = "This being is known as the goddess of Mareth. She is corrupted due to the aftermath of the factory valves being blown up. She's white all over and textured with bark. The \"flower\" below her belly button resembles more of a vagina than a flower. Her G-cup sized breasts jiggle with every motion."
				this.createVagina(false, VAGINA_WETNESS_DROOLING, VAGINA_LOOSENESS_NORMAL);
				createBreastRow(Appearance.breastCupInverse("G"));
			}
			else {
				this.long = "This being is known as the goddess of Mareth. She is no longer corrupted thanks to your actions at the factory. She's white all over and textured with bark. Her breasts are modestly sized."
				this.createVagina(false, VAGINA_WETNESS_WET, VAGINA_LOOSENESS_NORMAL);
				createBreastRow(Appearance.breastCupInverse("DD"));
			}
			this.ass.analLooseness = 1;
			this.ass.analWetness = 1;
			this.tallness = 10*12;
			this.hipRating = 10;
			this.buttRating = 8;
			this.skinTone = "white";
			this.skinType = 0;
			//this.skinDesc = Appearance.Appearance.DEFAULT_SKIN_DESCS[SKIN_TYPE_FUR];
			this.hairColor = "green";
			this.hairLength = 36;
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 2) {
				initStrTouSpeInte(150, 150, 70, 110);
				initLibSensCor(60, 25, 100);
				this.weaponName = "tentacles";
				this.weaponVerb="slap";
				this.weaponAttack = 40;
			}
			else {
				initStrTouSpeInte(200, 150, 100, 150);
				initLibSensCor(25, 25, 0);
				this.weaponName = "fists";
				this.weaponVerb="wrathful punch";
				this.weaponAttack = 50;
			}
			this.weaponPerk = "";
			this.weaponValue = 25;
			this.armorName = "bark";
			this.armorDef = 30;
			this.bonusHP = 4750;
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 1) {
				this.bonusHP += 2700;
				if (game.flags[kFLAGS.MINERVA_TOWER_TREE] > 0) this.bonusHP += 1000;
			}
			this.lust = 30;
			this.lustVuln = .04;
			this.temperment = TEMPERMENT_RANDOM_GRAPPLES;
			this.level = 99;
			this.additionalXP = 2500;
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 1) {
				this.additionalXP += 500;
			}
			this.drop = NO_DROP;
			this.gems = 1000;
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 1) {
				this.special1 = smite;
			}
			if (game.flags[kFLAGS.FACTORY_SHUTDOWN] == 2) {
				this.special1 = tentacleAttack;
				this.special2 = tentacleRape;
			}
			this.createPerk(PerkLib.Tank, 0, 0, 0, 0);
			this.createPerk(PerkLib.Tank2, 0, 0, 0, 0);
			checkMonster();
		}
		
	}

}
