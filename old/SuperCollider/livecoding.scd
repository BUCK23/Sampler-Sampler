("language.scd").loadRelative

(
~keyboardResponder.();
~sampleResponder.();
)

OSCFunc.trace

~dir = ["LEFT","UPLEFT"]
~dir = ["RIGHT","UPRIGHT","DOWN", "DOWNRIGHT", "DOWN"]

~clearScreen.(10)

~randF.()

(
var i = 1, freqs = (1..30)*200;
~randF = {i=i%20+1;freqs[i]}
)

~randF = {[100,200,300,4000,5000,6000].choose}

~randF.()

~stitchHistory

Tdef(\stitching,{ loop ({ ~loopPattern.([2,3].choose,0.0001,4,0.1,modifier1:~dir.choose); })})
Tdef(\stitching).play


~clearScreen.(20)

StageLimiter.activate

~clearSet.("ON",10,90)

~randNum = {rrand(10,90)}

OSCFunc.trace

~clearPattern.()
~savePattern.()

~clearScreen.(9)

OSCFunc.trace

(1000/64)/2


NetAddr.langPort
