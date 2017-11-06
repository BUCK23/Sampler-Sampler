## Sampler/Sampler Notes for Install

Note - the static IP of the HOST machine (the machine to which samples are sent) has the IP address:
192.168.100.101

laptop = 192.168.100.100
Host = 192.168.100.101
Touch screen 1 = 192.168.100.102
Touch screen 2 = 192.168.100.103


MicroSD labels:

TS1 = Touch Screen 1
TS2 = Touch Screen 2

All other machines must be set to static IP addresses 192.168.100.xxx

There's a possibility that frequencies need tweaking in order to make them louder or more salient. I'm not sure if using a .linexp on the volume has done any good, all it seems to have done is make things quieter - it might genuinely need a custom transfer function

Things that need going on the new Rpis:

- A test builds directory which contains updated new sampler/sampler code, this is dropped in using the command:

rsync -av -e ssh Sampler-Sampler pi@192.168.100.103:~/test_builds#

A binary then needs to be compiled which will run the updated Processing sketch.

With this, I don't need Git, but I can push updates over rsync to a local network (ethernet to the two Pis)

Note: Pi autostart files are held in /home/pi/.config/lxsession/LXDE-pi

and a startup script is held at startUp.sh in home

this can refer to the following command:

processing-java --sketch=/home/pi/test_builds#/Sampler-Sampler/samplersampler_touch --run

Lovely!

Note, that the autocode template is auto-started on the host pi, but it's tied to version 1.3 by a hard-coded link. be careful with this  
^^^ this won't work for reasons.
Instead, we need to open a terminal which will shunt a command

/home/pi/test_builds#/Sampler-Sampler/SuperCollider/autocode_template_1.3.scd
