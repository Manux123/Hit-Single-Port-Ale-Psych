import flixel.tweens.FlxEase;
import modcharting.ModchartManager;

var modchartManager:ModchartManager;
var toggleVelocity:Bool = false;

function postCreate() {
    modchartManager = new ModchartManager(opponentStrumLines);
    add(modchartManager);

    modchartManager.prepareMod('moveY', () -> new modcharting.modifiers.modifiers.SpeedModifier(), -1, -1);
}

function onBeatHit(curBeat:Int) {
    if (curBeat % 2 == 0) {
        toggleVelocity = !toggleVelocity;
        
        var velocityTarget:Float = toggleVelocity ? 1.0 : 0.5;

        modchartManager.easeMod(curBeat, 2.0, FlxEase.linear, {
            moveY: velocityTarget
        });
    }
}