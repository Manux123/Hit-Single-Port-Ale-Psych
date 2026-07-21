package modcharting.modifiers.modifiers;

import flixel.FlxG;
import modcharting.modifiers.BaseModifier;

/**
 * Approximates NMV's "reverse": at value 1, mirrors the receptor across the
 * screen's vertical center; at value 0, it sits at its normal base
 * position; in between, it lerps.
 *
 * NMV's real reverse also reshapes each note's individual fall trajectory
 * using a per-note visualDiff/timeDiff, which this ModchartManager doesn't
 * expose (applyMod only gets `beat` and `lane` - it operates on the
 * strum/receptor, not on each note's approach path; see the same caveat in
 * AlphaModifier.hx). So this moves the receptor; whether the falling notes
 * visually flip along with it depends on how your Note computes its own
 * screen position elsewhere.
 *
 * Needs a concrete strumLine (0 or 1) to know its own base Y, so prepare
 * one instance per strumLine rather than one shared instance bound with
 * strumLine: -1.
 */
class ReverseModifier extends BaseModifier {
	public function new() {
		super("Reverse");
	}

	override private function applyMod(result:ModResult, beat:Float, lane:Int):Void {
		if (strumLineIndex < 0)
			return;

		final idx = strumLineIndex * 10 + lane;
		final baseY = manager.strumBaseY[idx];
		if (baseY == null)
			return;

		final mirroredY = FlxG.height - baseY;
		result.y += (mirroredY - baseY) * value;
	}
}
