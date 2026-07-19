var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
var fire:FlxSprite;
var doubleBop:Bool = false;
var black:FlxSprite;

function postCreate() {
	skipCountdown = true;
	camGame.alpha = 0;
	camHUD.alpha = 0;

	// Stage-specific visibility / color modifiers
	dad.color = 0xffa19f9f;
	boyfriend.visible = false;

	gf.flipY = true;
	gf.alpha = 0.5;
	gf.color = 0xFF1B1818;
	gf.x = dad.x;
	gf.y = dad.y + 740;

	dadStrumLine.visible = false;

	healthBar.visible = false;
	iconP1.visible = false;
	iconP2.visible = false;

	fire = new FlxSprite().loadGraphic(Paths.image("stages/joyous/fire"));
	fire.cameras = [camOther];
	fire.scale.set(2.5, 2.5);
	fire.alpha = 0;
	fire.screenCenter();
	fire.y = -1980;
	add(fire);

	black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	black.screenCenter();
	black.visible = false;
	black.cameras = [camOther];
	add(black);
}

function onSafeStepHit(step) {
	switch (step) {
		case 80:
			camGame.alpha = 1;
			camHUD.alpha = 1;
			camHUD.flash(0xFF808080, 1.68);
		case 1668:
			FlxG.camera.flash(0xFFFFFFFF, 1.68);
			black.visible = true;
		case 1696:
			black.visible = false;
			camHUD.flash(0xFFFF0000, 1.68);
			stage.get('thing').visible = false;
			stage.get('thing2').visible = true;
		case 2208:
			camHUD.flash(0xFFE1BA1D, 1.68);
			stage.get('thing2').visible = false;
			stage.get('thing3').visible = true;
			dad.color = 0xFFEFCD5C;
		case 2720:
			camHUD.flash(0xFFFF0000, 1.68);
			stage.get('thing3').visible = false;
			stage.get('thing2').visible = true;
	}
}

function postNoteHit(note, character, timeDistance, removeNote) {
	if (character == dad)
		gf.sing(note.strumLineConfig.sing);
}

function onSafeBeatHit(beat) {
	if (doubleBop) {
		camHUD.zoom += 0.03;
		FlxG.camera.zoom += 0.015;
	}
}

function onEventHit(eventName, value1, value2) {
	switch (eventName) {
		case 'bop':
			if (value1 == "true")
				doubleBop = true;
			else
				doubleBop = false;
		case 'fire':
			FlxTween.tween(fire, {y: 0, alpha: 1}, 12, {
				onComplete: function(sht:FlxTween) {
					camGame.alpha = 0;
					camHUD.alpha = 0;
					FlxTween.tween(fire, {y: 1980, alpha: 0}, 12);
				}
			});
		case 'Change Character':
			if (value1 == "dad") {
				changeCharacter(dad, value2);

				switch (value2) {
					case 'x_3dEVIL':
						dad.color = 0xFFff66ff;
					default:
						dad.color = 0xFFca5d5d;
						// 0xFFd35454 maybe
				}
			} else if (value1 == "gf") {
				changeCharacter(gf, value2);

				switch (value2) {
					case 'x_3d_shadow':
						gf.flipY = true;
						gf.color = 0xFF000000;
						gf.alpha = 0.5;
					case 'x_3dEVIL_shadow':
						gf.flipY = true;
						gf.color = 0xFF000000;
						gf.alpha = 0.325;
				}
			}
	}
}
startTime = Conductor.stepToTime(2700);
