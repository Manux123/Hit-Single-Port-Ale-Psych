import flixel.group.FlxTypedSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.effects.FlxFlicker;

var menuBGMain:FlxSprite;
var shape:FlxSprite;
var MENUBGGRID:FlxSprite;
var MENUBGTEXT:FlxSprite;
var menuGroup:FlxTypedSpriteGroup<FlxSprite>;
var selectedSomething:Bool = false;
var options:Array<String> = ['MENUSTORY', 'MENUFREEPLAY', 'MENUCREDITS', 'MENUOPTIONS'];

function onCreate() {
	if (Conductor.music == null)
		Conductor.play(Paths.music('freakyMenu'), 102, 4, 4);

	menuBGMain = addTitleSprite('MENUBGMAIN', 0, 0, 0, 1);

	shape = addTitleSprite('MENUBGSHAPES', 0, 0, 0, 1);
	shape.alpha = 0;

	FlxTween.tween(shape, {alpha: 0.1}, 1);

	MENUBGGRID = new FlxBackdrop(Paths.image('menus/MENUBGGRID'), FlxAxes.Y);
	MENUBGGRID.x += FlxG.width - 300;
	add(MENUBGGRID);

	MENUBGGRID.alpha = 0;

	FlxTween.tween(MENUBGGRID, {alpha: 1}, 0.4);

	MENUBGTEXT = new FlxBackdrop(Paths.image('menus/MENUBGTEXT'), FlxAxes.X);
	MENUBGTEXT.screenCenter();
	add(MENUBGTEXT);

	MENUBGTEXT.alpha = 0;

	FlxTween.tween(MENUBGTEXT, {alpha: 1}, 0.4);

	menuGroup = new FlxTypedSpriteGroup<FlxSprite>();
	add(menuGroup);

	for (i in 0...options.length) {
		var option = new FlxSprite(0, 100 + (i * 70), Paths.image('menus/options/' + options[i]));
		option.ID = i;
		option.scale.set(1.5, 1.5);
		option.updateHitbox();
		option.x = (FlxG.width - option.width) / 2;
		option.scrollFactor.set(0, 0);
		option.visible = false;

		new FlxTimer().start(0.4, function(_) {
			FlxFlicker.flicker(option, 0.4, 0.06, true);
		});

		menuGroup.add(option);
	}

	changeSelection(0);
}

function addTitleSprite(name, x, y, scroll, scale) {
	var spr = new FlxSprite(x, y, Paths.image('menus/' + name));
	spr.scrollFactor.set(scroll, scroll);
	spr.scale.set(scale, scale);
	spr.updateHitbox();
	add(spr);

	return spr;
}

var curSelected:Int = 0;

function changeSelection(change) {
	curSelected = FlxMath.wrap(curSelected + change, 0, menuGroup.members.length - 1);

	for (index => opt in menuGroup.members) {
		FlxTween.cancelTweensOf(opt.scale);
		FlxTween.tween(opt.scale, {x: index == curSelected ? 1.05 : 1, y: index == curSelected ? 1.05 : 1}, 0.25, {ease: FlxEase.cubeOut});
	}
}

function selectMenu() {
	selectedSomething = true;

	CoolUtil.playSound('confirm');

	switch (options[curSelected]) {
		case 'MENUSTORY':
			CoolUtil.switchState(new PlayState('freeplay', ['silly-billy'], 'normal'));
		case 'MENUFREEPLAY':
			CoolUtil.switchState(new CustomState(CoolVars.meta.freeplayState));
		case 'MENUCREDITS':
			CoolUtil.switchState(new CustomState(CoolVars.meta.creditsState));
		case 'MENUOPTIONS':
			CoolUtil.switchState(new CustomState(CoolVars.meta.optionsState));
	}
}

function onUpdate(elapsed) {
	if (selectedSomething)
		return;

	if (Controls.UI_UP_P || Controls.UI_DOWN_P) {
		changeSelection(Controls.UI_DOWN_P ? 1 : -1);

		CoolUtil.playSound('scroll');
	}

	MENUBGGRID.y -= 50 * elapsed;

	if (MENUBGGRID.y > FlxG.height) {
		MENUBGGRID.y = 0;
	}

	MENUBGTEXT.x -= 180 * elapsed;

	if (MENUBGTEXT.x > FlxG.width) {
		MENUBGTEXT.x = 0;
	}

	if (Controls.ACCEPT)
		selectMenu();

	if (Controls.BACK)
		CoolUtil.switchState(new CustomState(CoolVars.meta.titleState));
}

CoolUtil.createTouchButtons([
    { label: 'D', keys: ClientPrefs.controls.ui.down },
    { label: 'U', keys: ClientPrefs.controls.ui.up }
], 150, FlxG.height - 170, 90);

CoolUtil.createTouchButtons([
    { label: 'A', keys: ClientPrefs.controls.ui.accept },
    { label: 'B', keys: ClientPrefs.controls.ui.back }
], FlxG.width - 200, FlxG.height - 170);