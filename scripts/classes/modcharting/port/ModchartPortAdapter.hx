package modcharting.port;

import modcharting.ModchartManager;
import modcharting.framework.EaseUtil;
import modcharting.modifiers.modifiers.DrunkModifier;
import modcharting.modifiers.modifiers.TipsyYModifier;
import modcharting.modifiers.modifiers.TransformModifier;
import modcharting.modifiers.modifiers.AlphaModifier;
import modcharting.modifiers.modifiers.ReverseModifier;
import modcharting.modifiers.modifiers.OpponentModifier;

/**
 * Adapter so you can write modchart calls shaped like NMV's ModManager
 * (queueEase / queueSet / setValue, step-based timing, player 0 = bf /
 * 1 = dad / -1 = both) while it dispatches to this engine's real
 * ModchartManager API (beat-based timing, tags, value vs subValue).
 *
 * This only knows the mod names THIS port needed. To port a different NMV
 * modchart, extend `resolve()` with whatever new mod name shows up,
 * following the same shape, and write a BaseModifier subclass for it if
 * one doesn't already exist.
 *
 * ASSUMPTIONS - check these against your project before relying on this:
 *
 *  - step -> beat is step / 4 (the standard Psych/Kade "4 steps per
 *    beat"). If your chart's step numbers came from somewhere with a
 *    different stepsPerBeat, or you already have a step->beat converter in
 *    PsychPorter.hx, use that instead of `beat()` / `dur()` below.
 *
 *  - strumLines.members[0] is the player (bf) and [1] is the opponent
 *    (dad), matching NMV's player 0/1. If your project orders them the
 *    other way, swap the strumLine args passed to prepareMod() in
 *    prepareTags() below.
 */
class ModchartPortAdapter extends scripting.haxe.ScriptedFlxBasic {
	public var manager:ModchartManager;

	public function new(_manager:ModchartManager) {
		super();
		manager = _manager;
		prepareTags();
	}

	function prepareTags():Void {
		// Always -1 (both players) in the ported snippet, so one shared
		// instance is enough for these two.
		manager.prepareMod("drunk", function() {
			return new DrunkModifier();
		}, -1, null);
		manager.prepareMod("tipsy", function() {
			return new TipsyYModifier();
		}, -1, null);

		manager.prepareMod("transform_p0", function() {
			return new TransformModifier();
		}, 0, null);
		manager.prepareMod("transform_p1", function() {
			return new TransformModifier();
		}, 1, null);
		manager.prepareMod("alpha_p0", function() {
			return new AlphaModifier();
		}, 0, null);
		manager.prepareMod("alpha_p1", function() {
			return new AlphaModifier();
		}, 1, null);
		manager.prepareMod("reverse_p0", function() {
			return new ReverseModifier();
		}, 0, null);
		manager.prepareMod("reverse_p1", function() {
			return new ReverseModifier();
		}, 1, null);
		manager.prepareMod("opponentSwap_p0", function() {
			return new OpponentModifier();
		}, 0, null);
		manager.prepareMod("opponentSwap_p1", function() {
			return new OpponentModifier();
		}, 1, null);
	}

	function beat(step:Float):Float {
		return step / 4;
	}

	function dur(step:Float, endStep:Float):Float {
		return (endStep - step) / 4;
	}

	function oneField(key:String, value:Float):Dynamic {
		var o:Dynamic = {};
		Reflect.setField(o, key, value);
		return o;
	}

	/**
	 * Mirrors modManager.setValue(modName, value, player).
	 * Instant, not scheduled - writes straight to the modifier instance,
	 * same as NMV's setValue (which isn't a timeline event either).
	 */
	public function setValue(modName:String, value:Float):Void {
		resolve(modName, -1, function(tag:String, subKey:String) {
			var pm = manager.preparedMods.get(tag);
			if (pm == null)
				return;
			if (subKey == null)
				pm.instance.value = value;
			else
				pm.instance.setSubValue(subKey, value);
			pm.instance.markDirty();
		});
	}

	/** 
	 * Stripped down to 3 arguments for the same reason.
	 */
	public function queueSet(step:Float, modName:String, target:Float):Void {
		resolve(modName, -1, function(tag:String, subKey:String) {
			if (subKey == null)
				manager.setMod(beat(step), oneField(tag, target));
			else
				manager.setModSubValue(tag, beat(step), oneField(subKey, target));
		});
	}

	/**
	 * Kept 'style' as it's commonly passed by NMV, but dropped 'player' to prevent crashes.
	 */
	public function queueEase(step:Float, endStep:Float, modName:String, target:Float, style:String = 'linear'):Void {
		var fn = EaseUtil.get(style);
		resolve(modName, -1, function(tag:String, subKey:String) {
			if (subKey == null)
				manager.easeMod(beat(step), dur(step, endStep), fn, oneField(tag, target));
			else
				manager.easeModSubValue(tag, beat(step), dur(step, endStep), fn, oneField(subKey, target));
		});
	}

	/**
	 * Turns an NMV (modName, player) pair into one or two (tag, subKey)
	 * pairs and hands each to `cb`. subKey null means modName drives a
	 * mod's primary `value`; otherwise it names the subValue to set on
	 * that tag.
	 *
	 * player == -1 fans out to both strumline tags - this is exactly what
	 * NMV's own queueEase/queueSet do internally when player is -1 (they
	 * loop `for (p in 0...lanes)` and recurse per player), so this isn't a
	 * shortcut, it's the same mechanism.
	 */
	function resolve(modName:String, player:Int, cb:(String, String) -> Void):Void {
		switch (modName) {
			case "drunk":
				cb("drunk", null);
			case "tipsy":
				cb("tipsy", null);
			case "tipsySpeed":
				cb("tipsy", "speed");
			case "transform0Y", "transform1Y", "transform2Y", "transform3Y":
				if (player == -1) {
					cb("transform_p0", modName);
					cb("transform_p1", modName);
				} else {
					cb('transform_p$player', modName);
				}
			case "alpha":
				if (player == -1) {
					cb("alpha_p0", null);
					cb("alpha_p1", null);
				} else {
					cb('alpha_p$player', null);
				}
			case "reverse":
				if (player == -1) {
					cb("reverse_p0", null);
					cb("reverse_p1", null);
				} else {
					cb('reverse_p$player', null);
				}
			case "opponentSwap":
				if (player == -1) {
					cb("opponentSwap_p0", null);
					cb("opponentSwap_p1", null);
				} else {
					cb('opponentSwap_p$player', null);
				}
			default:
				trace('ModchartPortAdapter: no detected "$modName" - add this in resolve()');
		}
	}
}
