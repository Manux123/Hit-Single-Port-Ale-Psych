import funkin.visuals.objects.VideoSprite;
import funkin.visuals.shaders.RuntimeShader;

var dadStrums = null;
var timer:Float = 0;
var videoIntro:VideoSprite = null;
var videoMyWay:VideoSprite = null;
var blue = null;

function onCreate() {
	skipCountdown = true;

	blue = new RuntimeShader('blue');
	blue.data.hue.value = [1.3];
	blue.data.pix.value = [0.00001];
}

function postCamerasInit() {
	videoIntro = new VideoSprite(0, 0, Paths.video("open"));
	videoIntro.cameras = [camOther];
	add(videoIntro);

	camGame.alpha = 0;
	camHUD.alpha = 0;

	videoIntro.finishCallback = function() {
		camGame.alpha = 1;
		camGame.zoom = 1.125;
		camHUD.zoom = 1.25;
		FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		camGame.flash(0xFF000000, 0.25);

		if (videoIntro != null) {
			videoIntro.destroy();
			videoIntro = null;
		}
	};
}

function postCreate() {
	dadStrums = strumLines.members[1];

	dadStrums.x += 700;
	dadStrums.y += 420;
	for (index => strum in dadStrums.strums.members)
		strum.x = dadStrums.x + 225 * index;
	dadStrums.scale.set(1, 1);
	dadStrums.alpha = 0.5;

	dadStrums.camera = camGame;

	comboGroup.visible = false;
}

function onMusicPause() {
	if (videoIntro != null)
		videoIntro.pause();

	if (videoMyWay != null)
		videoMyWay.pause();
}

function onResume() {
	if (videoIntro != null)
		videoIntro.play();

	if (videoMyWay != null)
		videoMyWay.play();
}

function onCameraMove(character) {
	if (character == boyfriend)
		defaultCamZoom = 0.5;
	else
		defaultCamZoom = 0.625;
}

function onNoteHit(note:Note, character:Character, rating:Dynamic, timeDistance:Float, removeNote:Bool) {
	if (character != dad)
		return;

	health -= 0.01;
}

function myWAYYY() {
	videoMyWay = new VideoSprite(0, 0, Paths.video("SO_STAY_FINAL"));
	videoMyWay.cameras = [camHUD];
	videoMyWay.screenCenter();
	videoMyWay.x -= 640;
	videoMyWay.y -= 360;
	videoMyWay.antialiasing = true;
	add(videoMyWay);

	videoMyWay.finishCallback = function() {
		for (cam in [camGame, camHUD])
			cam.filters = blue;
		camGame.flash(0xFF000000, 2);
		// lyric.visible = false;
		// dad.visible = true;
		camGame.zoom = 1.1;
		FlxTween.num(0.5, 0, 2, {
			ease: FlxEase.quadOut,
			onUpdate: function(s:FlxTween) {
				changeCharacter(dad, "evilLookalike");
			}
		});

		if (videoMyWay != null) {
			videoMyWay.destroy();
			videoMyWay = null;
		}
	};
}

function onSafeStepHit(step:Int) {
	switch (step) {
		case 1412:
			changeCharacter(dad, "transLookalike");
			dad.playAnim('Smallize', true);
		case 1424:
			changeCharacter(dad, "evilLookalikemini");
		case 2048:
			changeCharacter(dad, "transLookalike2");
			dad.playAnim('Bigize', true);
		case 2065:
			changeCharacter(dad, "evilLookalike");
		case 3367:
			changeCharacter(dad, "lyric");
			dad.playAnim('story_of_yourtalebilly', true);
		case 3494:
			myWAYYY();
		case 4175:
			camGame.alpha = 0;
	}
}

function onDestroy() {
	if (videoIntro != null) {
		videoIntro.destroy();
		videoIntro = null;
	}

	if (videoMyWay != null) {
		videoMyWay.destroy();
		videoMyWay = null;
	}
}
