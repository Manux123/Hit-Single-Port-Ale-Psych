var f2 = null;
var f1 = null;

function onCreate() {
	f2 = new funkin.visuals.shaders.FXShader('warp');
	f2.set({warp: 1.75});

	f1 = new funkin.visuals.shaders.FXShader('distortion');
	f1.set({
		showVignette: true,
		showDistortion: true,
		showScanlines: true,
		perspective: true,
		glitch: 1.0
	});
}

function postCreate() {
	gf.visible = false;

	camGame.setShaders([f1, f2]);
	camHUD.setShaders([f1, f2]);
}

function onUpdate(elapsed) {
	if (f1 != null) {
		f1.set({iTime: Conductor.songPosition / 1000});
	}
}
