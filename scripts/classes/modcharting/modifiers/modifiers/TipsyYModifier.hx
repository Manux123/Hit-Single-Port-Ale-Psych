package modcharting.modifiers.modifiers;

import flixel.math.FlxMath;
import modcharting.modifiers.BaseModifier;

/**
 * Ported from NMV's "tipsy" (a submod of their DrunkModifier): a Y-only
 * wobble, independent of the X/Z/angle wobble this engine's existing
 * DrunkModifier already does, and independent of the existing Z-only
 * TipsyZModifer too. Kept as its own modifier (rather than folded into
 * either of those) so "drunk" and "tipsy" can run and be eased on their
 * own timelines, same as in NMV.
 *
 * "speed" here is what NMV called "tipsySpeed".
 */
class TipsyYModifier extends BaseModifier {
	public function new() {
		super("TipsyY");
	}

	override private function initDefaults():Void {
		subValues.set("speed", 1.0);
		subValues.set("offset", 0.0);
	}

	override private function applyMod(result:ModResult, beat:Float, lane:Int):Void {
		final time = Conductor.songPosition * 0.001;
		final speed = getSubValue("speed");
		final offset = getSubValue("offset");

		// 45 stands in for NMV's `Note.swagWidth * 0.4` - swap in the real
		// constant if you want an exact visual match to NMV's scale.
		result.y += value * FlxMath.fastCos(time * ((speed * 1.2) + 1.2) + lane * ((offset * 1.8) + 1.8)) * 45;
	}
}
