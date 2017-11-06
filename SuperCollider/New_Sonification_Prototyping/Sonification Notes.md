# Sonification Notes

So the type of sonification I have decided on is the following:

A scale is created every time the canvas is refreshed. Degrees of the scale are assigned to directions in which the stitch travels. x

When the canvas is refreshed a new scale is used. x

When stitches are inputted using the console, their respective 'melody' should be played out in SuperCollider. This could take the form of when the GPIO button is pressed, the stitch is 're-drawn' and a melody played back

_good note here_ IMO this shouldn't be a thing where the notes can be heard as they are drawn. Notes should only be heard when they are submitted. This prevents the creation of patterns BASED on the notes. What it DOES do though is allow a participant to input a pattern, hear their pattern be transformed using various scales, and then allow them to input their pattern again, but with a variation. While it's not perfect, it will, in theory, engage a participant in a feedback loop in them re-inputting their own patterns again to create variation on form.

(This implements Tom's idea of keeping the sonification element salient with the interaction - can participants tell how their stitches are adding to the sonification? One way of doing this is seeing how their stitch is morphed using different 12t scales)

The length of stitches is a bit of an issue - as when we get into non-straight directions things can get a little bit iffy.

Ideas:

- Use the length of the stitch to determine octave

Done, the octave is decided by using a rounded mean value of the two co-ordinates.

- Use the diagonal bias to split tones into quarter/eighth tones (this seems particularly nice, as it breaks the user out from scale degrees!)

Not done - this might actually complicate things.


- Attack and Release are reset every time the canvas is refreshed.


TODO:

- Implement touch sonification
- Make an appropriate set of posts to the screen which will give audience some idea of what is going on, especially re: adding their pattern to the currently-existing pattern library







