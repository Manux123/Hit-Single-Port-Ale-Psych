import flixel.util.FlxGradient;
import flixel.FlxState;

var finishCallback:Void->Void;
var transIn:Bool;

function new(trnsIn:Bool, ?callback:Void->Void) {
	transIn = trnsIn;

	finishCallback = callback;
}

function postCreate() {
	FlxState.transitioning = true;
}

function onUpdate(elapsed:Float) {
	close();

	if (transIn)
		finishCallback();
}

function onDestroy()
	FlxState.transitioning = false;
