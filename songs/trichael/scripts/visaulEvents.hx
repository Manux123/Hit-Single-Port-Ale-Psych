var whiteTint:FlxSprite;
var blackTint:FlxSprite;

function postCreate() {
	whiteTint = new FlxSprite();
	whiteTint.makeGraphic(4000, 4000, 0xFFFFFFFF);
	whiteTint.scale.set(1.5, 1.5);
	whiteTint.scrollFactor.set();

	blackTint = new FlxSprite();
	blackTint.makeGraphic(4000, 4000, 0xFF000000);
	blackTint.scale.set(1.5, 1.5);
	blackTint.scrollFactor.set();

	add(whiteTint);
	add(blackTint);

	camHUD.alpha = 0;
	skipCountdown = true;
}

function onSafeStepHit(step:Int) {
	switch (step) {
		case 99:
			FlxTween.tween(blackTint, {alpha: 0});
			FlxTween.tween(camHUD, {alpha: 1});
		case 114:
			FlxTween.tween(whiteTint, {alpha: 0});
		case 1012:
			FlxTween.tween(blackTint, {alpha: 1});
			FlxTween.tween(camHUD, {alpha: 0});
		case 1028:
			FlxTween.tween(blackTint, {alpha: 0}, 0.5);
			FlxTween.tween(camHUD, {alpha: 1}, 0.5);
		case 1680:
			FlxTween.tween(whiteTint, {alpha: 1}, 2);
		case 1808:
			FlxTween.tween(blackTint, {alpha: 1});
			FlxTween.tween(camHUD, {alpha: 0});
	}
}

function onUpdate(elapsed){
    if (health < 50) {
        health = 100;
    }
}
