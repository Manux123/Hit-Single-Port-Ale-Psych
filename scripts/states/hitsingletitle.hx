import flixel.text.FlxText.FlxTextAlign;
import flixel.effects.FlxFlicker;

var selectedSomething:Bool = false;
var menuBGMain:FlxSprite;
var menuFace:FlxSprite;
var pressEnter:FlxText;
var logo:FlxSprite;

function onCreate() {
	if (Conductor.music == null)
		Conductor.play(Paths.music('freakyMenu'), 102, 4, 4);

	menuBGMain = addTitleSprite('MENUBGMAIN', 0, 0, 0, 1);

	menuBGMain = addTitleSprite('TITLEFACEBACK', 0, 0, 0, 1);
	menuBGMain.screenCenter();

	menuFace = addTitleSprite('face', 0, 0, 0, 1.2);
	menuFace.screenCenter();
	menuFace.x += 40;

	logo = addTitleSprite('title', FlxG.width / 2 - 220 + 30, 0, 0, 0.7);

	pressEnter = new FlxText(0, 560, 0, 'PRESS ENTER TO BEGIN');
	pressEnter.setFormat(Paths.font('MGS2.otf'), 42, 0xFF00FDEC, 'center');
	pressEnter.x = (FlxG.width - pressEnter.width) / 2 + 40;
	add(pressEnter);

	FlxTween.tween(pressEnter, {alpha: 0.1}, 1, {type: FlxTweenType.PINGPONG});
}

function addTitleSprite(name, x, y, scroll, scale) {
	var spr = new FlxSprite(x, y, Paths.image('menus/' + name));
	spr.scrollFactor.set(scroll, scroll);
	spr.scale.set(scale, scale);
	spr.updateHitbox();
	add(spr);

	return spr;
}

function selectMenu() {
	selectedSomething = true;

	CoolUtil.playSound('confirm');

	FlxFlicker.flicker(pressEnter, 1.4, 0.06, false);

	new FlxTimer().start(0.6, function(_) {
		FlxTween.tween(menuBGMain, {alpha: 0}, 0.8);
		FlxTween.tween(menuFace, {alpha: 0}, 0.8);
		FlxTween.tween(logo, {alpha: 0}, 0.8);

		new FlxTimer().start(1, function(_) {
			CoolUtil.switchState(new CustomState(CoolVars.meta.mainMenuState));
		});
	});
}

function onUpdate(elapsed) {
	if (Controls.ACCEPT)
		selectMenu();
}

CoolUtil.createTouchButtons([
    { label: 'A', keys: ClientPrefs.controls.ui.accept }
], FlxG.width - 150, FlxG.height - 170);