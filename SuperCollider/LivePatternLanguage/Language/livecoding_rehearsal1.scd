("language_0.2.scd").loadRelative

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
~sampleResponder.();
)

StageLimiter.activate

Tdef(\stitch,{ loop({ ~loopPattern.([4].choose,[0.1,0.2/3].choose,1,0,modifier1:~dir.choose,modifier2:~dir.choose,modifier3:"DOWN"); ~sampleResponder.([500,600,700,800,1000,2000,3000].choose,0.1,0.01,0.05); })})

Tdef(\stitch).play

~savePattern.()


~clearPattern.()
~clearScreen.(40)




OSCFunc.trace