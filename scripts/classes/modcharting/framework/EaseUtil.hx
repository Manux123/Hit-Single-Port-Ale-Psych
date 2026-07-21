package modcharting.framework;

import flixel.tweens.FlxEase;

/**
 * Resolves an ease function by name, the same way NMV's
 * CoolUtil.getEaseFromString did - so ported modchart calls can keep using
 * string style names ('sineInOut', 'quadInOut', ...) instead of needing a
 * direct FlxEase function reference at every call site.
 */
class EaseUtil {
	public static function get(name:String):Float->Float {
		return switch (name) {
			case "linear": FlxEase.linear;
			case "quadIn": FlxEase.quadIn;
			case "quadOut": FlxEase.quadOut;
			case "quadInOut": FlxEase.quadInOut;
			case "cubeIn": FlxEase.cubeIn;
			case "cubeOut": FlxEase.cubeOut;
			case "cubeInOut": FlxEase.cubeInOut;
			case "quartIn": FlxEase.quartIn;
			case "quartOut": FlxEase.quartOut;
			case "quartInOut": FlxEase.quartInOut;
			case "quintIn": FlxEase.quintIn;
			case "quintOut": FlxEase.quintOut;
			case "quintInOut": FlxEase.quintInOut;
			case "sineIn": FlxEase.sineIn;
			case "sineOut": FlxEase.sineOut;
			case "sineInOut": FlxEase.sineInOut;
			case "expoIn": FlxEase.expoIn;
			case "expoOut": FlxEase.expoOut;
			case "expoInOut": FlxEase.expoInOut;
			case "circIn": FlxEase.circIn;
			case "circOut": FlxEase.circOut;
			case "circInOut": FlxEase.circInOut;
			case "backIn": FlxEase.backIn;
			case "backOut": FlxEase.backOut;
			case "backInOut": FlxEase.backInOut;
			case "elasticIn": FlxEase.elasticIn;
			case "elasticOut": FlxEase.elasticOut;
			case "elasticInOut": FlxEase.elasticInOut;
			case "bounceIn": FlxEase.bounceIn;
			case "bounceOut": FlxEase.bounceOut;
			case "bounceInOut": FlxEase.bounceInOut;
			default:
				trace('EaseUtil: ease desconocido "$name", usando linear');
				FlxEase.linear;
		}
	}
}
