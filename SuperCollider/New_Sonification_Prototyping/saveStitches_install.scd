//write stitch history
(
var f, g;
f = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches_install.txt".standardizePath,"w");
f.write(~stitchHistory.cs);
f.close;
)

~stitchHistory = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches.txt".standardizePath,"r").readAllString.interpret

