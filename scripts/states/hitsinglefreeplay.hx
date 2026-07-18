import flixel.group.FlxTypedSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

var menuBGMain:FlxSprite;
var shape:FlxSprite;
var MENUBGGRID:FlxSprite;
var MENUBGTEXT:FlxSprite;
var menuGroup:FlxTypedSpriteGroup<FlxText>;
var selectedSomething:Bool = false;
var options:Array<String> = ['trichael', 'joyous', 'fakebaby', 'silly-billy'];
var score:FlxText;
var rating:FlxText;

function onCreate() {
	if (Conductor.music == null)
		Conductor.play(Paths.music('freakyMenu'), 102, 4, 4);

	CoolVars.meta.transition = 'FadeTransition';
	menuBGMain = addTitleSprite('MENUBGMAIN', 0, 0, 0, 1);

	shape = addTitleSprite('MENUBGSHAPES', 0, 0, 0, 1);
	shape.alpha = 0.1;

	MENUBGGRID = new FlxBackdrop(Paths.image('menus/MENUBGGRID'), FlxAxes.Y);
	MENUBGGRID.x += FlxG.width - 300;
	add(MENUBGGRID);

	MENUBGTEXT = new FlxBackdrop(Paths.image('menus/MENUBGTEXT'), FlxAxes.X);
	MENUBGTEXT.screenCenter();
	add(MENUBGTEXT);

	menuGroup = new FlxTypedSpriteGroup<FlxText>();
	add(menuGroup);

	for (i in 0...options.length) {
		var text = new FlxText(160, 380 + i * 65, 0, options[i].toUpperCase() + ' ');
		text.setFormat(Paths.font('MGS2.otf'), 42, 0xFF00FDEC, 'center');
		menuGroup.add(text);
	}

	var freelplay = new FlxText(FlxG.width * 0.67, 50, 0, 'FREELPAY');
	freelplay.setFormat(Paths.font('MGS2.otf'), 52, 0xFF00FDEC, 'center');
	add(freelplay);

	score = new FlxText(FlxG.width * 0.7, FlxG.height * 0.78, 0, 'SCORE: 0');
	score.setFormat(Paths.font('MGS2.otf'), 54, 0xFF00FDEC, 'center');
	score.alpha = 0.9;
	add(score);

	rating = new FlxText(FlxG.width * 0.7, FlxG.height * 0.86, 0, 'RATING: 0');
	rating.setFormat(Paths.font('MGS2.otf'), 54, 0xFF00FDEC, 'center');
	rating.alpha = 0.9;
	add(rating);

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
		var isSelected = (index == curSelected);
		opt.alpha = isSelected ? 1 : 0.25;
	}
}

function selectMenu() {
	selectedSomething = true;

	CoolUtil.playSound('confirm');

	new FlxTimer().start(0.6, function(_) {
		CoolUtil.switchState(new PlayState('freeplay', [options[curSelected]], 'normal'));
	});
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

	if (Controls.BACK) {
		CoolVars.meta.transition = 'NullTransition';

		CoolUtil.switchState(new CustomState(CoolVars.meta.mainMenuState));
	}
}
