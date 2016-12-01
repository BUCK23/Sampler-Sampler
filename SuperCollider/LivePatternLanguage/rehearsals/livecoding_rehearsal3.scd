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
//pan Sampler to side I am on, Keyboard to Toni's side
~keyboardResponder.(pan:0.8);
~sampleResponder.(pan:-0.8);
~hostPatternControl.();
)

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:[0.1,0.2,0.3,0.05].choose,
			num:1,
			delay:0.1,
			modifier1:["UP","DOWN","LEFT","RIGHT"].choose,
			modifier2:"UPLEFT",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:[400,800,1600,900].choose,
			amp:0.1,
			atk:0.01,
			rel:0.05,
			pan:-0.8,
			envMul:2
		);
	})}
)
)

~clearScreen.(20)

~clearScreen.(10)

s.scope
Tdef(\stitch).stop