package modcharting.modifiers.modifiers;

import modcharting.modifiers.BaseModifier;

/**
 * Ported from NMV's OpponentModifier ("opponentSwap"): slides a strumline's
 * columns toward the OTHER strumline's base X position, scaled by value
 * (0 = stay put, 1 = fully on top of the other side).
 *
 * Like NMV's original, this assumes exactly two strumlines (player +
 * opponent) and just picks "the other one" (0 <-> 1). Needs a concrete
 * strumLine (0 or 1) for the same reason as ReverseModifier.
 */
class OpponentModifier extends BaseModifier {
	public function new() {
		super("OpponentSwap");
	}

	override private function applyMod(result:ModResult, beat:Float, lane:Int):Void {
		if (strumLineIndex < 0)
			return;

		final otherLine = strumLineIndex == 0 ? 1 : 0;
		final idx = strumLineIndex * 10 + lane;
		final otherIdx = otherLine * 10 + lane;

		final myX = manager.strumBaseX[idx];
		final otherX = manager.strumBaseX[otherIdx];
		if (myX == null || otherX == null)
			return;

		result.x += (otherX - myX) * value;
	}
}
