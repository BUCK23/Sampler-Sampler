("language_0.4.scd").loadRelative

/*

Language Parameters

keyboardResponder
sampleResponder
arg freq = 400, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0;

savePattern
clearPattern
loopPattern
arg pattern = 0, period = 0.1, num = 1, delay = 0.1, modifier1 = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";

clearScreen
clearSet

freq = 400, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0, envMul = 2;

*/

(
~keyboardResponder.();
~sampleResponder.(envMul:1.5);
~hostPatternControl.();
)

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1,
			num:1,
			delay:0.5,
			modifier1:"NONE",
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:400,
			amp:0.1,
			atk:0.01,
			rel:0.1,
			pan:0,
			envMul:2
		);
	})}
)
)

