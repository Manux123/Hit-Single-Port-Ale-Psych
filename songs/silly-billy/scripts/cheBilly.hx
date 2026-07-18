import funkin.visuals.objects.VideoSprite;

var timer:Float = 0;
var videoIntro:VideoSprite = null;
var videoMyWay:VideoSprite = null;
var blue = null;

function onCreate() {
	blue = new funkin.visuals.shaders.FXShader('blue');
	blue.set({hue: 1.3, pix: 0.00001});
}

function postCreate() {
	black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height + 10, FlxColor.BLACK);
	black.cameras = [camHUD];
	black.scrollFactor.set(0, 0);
	add(black);

	camHUD2.visible = false;

	dadStrumLine.x += 700;
	dadStrumLine.y += 420;
	if (ClientPrefs.data.downScroll) {
		dadStrumLine.y -= 490;
		dadStrumLine.downScroll = false;
	}

	for (index => strum in dadStrumLine.strums.members)
		strum.x = dadStrumLine.x + 225 * index;
	dadStrumLine.scale.set(1, 1);
	dadStrumLine.alpha = 0.5;

	dadStrumLine.camera = camGame;

	comboGroup.visible = false;	
}

function onSongStart() {
	videoIntro = new VideoSprite(0, 0, Paths.video("open"));
	videoIntro.cameras = [camOther];
	add(videoIntro);

	camGame.alpha = 0;
	camHUD.alpha = 0;

	videoIntro.finishCallback = function() {
		camGame.alpha = 1;
		camGame.zoom = 1.125;
		camHUD.zoom = 1.25;
		camHUD2.visible = true;
		FlxTween.tween(camHUD2, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		camGame.flash(0xFF000000, 0.25);
		black.alpha = 0;

		if (videoIntro != null) {
			videoIntro.destroy();
			videoIntro = null;
		}
	};
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

	if (health > 0.1)
		health = Math.max(0.1, health - (note.singHealth * 0.5));
}

function myWAYYY() {
	videoMyWay = new VideoSprite(0, 0, Paths.video("SO_STAY_FINAL"));
	videoMyWay.cameras = [camOther];
	videoMyWay.screenCenter();
	videoMyWay.x -= 640;
	videoMyWay.y -= 360;
	videoMyWay.antialiasing = true;
	add(videoMyWay);

	videoMyWay.finishCallback = function() {
		black.alpha = 0;
		camGame.flash(0xFF000000, 2);
		camGame.zoom = 1.1;
		FlxTween.num(0.5, 0, 2, {
			ease: FlxEase.quadOut,
			onUpdate: function(s:FlxTween) {}
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
		case 3357:
			changeCharacter(dad, "lyric");
			dad.playAnim('story_of_yourtalebilly', true);
		case 3487:
			FlxTween.tween(black, {alpha: 1}, 1);
			FlxTween.tween(camGame, {zoom: camGame.zoom + 0.6}, 1);
		case 3494:
			myWAYYY();
		case 3889:
			camGame.setShaders([blue]);
			camHUD.setShaders([blue]);
			camHUD2.setShaders([blue]);
		case 4175:
			camGame.alpha = 0;
			FlxTween.tween(strumLines.members[2], {alpha: 0}, 3);
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
