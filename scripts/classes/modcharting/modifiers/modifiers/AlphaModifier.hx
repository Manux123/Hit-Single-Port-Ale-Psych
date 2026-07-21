package modcharting.modifiers.modifiers;

import modcharting.modifiers.BaseModifier;

/**
 * Ported from NMV's "alpha" (a submod of their stealth/AlphaModifier
 * system). value 0 = fully opaque, value 1 = fully transparent - same
 * semantics as NMV's alpha submod.
 *
 * Heads up: this engine's ModchartManager only applies ModResult.alpha to
 * the STRUM (receptor) sprite - see ModchartManager.applyModifiers, where
 * `strum.alpha = balp * ralpha`. NMV's "alpha" submod, by contrast, only
 * faded the falling NOTES, never the receptor (updateNote reads it,
 * updateReceptor doesn't). So this ported version fades the receptor, not
 * the note. If you want the note itself to fade, you'll need to read this
 * modifier's value from wherever your Note sets its own alpha - this class
 * doesn't have a hook for that.
 */
class AlphaModifier extends BaseModifier {
	public function new() {
		super("Alpha");
	}

	override private function applyMod(result:ModResult, beat:Float, lane:Int):Void {
		result.alpha *= (1 - value);
	}
}
