var text:FlxText;

function postCreate() {
	text = new FlxText();
	text.cameras = [camOther];
	text.setFormat(Paths.font("Castellar.ttf"), 36, 0xFFFFFFFF);
	text.screenCenter();
	text.color = 0xFFFFFFFF;
	text.y = healthBar.y - (text.height * 2);
	add(text);
}

function postEventHit(eventName, value1, value2) {
	switch (eventName) {
		case 'lyric':
			text.text = value1;
			text.screenCenter();
			text.y = healthBar.y - (text.height * 2);
	}
}
