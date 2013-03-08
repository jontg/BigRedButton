# Installing

Requires Mac OS X with Developer Tools installed or Linux with libusb and udev installed. (Support for Windows is planned).
On Linux you may have to [add a udev rule](http://reactivated.net/writing_udev_rules.html). To do that, create a 
file named 99-dream_cheeky.rules with the following content:
{ SUBSYSTEM=="usb", ATTR{idVendor}=="1d34", ATTR{idProduct}=="000d", MODE="0666", GROUP="plugdev" }

# Running

In order to read from tty1 we either need to launch the process on /dev/tty1 (which I only think I know how to do, via /etc/inittab),
or launch the code as root from the command line as
```bash
sudo $(rbenv which ruby) main.rb
```
making sure that tty1 isn't doing anything wonky.
