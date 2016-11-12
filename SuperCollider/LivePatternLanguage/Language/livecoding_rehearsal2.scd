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

*/

(
~keyboardResponder.();
~sampleResponder.(envMul:0.1);
)

StageLimiter.activate

~dir = ["LEFT","DOWN","UP","RIGHT"]

Tdef(\stitch,{ ~clearScreen.(); loop({ ~loopPattern.([3].choose,rrand(0.01,0.2),modifier1:"LEFT"); ~sampleResponder.([500,400,600,700,900,8000,7000].choose,0.1,0.01,0.02); })})

Tdef(\stitch, {loop ({~loopPattern.([6].choose,0.1)})});

~clearScreen.(20)

Tdef(\stitch).play

Tdef(\stitch).stop



~savePattern.()

OSCFunc.trace

~stitchHistory[1]

~clearPattern.()
~clearScreen.(40)




OSCFunc.trace