OSCFunc.trace

Tdef(\stitch).play

//INTERNAL SUPERCOLLIDER TESTING
//UP
~superCollider.sendMsg('/stitchSC',0.0,-1.0,1)
//UPRIGHT
~superCollider.sendMsg('/stitchSC',1.0,-1.0,1)
//RIGHT
~superCollider.sendMsg('/stitchSC',1.0,0.0,1)
//DOWNRIGHT
~superCollider.sendMsg('/stitchSC',1.0,1.0,1)
//DOWN
~superCollider.sendMsg('/stitchSC',0.0,1.0,1)
//DOWNLEFT
~superCollider.sendMsg('/stitchSC',-1.0,1.0,1)
//LEFT
~superCollider.sendMsg('/stitchSC',-1.0,0.0,1)
//UPLEFT
~superCollider.sendMsg('/stitchSC',-1.0,-1.0,1)



//UP
~processing.sendMsg('/stitchSC',0.0,-1.0,1)
//UPRIGHT
~processing.sendMsg('/stitchSC',1.0,-1.0,1)
//RIGHT
~processing.sendMsg('/stitchSC',1.0,0.0,1)
//DOWNRIGHT
~processing.sendMsg('/stitchSC',1.0,1.0,1)
//DOWN
~processing.sendMsg('/stitchSC',0.0,1.0,1)
//DOWNLEFT
~processing.sendMsg('/stitchSC',-1.0,1.0,1)
//LEFT
~processing.sendMsg('/stitchSC',-1.0,0.0,1)
//UPLEFT
~processing.sendMsg('/stitchSC',-1.0,-1.0,1)


~scale = Scale.choose

