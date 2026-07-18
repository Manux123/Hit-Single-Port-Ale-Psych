import flixel.ui.FlxBar;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxAxes;
import flixel.ui.FlxBarFillDirection;

var bars = null;
var actualBar:FlxBar = null;
var evilBar:FlxBar = null;
var iconP:FlxSprite = null;
var iconOpp:FlxSprite = null;
var lyrics:FlxText;
var playerStrums = null;
static var camHUD2:FXCamera;

function postCreate() {
	playerStrums = strumLines.members[2];
	playerStrums.cameras = [camHUD2];

	icons.visible = false;
}

function postCamerasInit() {
	camHUD2 = cameraFactory();
	FlxG.cameras.add(camHUD2, false);

	var bg = new FlxSprite(0, 0).loadGraphic(Paths.image("huds/sillybilly/bars"));
	bg.antialiasing = ClientPrefs.globalAntialiasing;
	bg.scrollFactor.set(0, 0);
	bg.cameras = [camHUD2];
	add(bg);

	bars = new FlxSprite(0, 0).loadGraphic(Paths.image("huds/sillybilly/Bar/Silly_Healthbar"));
	bars.antialiasing = ClientPrefs.globalAntialiasing;
	bars.scale.set(0.5, 0.5);
	bars.updateHitbox();
	bars.screenCenter();
	bars.x -= 250;
}

function postHudInit() {
	bars.y = (healthBar.y - (bars.height / 2)) - 15;

	actualBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 327.805, 28);
	actualBar.createGradientBar([0xFF000000, 0xFF000000], [0xFF1565C0, 0xFFFFFFFF], 1, 90);
	actualBar.updateBar();
	actualBar.setPosition(420, 622.8);
	if (ClientPrefs.data.downScroll)
		actualBar.y -= 570;
	actualBar.cameras = [camHUD2];
	add(actualBar);

	evilBar = new FlxBar(0, 0, FlxBarFillDirection.RIGHT_TO_LEFT, 330.805, 36);
	evilBar.cameras = [camHUD2];
	evilBar.createGradientBar([0xFF000000, 0xFF000000], [0xFF8A0101, 0xFF000000], 1, 90);
	evilBar.updateBar();
	evilBar.setPosition(405 - evilBar.width - 25, 623.8);
	if (ClientPrefs.data.downScroll)
		evilBar.y -= 570;
	add(evilBar);

	bars.cameras = [camHUD2];
	add(bars);

	iconP = new FlxSprite().loadGraphic(Paths.image("icons/bficon"));
	iconP.loadGraphic(Paths.image("icons/bficon"), true, Math.floor(iconP.width / 2), Math.floor(iconP.height));
	iconP.animation.add('bf', [0, 1], 0, false, true);
	iconP.animation.play('bf');
	iconP.cameras = [camHUD2];
	iconP.setPosition(400, (bars.y + (bars.height / 2) - (iconP.height / 2)));
	iconP.flipX = true;
	iconP.antialiasing = ClientPrefs.globalAntialiasing;
	add(iconP);

	iconOpp = new FlxSprite();
	iconOpp.loadGraphic(Paths.image("icons/evilLookalike"));
	iconOpp.loadGraphic(Paths.image("icons/evilLookalike"), true, Math.floor(iconOpp.width / 5), Math.floor(iconOpp.height));
	iconOpp.animation.add('0', [0], 0, false, false);
	iconOpp.animation.add('1', [1], 0, false, false);
	iconOpp.animation.add('2', [2], 0, false, false);
	iconOpp.animation.add('3', [3], 0, false, false);
	iconOpp.animation.add('4', [4], 0, false, false);
	iconOpp.animation.play('1');
	iconOpp.cameras = [camHUD2];
	iconOpp.setPosition(405 - iconOpp.width, (bars.y + (bars.height / 2) - (iconOpp.height / 2)));
	iconOpp.antialiasing = ClientPrefs.globalAntialiasing;
	add(iconOpp);

	iconOpp.centerOffsets();
	iconP.centerOffsets();

	healthBar.visible = false;

	uiGroup.remove(scoreTxt);
	scoreTxt.cameras = [camHUD2];
	add(scoreTxt);

	lyrics = new FlxText();
	lyrics.setFormat(Paths.font("Times New Roman.otf"), 42, 0xFFcfa92d, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
	lyrics.borderSize = 2;
	lyrics.text = 'IM HORNY!';
	lyrics.cameras = [camHUD2];
	lyrics.y = FlxG.height - lyrics.height;
	lyrics.text = '';
	lyrics.screenCenter(FlxAxes.X);
	add(lyrics);
}

function onUpdate(elapsed) {
	actualBar.percent = healthBar.percent;
	evilBar.percent = 100 - healthBar.percent;

	scoreTxt.x = 220.75 - (scoreTxt.width / 3);

	var percent = (health / 2) * 100;
	if (percent < 20) {
		iconP.animation.curAnim.curFrame = 1;
	} else {
		iconP.animation.curAnim.curFrame = 0;
	}

	lyrics.screenCenter(FlxAxes.X);
}

function onSafeStepHit(step:Int) {
	switch (step) {
		case 1424:
			iconOpp.animation.play('2');
		case 2065:
			iconOpp.animation.play('0');
		case 2832:
			iconOpp.animation.play('3');
		case 3280:
			iconOpp.animation.play('4');
		case 3330:
			FlxTween.tween(bars, {alpha: 0}, 2);
			FlxTween.tween(actualBar, {alpha: 0}, 2);
			FlxTween.tween(evilBar, {alpha: 0}, 2);
			FlxTween.tween(iconP, {alpha: 0}, 2);
			FlxTween.tween(iconOpp, {alpha: 0}, 2);
			FlxTween.tween(scoreTxt, {alpha: 0}, 2);

			FlxTween.tween(playerStrums, {alpha: 0}, 1);
		case 3360:
			FlxTween.tween(playerStrums, {x: playerStrums.x - 300}, 1);
		case 3609:
			changeCharacter(dad, "evilLookalike");
			FlxTween.tween(playerStrums, {alpha: 1}, 1);
		case 3878:
			lyrics.text = '';
		case 3889:
			FlxTween.tween(playerStrums, {x: playerStrums.x + 300}, 1);
			// finish the song
	}
}

function postEventHit(eventName:String, value1:String, value2:String) {
	if (eventName == 'ill make') {
		if (value2 != null && value2 != "") {
			lyrics.text = value2;
		}
	}
}

function onDestroy() {
	if (lyrics != null) {
		lyrics.destroy();
		lyrics = null;
	}
	if (actualBar != null) {
		actualBar.destroy();
		actualBar = null;
	}
	if (evilBar != null) {
		evilBar.destroy();
		evilBar = null;
	}
	if (iconP != null) {
		iconP.destroy();
		iconP = null;
	}
	if (iconOpp != null) {
		iconOpp.destroy();
		iconOpp = null;
	}
	if (bars != null) {
		bars.destroy();
		bars = null;
	}
}
