var floor:FlxSprite;
var idk1:FlxSprite;
var idk2:FlxSprite;
var brokenMirror = null;
var mirror = null;

function postCreate() {
	gf.visible = false;

	brokenMirror = stage.get('brokenMirror');
	mirror = stage.get('mirror');

	floor = new FlxSprite(0, 0);
	floor.frames = Paths.getSparrowAtlas("stages/yourself/bgAssets");
	floor.animation.addByPrefix("Silly_floor", "Silly_floor", 24, true);
	floor.animation.play("Silly_floor");
	floor.antialiasing = ClientPrefs.globalAntialiasing;
	add(floor);

	idk1 = new FlxSprite(0, 0);
	idk1.frames = Paths.getSparrowAtlas("stages/yourself/bgAssets");
	idk1.animation.addByPrefix("Silly_idk_1", "Silly_idk_1", 24, true);
	idk1.animation.play("Silly_idk_1");
	idk1.antialiasing = ClientPrefs.globalAntialiasing;
	add(idk1);

	idk2 = new FlxSprite(0, 0);
	idk2.frames = Paths.getSparrowAtlas("stages/yourself/bgAssets");
	idk2.animation.addByPrefix("Silly_idk_2", "Silly_idk_2", 24, true);
	idk2.animation.play("Silly_idk_2");
	idk2.antialiasing = ClientPrefs.globalAntialiasing;
	add(idk2);

	remove(opponentCharacters);
	add(opponentCharacters);

	remove(playerCharacters);
	add(playerCharacters);
}

function onDestroy() {
	floor.destroy();
	idk1.destroy();
	idk2.destroy();
}

function onSafeStepHit(step:Int) {
	switch (step) {
		case 3440:
			mirror.visible = false;
			brokenMirror.visible = true;
			FlxTween.num(255, 0, 1.75, {
				ease: FlxEase.quadOut,
				onUpdate: function(twn) {
					brokenMirror.colorTransform.redOffset = twn.value;
					brokenMirror.colorTransform.greenOffset = twn.value;
					brokenMirror.colorTransform.blueOffset = twn.value;
					brokenMirror.dirty = true;
				}
			});
			camGame.shake(0.01, 0.25);
			FlxG.sound.play(Paths.sound("gameplay/mirror_break"));
	}
}
