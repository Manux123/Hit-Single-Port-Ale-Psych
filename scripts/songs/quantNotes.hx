import funkin.visuals.shaders.RGBShader;

var quantSteps:Array<Int> = [1, 2, 3, 4, 6, 8, 12, 16, 24, 48];

var quantColors:Array<Array<Int>> = [
	[0xFFE51919, 0xFFFFFFFF, 0xFF5B0A30],
	[0xFF193BE5, 0xFFFFFFFF, 0xFF0A3B5B],
	[0xFFA119E5, 0xFFFFFFFF, 0xFF1D0A5B],
	[0xFF26D93E, 0xFFFFFFFF, 0xFF24560F],
	[0xFFA119E5, 0xFFFFFFFF, 0xFF1D0A5B],
	[0xFFE5C319, 0xFFFFFFFF, 0xFF5B2A0A],
	[0xFFA119E5, 0xFFFFFFFF, 0xFF1D0A5B],
	[0xFF13ECA4, 0xFFFFFFFF, 0xFF085D18],
	[0xFF3A3A6C, 0xFFFFFFFF, 0xFF17202B],
	[0xFF3A3A6C, 0xFFFFFFFF, 0xFF17202B]
];

function getQuant(time:Float):Int {
	var beat:Float = time / Conductor.crochet;
	var row:Int = Math.round(beat * 48);

	for (n in quantSteps)
		if (row % Std.int(48 / n) == 0)
			return n;

	return quantSteps[quantSteps.length - 1];
}

function getQuantColor(time:Float):Array<Int>
	return quantColors[quantSteps.indexOf(getQuant(time))];

function getHeadNote(note:Note):Note {
	while (note.type != 'arrow' && note.parent != null)
		note = note.parent;

	return note;
}

function onNoteSpawn(note:Note) {
	var col = getQuantColor(getHeadNote(note).time);
	note.shader = new RGBShader(col[0], col[1], col[2]);
}

function onNoteHit(note:Note, character:Character, rating:Dynamic, timeDistance:Float, removeNote:Bool) {
	var shader = note._castShader;

	note.strum._castShader.r = shader.r;
	note.strum._castShader.g = shader.g;
	note.strum._castShader.b = shader.b;

	if (note.type == 'arrow' && note.splash != null) {
		note.splash._castShader.r = shader.r;
		note.splash._castShader.g = shader.g;
		note.splash._castShader.b = shader.b;
	}
}