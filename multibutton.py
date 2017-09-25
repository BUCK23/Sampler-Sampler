import  RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(12, GPIO.IN,pull_up_down=GPIO.PUD_UP)
GPIO.setup(16, GPIO.IN,pull_up_down=GPIO.PUD_UP)
GPIO.setup(26, GPIO.IN,pull_up_down=GPIO.PUD_UP)

while True:
    if (GPIO.input(12)==0):
        print("Button press 12")
	time.sleep(0.2)
    if (GPIO.input(16)==0):
        print("Button press 16")
	time.sleep(0.2)
    if (GPIO.input(26)==0):
        print("Button press 26")
	time.sleep(0.2)

GPIO.cleanup();	