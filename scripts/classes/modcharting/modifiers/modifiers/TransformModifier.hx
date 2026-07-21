package modcharting.modifiers.modifiers;

import modcharting.modifiers.BaseModifier;

/**
 * Ported from NMV's TransformModifier: a static per-column offset.
 *
 * In NMV, `transformX` is the parent mod's own `value` (a global X offset
 * for every column), with `transformY` / `transformZ` as submods (global
 * Y/Z), plus per-column overrides `transform{n}X` / `transform{n}Y` /
 * `transform{n}Z`. This keeps that same shape.
 *
 * NMV's additive "-a" variants aren't ported here (not used by the snippet
 * this was written for) - add them the same way: another subValue plus an
 * extra `getSubValue(...)` term in applyMod.
 *
 * Everything meaningful here lives in subValues rather than `value`, so
 * `isActive` is overridden to always be true. That's cheap (this is a plain
 * addition) and it naturally resolves to +0 when nothing has been set.
 */
class TransformModifier extends BaseModifier {
	public function new() {
		super("Transform");
	}

	override private function initDefaults():Void {
		subValues.set("transformY", 0);
		subValues.set("transformZ", 0);

		// Covers up to 9K - widen the range if you ever chart beyond that.
		for (i in 0...9) {
			subValues.set('transform${i}X', 0);
			subValues.set('transform${i}Y', 0);
			subValues.set('transform${i}Z', 0);
		}
	}

	override public function isActive():Bool {
		return true;
	}

	override private function applyMod(result:ModResult, beat:Float, lane:Int):Void {
		result.x += value + getSubValue('transform${lane}X');
		result.y += getSubValue("transformY") + getSubValue('transform${lane}Y');
		result.z += getSubValue("transformZ") + getSubValue('transform${lane}Z');
	}
}
