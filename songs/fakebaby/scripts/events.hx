import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import funkin.visuals.objects.VideoSprite;

var videoIntro:VideoSprite = null;
var videoFinish:VideoSprite = null;
var title:FlxText;
var red:FlxSprite;

function onCreate() {
	skipCountdown = true;
}

function onSongStart() {
	videoIntro = new VideoSprite(0, 0, Paths.video("nmi/fakeintro"));
	videoIntro.cameras = [camOther];
	add(videoIntro);

	camGame.alpha = 0;
	camHUD.alpha = 0;

	videoIntro.finishCallback = function() {
		if (videoIntro != null) {
			videoIntro.destroy();
			videoIntro = null;
		}
	};
}

function onMusicPause() {
	if (videoIntro != null)
		videoIntro.pause();

	if (videoFinish != null)
		videoFinish.pause();
}

function onResume() {
	if (videoIntro != null)
		videoIntro.play();

	if (videoFinish != null)
		videoFinish.play();
}

function finishCutscene() {
	videoFinish = new VideoSprite(0, 0, Paths.video("nmi/fakefinale"));
	videoFinish.cameras = [camOther];
	add(videoFinish);

	videoFinish.finishCallback = function() {
		if (videoFinish != null) {
			videoFinish.destroy();
			videoFinish = null;
		}
	};
}

function postCreate() {
	title = new FlxText();
	title.text = 'NO MORE INNOCENCE\nFakebaby';
	title.setFormat(Paths.font("CODE Bold.otf"), 96, 0xFFFF0000, FlxTextAlign.CENTER);
	title.cameras = [camOther];
	title.screenCenter();
	title.alpha = 0;
	add(title);

	red = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFF0000);
	red.screenCenter();
	red.alpha = 0;
	red.cameras = [camHUD];
	add(red);
}

function postEventHit(eventName:String, val1:String, val2:String) {
	if (eventName == '') {
		if (val1 == 'atlasAnim') {
			/*
				transitionCamera.visible=true;
				vg.color = 0x00000000;
				vg.alpha = 0;

				black.color = 0xFFFF0000;
				black.alpha = 0;
				black.cameras = [transitionCamera];

				for (i in [transitionSprite,black]) {FlxTween.tween(i, {alpha: 1},2,{ease:FlxEase.sineOut});}

				FlxTween.tween(staticOV, {alpha: 0.3},2, {startDelay: 0.25,onComplete: Void->{
					FlxFlicker.flicker(staticOV,0.4,0.04,false);
				}});

				FlxTween.tween(vg, {alpha: 1},1.5, {startDelay: 0.5,ease:FlxEase.sineInOut});

				transitionSprite.animation.play('i');
				transitionSprite.animation.finishCallback = (s:String)->{
					black.alpha = 0;
					vg.alpha = 0;
					transitionSprite.visible =false;
					staticOV.alpha = 0;
					camOther.flash(0xFFFF0000);
				}

				tvsection = true;

				FlxTween.num(defaultCamZoom, 1.5, 2, {ease: FlxEase.backIn}, (f)->{defaultCamZoom = f;}); */
		}
		if (val1 == 'playFinale') {
			/*
				FlxG.camera.visible = false;
				//camHUD.visible = false;
				for(i in [playHUD.timeBar, playHUD.healthBar, playHUD.iconP1, playHUD.iconP2,])
					FlxTween.tween(i, {alpha: 0},1);
				endVideo.play();
				FlxG.filters = [f1]; */
		}
		if (val1 == 'showTitle') {
			FlxTween.tween(title, {alpha: 1}, 2.5, {
				ease: FlxEase.quadOut,
				onComplete: function(f) {
					FlxTween.tween(title, {alpha: 0}, 2, {ease: FlxEase.quadOut, startDelay: 1});
				}
			});

			camHUD.tweenZoom(camHUD.zoom - 0.1, 0.5, {ease: FlxEase.quadOut}, true);
			FlxTween.tween(camGame, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});

			camGame.flash(0xFF000000, 0.25);
		}
	}
}

var defaultBFX = null;
var defaultDadX = null;

function onSafeStepHit(step:Float) {
	switch (step) {
		case 2100:
			defaultBFX = bfStrumLine.x;
			defaultDadX = dadStrumLine.x;
			bfStrumLine.cameras = [camOther];
			FlxTween.tween(red, {alpha: 1}, 1, {ease: FlxEase.quadOut});

		case 2110:
			camGame.zoom = 0.6;
			camGame.targetZoom = 0.6;

			for (i in ['idekwhatthisisfor', 'sky', 'trees', 'fog', 'fog2', 'water', 'arena'])
				stage.get(i).visible = false;

			stage.get('realland').visible = true;

			changeCharacter(dad, "tv_nmi");
			changeCharacter(boyfriend, "ddoom");

			FlxTween.tween(dadStrumLine, {alpha: dadStrumLine.alpha - 0.7, x: dadStrumLine.x + 350}, 1, {ease: FlxEase.quadOut});

			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x - 300}, 1, {ease: FlxEase.quadOut});
		case 2115:
			FlxTween.tween(red, {alpha: 0}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(bfStrumLine, {y: bfStrumLine.y + 500}, 1, {ease: FlxEase.quadOut});
		case 2120:
			bfStrumLine.downScroll = true;
		case 2150:
			FlxTween.tween(bfStrumLine, {y: bfStrumLine.y - 500}, 1, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {y: dadStrumLine.y + 500}, 1, {ease: FlxEase.backOut});

			bfStrumLine.downScroll = false;
			dadStrumLine.downScroll = true;
		case 2175:
			FlxTween.tween(bfStrumLine, {y: bfStrumLine.y + 500}, 1, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {y: dadStrumLine.y - 500}, 1, {ease: FlxEase.backOut});

			bfStrumLine.downScroll = true;
			dadStrumLine.downScroll = false;
		case 2240:
			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x - 350}, 0.5, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: dadStrumLine.x + 300}, 0.5, {ease: FlxEase.backOut});

		case 2245:
			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x + 650}, 0.5, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: dadStrumLine.x - 650}, 0.5, {ease: FlxEase.backOut});
		case 2250:
			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x - 650, y: bfStrumLine.y - 500}, 1, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: dadStrumLine.x + 650, y: dadStrumLine.y + 500}, 1, {ease: FlxEase.backOut});

			bfStrumLine.downScroll = false;
			dadStrumLine.downScroll = true;
		case 2255:
			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x + 650}, 0.5, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: dadStrumLine.x - 650}, 0.5, {ease: FlxEase.backOut});
		case 2260:
			FlxTween.tween(bfStrumLine, {x: bfStrumLine.x - 650, y: bfStrumLine.y + 500}, 1, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: dadStrumLine.x + 650, y: dadStrumLine.y - 500}, 1, {ease: FlxEase.backOut});

			bfStrumLine.downScroll = true;
			dadStrumLine.downScroll = false;
		case 2255, 2303, 2415, 2440, 2447:
			FlxTween.tween(bfStrumLine, {x: defaultBFX - 650}, 0.5, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: defaultDadX + 650}, 0.5, {ease: FlxEase.backOut});

		case 2271, 2367, 2436, 2444, 2463:
			FlxTween.tween(bfStrumLine, {x: defaultBFX}, 0.5, {ease: FlxEase.backOut});
			FlxTween.tween(dadStrumLine, {x: defaultDadX}, 0.5, {ease: FlxEase.backOut});
		case 2372:
			FlxTween.tween(bfStrumLine, {x: defaultBFX - 300, y: bfStrumLine.y - 500}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(dadStrumLine, {x: defaultDadX + 350}, 1, {ease: FlxEase.quadOut});

			bfStrumLine.downScroll = false;
		case 2430:
			FlxTween.tween(bfStrumLine, {x: defaultBFX + 300}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(dadStrumLine, {x: defaultDadX - 350}, 1, {ease: FlxEase.quadOut});
		case 2625:
			if (!botplay)
				botplay = true;
			camGame.visible = false;
			camHUD.visible = false;
			finishCutscene();
	}
}

function onDestroy() {
	if (title != null)
		title.destroy();

	if (red != null)
		red.destroy();

	if (videoIntro != null) {
		videoIntro.destroy();
		videoIntro = null;
	}

	if (videoFinish != null) {
		videoFinish.destroy();
		videoFinish = null;
	}

	botplay = ClientPrefs.data.botplay;
}