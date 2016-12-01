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
~keyboardResponder.(envMul:3,pan:0.9,amp:0.1);
~sampleResponder.(envMul:1.5);
~hostPatternControl.();
)

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[13,15].choose,
			period:[0.05,0.01].choose,
			num:1,
			delay:0,
			modifier1:~dir.choose,
			modifier2:~dirLong.choose,
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:[400,800,1600,3200,100,200,300].choose,
			amp:0.05,
			atk:0.01,
			rel:0.05,
			pan:-0.9,
			envMul:2
		);
	})}
)
)

~clearScreen.(40)

Tdef(\stitch).stop

s.scope

Tdef(\stitch).play;
