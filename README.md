# Installing

Requires Mac OS X with Developer Tools installed or Linux with libusb and udev installed. (Support for Windows is planned).
On Linux you may have to [add a udev rule](http://reactivated.net/writing_udev_rules.html). To do that, create a 
file named 99-dream_cheeky.rules with the following content:
{ SUBSYSTEM=="usb", ATTR{idVendor}=="1d34", ATTR{idProduct}=="000d", MODE="0666", GROUP="plugdev" }

