# Sampler/Sampler 1.0
----------------

By Toni Buckby and Sean Cotterill

_**sampler [NOUN]**
1: A piece of embroidery worked in various stitches as a specimen of skill, typically containing the alphabet and some mottoes.
2: An electronic device for sampling music and sound._

## Environment

Sampler/Sampler 1.0 consists of:

**A Blackwork Emulator processing sketch** (with input from [Alex McLean](https://github.com/yaxu/)), which uses keystrokes to create blackwork stitching faithful to original technique (instructions on how to operate the emulator are included in the file). In addition to creating visual patterns, the emulator sends OSC strings to SuperCollider, where they are used to create arrays containing patterns used for 'sampling' and sequencing. The 'clear screen' and 'save pattern' commands within the emulator also send messages to SuperCollider that dictate when to clear and save patterns - the idea being that during performance the 'host' creates discrete patterns in Processing and sends them to the 'client' (who is running Processing and SuperCollider), who will create live-coded sequences of those individual pattern units according to set parameters.

The sketch can be run in [client mode](../1.0/sampler_sampler_client/sampler_sampler_client.pde) for machines that will be recieving patterns from another machine or sampling locally, or [host mode](../1.0/sampler_sampler_host/sampler_sampler_host.pde) which gives the machine the ability to send pattern data to other networked machines (the only 
difference between the two is the IP address specified in the OscP5 setup). If a machine is running both the Processing and SuperCollider components of Sampler/Sampler 1.0, both pattern generation and sequencing can be done by the same machine, removing the need for a networked 'host'.

**A SuperCollider sonification engine and micro-language**, designed to receive pattern information from Processing via OSC (will recieve any keystroke data regardless if it is from a 'client' or 'host' instance), and on command save those patterns to a local 'sampler', for these 'samples' to then be sequenced and sent to a local Processing instance (can be sent to a remote one with some address changes). The sonification engine will sonify keystroke stitches and sequenced stitches differently, both to differentiate sonically between the actions taking place as well as to allow some sonic freedom in sonifying sequenced stitches.

**An optional laser-cut console to operate the Blackwork Emulator**. Developed for the performance of Sampler/Sampler 1.0, the console has a control plate for operating each stitch direction, as well as modifier and clear screen keys (a notable absence is a 'save pattern' button, as this functionality was implemented after the enclosure was built without enough time for it to be re-built for performance at AlgoMech festival). The schematics for laser cutting the box are included in the [box-plans](../1.0/box-plans) folder, and the schematic is set up to contain Pimoroni Arcade buttons (or equivalent). The console uses an Arduino with Keyboard Library to trigger the relevant keystrokes to operate the Processing sketch when buttons are pressed. The Arduino code contains de-bouncing measures to prevent duplicate switch triggers.


## Usage

**Requirements**

Sampler/Sampler 1.0 was developed with and performed on \*buntu 16.04, but _should_ run without issues on OSX. I have not had the opportunity to test this on Windows.

In order to run out of the box, Sampler/Sampler 1.0 requires:
* [SuperCollider](https://github.com/supercollider/supercollider) (Tested with version 3.7.0-Beta, any version after 3.6.6 should work)
* [sc3-plugins](https://github.com/supercollider/sc3-plugins)
* [Processing](https://processing.org) (Tested with version 3.2.2)
* [OscP5](http://www.sojamo.de/libraries/oscP5/)

To build the specific hardware involved in the project (not essential):
* An Arduino board capable of running the [Keyboard and Mouse libraries](https://www.arduino.cc/en/Reference/MouseKeyboard)
* Access to a laser cutter to build the box
* [Pimoroni Colourful Arcade Butons](https://shop.pimoroni.com/products/colourful-arcade-buttons) (or equivalent)


**How to get started**:

1. Load and run the sampler-sampler Processing sketch. If using on one machine only, load sampler-sampler client, if using on two machines, load sampler-sampler-host on the machine that will be sending patterns, and load sampler-sampler-client on the machine that will be recieving patterns and sampling/sequencing them.
2. Load the livecoding_template.scd file from the SuperCollider folder and follow the instructions to load the microlanguage and sonification code. The microlanguage works by wrapping functions inside of a [Tdef](http://doc.sccode.org/Classes/Tdef.html), so knowing a little about how Tdefs work alongside the documentation of the functions will probably be of some use.
3. Draw some patterns using the Processing sketch, and send them to SuperCollider using the A key (then clear your screen). This should show in your SuperCollider window as having created Pattern 0. This pattern can then be sequenced using the language

### Examples and Documentation

The Processing sketches both contain instructions on how to operate them at the start of the file.

Examples for the SuperCollider Microlanguage are located inside the SuperCollider/Documentation folder
