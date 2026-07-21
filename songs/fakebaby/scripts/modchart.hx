/*import modcharting.port.ModchartPortAdapter;
import modcharting.ModchartManager;

var modchartManager:ModchartManager;

function postCreate() {
	modchartManager = new ModchartManager(strumLines);
	add(modchartManager);

	var m = new ModchartPortAdapter(modchartManager);

	m.setValue("transform0Y", -200);
	m.setValue("transform1Y", -200);
	m.setValue("transform2Y", -200);
	m.setValue("transform3Y", -200);
	m.setValue("tipsy", 0.3);

	m.queueEase(0, 10, "transform0Y", 0, 'sineInOut', 1);
	m.queueEase(32, 42, "transform1Y", 0, 'sineInOut', 1);
	m.queueEase(64, 74, "transform2Y", 0, 'sineInOut', 1);
	m.queueEase(95, 105, "transform3Y", 0, 'sineInOut', 1);

	m.queueEase(127, 137, "transform0Y", 0, 'sineInOut', 0);
	m.queueEase(160, 170, "transform1Y", 0, 'sineInOut', 0);
	m.queueEase(191, 201, "transform2Y", 0, 'sineInOut', 0);
	m.queueEase(223, 233, "transform3Y", 0, 'sineInOut', 0);

	m.queueEase(256, 320, "tipsy", 0, 'sineInOut');

	m.queueEase(2079, 2090, "alpha", 1, 'quadInOut', 1);
	m.queueEase(2111, 2114, "alpha", 0.5, 'quadInOut', 1);

	m.queueEase(2090, 2100, "opponentSwap", 0.5, 'quadInOut', 0);
	m.queueEase(2111, 2114, "opponentSwap", 0.5, 'quadInOut', 1);

	m.queueEase(2111, 2121, "reverse", 1, 'quadInOut', 0);

	m.queueEase(2143, 2159, "reverse", 0, 'quadInOut', 0);
	m.queueEase(2143, 2159, "reverse", 1, 'quadInOut', 1);

	m.queueEase(2175, 2191, "reverse", 1, 'quadInOut', 0);
	m.queueEase(2175, 2191, "reverse", 0, 'quadInOut', 1);

	m.queueSet(2112, "tipsySpeed", 4);

	m.queueEase(2112, 2127, "drunk", 0.4, 'expoInOut');
	m.queueEase(2112, 2135, "tipsy", 0.6, 'expoInOut');

	m.queueEase(2621, 2639, "drunk", 0, 'quadInOut');
	m.queueSet(2639, "tipsySpeed", 1);

	m.queueEase(2239, 2255, "alpha", 0.5, 'quadInOut', 0);
	m.queueEase(2239, 2255, "alpha", 0, 'quadInOut', 1);

	m.queueEase(2255, 2265, "reverse", 1, 'quadInOut', 1);
	m.queueEase(2255, 2265, "reverse", 0, 'quadInOut', 0);

	m.queueEase(2271, 2281, "reverse", 0, 'quadInOut', 1);
	m.queueEase(2271, 2281, "reverse", 1, 'quadInOut', 0);

	m.queueEase(2303, 2319, "alpha", 0.5, 'quadInOut', 1);
	m.queueEase(2303, 2319, "alpha", 0, 'quadInOut', 0);

	m.queueEase(2367, 2390, "reverse", 0, 'quadInOut', 0);
	m.queueEase(2367, 2390, "reverse", 0, 'quadInOut', 1);

	m.queueEase(2367, 2383, "alpha", 0, 'quadInOut', 1);
	m.queueEase(2367, 2383, "opponentSwap", 0.5, 'quadInOut');

	m.queueEase(2415, 2430, "opponentSwap", 0, 'cubeOut');

	m.queueEase(2436, 2440, "opponentSwap", 1, 'cubeOut');

	m.queueEase(2440, 2443, "reverse", 1, 'cubeOut', 0);
	m.queueEase(2444, 2447, "reverse", 0, 'cubeOut', 0);

	m.queueEase(2447, 2454, "opponentSwap", 0, 'cubeOut');
	m.queueEase(2456, 2463, "reverse", 1, 'cubeOut');
	m.queueEase(2463, 2467, "reverse", 0, 'cubeOut');
	m.queueEase(2468, 2475, "reverse", 1, 'cubeOut');
	m.queueEase(2479, 2495, "reverse", 0, 'cubeOut');
	m.queueEase(2559, 2575, "opponentSwap", 1, 'cubeOut');

	m.queueEase(2622, 2640, "opponentSwap", 0, 'cubeOut');

	m.queueEase(2367, 2399, "alpha", 0.5, 'quadInOut', 1);
	m.queueEase(2495, 2511, "alpha", 0, 'quadInOut', 1);

	m.queueEase(2767, 2781, "transform0Y", 1600, 'sineInOut', 1);
	m.queueEase(2799, 2810, "transform1Y", 1600, 'sineInOut', 1);
	m.queueEase(2815, 2830, "transform2Y", 1600, 'sineInOut', 1);
	m.queueEase(2847, 2863, "transform3Y", 1600, 'sineInOut', 1);

	m.queueEase(2671, 2697, "transform3Y", 1600, 'sineInOut', 0);
	m.queueEase(2703, 2719, "transform0Y", 1600, 'sineInOut', 0);
	m.queueEase(2639, 2703, "transform2Y", 1600, 'sineInOut', 0);
	m.queueEase(2735, 2751, "transform1Y", 1600, 'sineInOut', 0);
}
*/