# Sampler-Sampler SuperCollider Microlanguage Documentation

The functions in the language are described in these terms:
~function(argumentName = defaultValue, argumentName2 = defaultValue)

~savePattern.()
Saves all direction data currently stored to list ~stitchHistory. This is normally handled by Processing (press A to save pattern), but can be triggered from within SuperCollider.

~clearPattern.()
Clears all direction data currently stored, so that a new pattern can be recorded withou saving the existing one. This is normally handled by Processing (click to clear screen and pattern), but can be triggered from within SuperCollider.

~clearScreen.(size = 10)
Clears the screen of the Processing sketch and scales the grid to the value given in the function.

~loopPattern.(pattern = 0, period = 0.1, num = 1, delay = 0.1, modifier1 = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE", reverse = 0)
Usually placed inside a Tdef to manage repetitions and to avoid concurrent patterns.
pattern: The pattern to be played from list ~stitchHistory
period: The delay between each individual stitch.
num: The number of times a pattern will be played. Note if this is inside a Tdef that itself loops, it will recur forever, but this feature allows for more granular control of exactly what is looping.
delay: A delay inserted after the function has completed.
modifier1-4: Actions to be taken after each completed pattern.
reverse: An option to reverse the drawing of a pattern.

~keyboardResponder.(freq = 100, amp = 0.1, atk = 0.4, rel = 1, pan = 0, envMul = 3)
A function to enable and set the properties of the sonification of stitches made using the keyboard (or a keyboard emulator).
freq: Sets the fundamental frequency, note that all frequencies for keyboard-driven stitching directions are multiples of this
amp: Sets the amplitude
atk: Sets the attack
rel: Sets the release
pan: Sets the panning
envMul: A multiplier for the envelope duration

~sampleResponder.(freq = 400, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0, envMul = 2)
A function to enable and set the properties of the sonification of sampled stitches which are sequenced within SuperCollider
freq: Sets the frequency of the sampled stitch sonification. Note that the frequency is the same no matter which direction, but the types os synthesis used to deliver them are different
amp: as above
atk: as above
rel: as above
pan: as above
envMul: as above

~dir
An array containing all possible directions a stitch can be made. To be used within ~loopPattern to select a direction after a stitch is looped. For example, to run a pattern then jump left to create repetitive stitches moving to the left

~dirLong
The same as dir, but for long stitches

~randDir
shorhand for ~dir.choose (used often for random jumping after looping patterns)

~randDirLong
shorthand for ~dirLong.choose

~hostPatternControl.()
Enables the control of pattern saving/writing/clearing by Processing (opening two OSCdefs).


