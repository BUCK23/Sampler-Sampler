# Installation working notes, week 11th-15th Sept

I NEED TO:

## Get SuperCollider to run startup code efficiently

- This took a lot of tinkering to get s.sync to work
- In order for s.sync to work while the server boots, it needs to be placed WITHIN an s.waitForBoot:
(
s.waitForBoot{{
~stuff.do;
s.sync;
~moreStuff.do;
}.fork;
}
)
- This places s.sync within a routine so that it can be evaluted properly, and this means that the server does not need any hard-coded wait times in order to get things done.

## Handle the installation-based setup for this work.

This needs the following:
- A removal of old patterns so that people can actually see the patterns that they make be uploaded to the installation

I suspect this will need to be done in a task that loops, and with each loop it removes an element of the array. When the array will be at 0 patterns it simply clears the list rather than deleting everything because this may cause some potential issues and maybe crash stuff(?)

- I tested this, look at listTester.scd - this will then be implemented as a Tdef. This Tdef will remove a pattern every minute.
Maybe a minute is not the best interval, because if there is loads of patterns then it will just take ages for the patterns to clear, especially if people are spamming the thing with patterns.
Maybe:
- Time patterns are allowed to remain is made more dynamic
- A 'Max number' of patterns added to the function to prevent silly spamming while making sure that patterns don't disappear too quickly.

Both done, although the 'time' of patterns is not the best.

## Get a more efficient autocoding setup, which is a bit more interesting or dynamic than simple randomness

- In order to do this i'm first going to need to figure out a schema for making things more interesting.
- Toni sent me this paper about blackwork embroidery and maths and that might be a place to look first
- L-systems are a possiblity just to get something more organic, and rules would be easy enough to auto-generate

A few options:

Don't autocode, but show an audience a post window that shows which patterns are played and why.

An option for this could be to calculate pattern play order itself as a blackwork pattern? How would this work?



## Get an 'autocode' setting on a transparent overlay

For a transparent overlay, enable 'compton', which gives the rpi the ability to add transparent windows.

Then use 'terminator' as the xteminal emulator.

add that to ~/.config/lxsession/LXDE-pi/autostart

@terminator
@compton

## Make a shell script that will open SCSynth, start up the .scd file, then open up the Processing sketch.

a simple 'sclang file.scd' doesn't work, it just jams and says that waitForBoot is not actually working

It's to do with DDWSnippets and the document class, I need to remove DDWSnippets while i'm going to be working with sampler/sampler

Then it 'just works'

## Get two raspberry pis to connect to each other and send messages over OSC

In order to SSH into the pi i used the guide from ModMyPi - How to give your raspberry pi a static IP address - UPDATE which involved manually specifying a static IP address into /etc/dhcpcd.conf, this now means that I can ssh into the pi. Does it mean that i can send OSC to it though???

Yes it does, so this means that I should be able to get two Pis to communicate with each other on the assumption that the two have static IP addresses, wonderful.

The two PIs are:

NON-TOUCH SCREEN 192.168.0.10
TOUCH SCREEN 192.168.0.20

They now both communicate with each other.

In order to enable VNC properly, the VNC logo in the taskbar of the Pi needs to have its authentication set to 'VNC Password'

## Get the pis to boot into the proper environment.

An answer on stackoverflow gave the right answer to this one:

edit ~/.config/lxsession/LXDE-pi/autostart
add in @/home/pi/pathtoscript

This relies on a java binary being created for the relevant file


## Get the Pi to sound half-decent

The pi headphone jack sounds like garbage

With a USB Audio Interface it sounds fine, so we need a DAC.

Got a PHAT DAC from Pimoroni, run the auto-install script, ran jack, it didn't work, so i went to QJackctl, selected the correct device, then it 'just works', and actually sounds _very_ good.

## Get Processing and SuperCollider talking to each other

This is going to involve re-writing the whole protocol, probably.

Instead of sending each individual stitch to SuperCollider for direct sonification, I need to make things a bit less individually dependent upon stitches.

Sonifying the process of each individual stitch being made might be nice, as well as sonifying the stitches being made once they have reached Processing itself.

In order to send the amount of data that I want to send though, I need to figure out a way to dump a proper packet over OSC.

That's easy done it turns out, simply append a bunch of messages to an OSC Packet and you're away.

I've then set up a listener in SuperCollider, which receives a message to switch on packet collection, while processing dumps a set of packets which give the stitch data to SuperCollider. SuperCollider then receives a list of arrays which contain the relevant stitch data, and this is stored in ~stitchHistory.

I now need a way to send those packets back to Processing and have the stitches replicated onto the stitching window.


This shouldn't be too hard as I will just be running that data through Processing again.

I also need to make those stitches 'tile', or have the stitches lace with one another. This will probaly involve some kind of calculation about where the stitch WAS compared to where it is going to go. This calculation can probaly be done Processing-side.

In terms of pushing the packets back, it 'just works', in terms of tiling we need to grab the last set of co-ordinates. For that, I need to send an extra packet that contains a thing that will say that this is the last packet. What I might do is when 'logging' is turned off append a 0 to the end of the list

Managed to sort some kind of pushing back, but the issue is now that because absolute co-ordinates are being sent, there is a bit of an issue in re-creating the way in which patterns are drawn.

What would be much nicer would be for patterns to be specified in terms of relative direction (they are currently specified as absolute co-ordinates), and then patterns can be a bit more re-usable

It has honestly been a total nightmare to get this sorted but i think i've managed it, now to test it.

It's still not sorted