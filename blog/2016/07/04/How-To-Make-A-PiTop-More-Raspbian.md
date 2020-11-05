{
    "markup": "mmark",
    "title": "How to make a Pi-Top more Raspbian",
    "author": "R. S. Doiel",
    "date": "2016-07-04",
    "keywords": [ "Raspberry Pi", "Pi-Top", "Rasbian", "Raspberry Pi OS", ":operating systems" ],
    "copyright": "copyright (c) 2016, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# How to make a Pi-Top more Raspbian

By R. S. Doiel 2016-07-04

I have a first generation Pi-Top.  I like the idea but found I didn't use it much due to a preference for
basic Raspbian. With the recent Pi-TopOS upgrades I realized getting back to basic Raspbian was relatively
straight forward.

## The recipe

1. Make sure you're running the latest Pi-TopOS based on Jessie
2. Login into your Pi-Top normally
3. From the Pi-Top dashboard select the "Desktop" icon
4. When you see the familiar Raspbian desktop click on the following things
	+ Click on the Raspberry Menu (upper left corner)
	+ Click on Preferences
	+ Click on Raspberry Pi Configuration
5. I made the following changes to my System configuration
	+ Under *Boot* I selected "To CLI"
	+ I unchecked *login as user "pi"*
6. Restart your Pi Top
	+ Click on Raspberry Menu in the upper left of the desktop
	+ Click on shutdown
	+ Select *reboot*
7. When you restart you'll see an old school console login, login as the pi user using your Pi-Top password
8. Remove the following program use the *apt* command
	+ ceed-universe
	+ pt-dashboard
	+ pt-splashscreen

```
    sudo apt purge ceed-universe pt-dashboard pt-splashscreen
```

Note: pi-battery, pt-hub-controller, pt-ipc, pt-speaker are hardware drivers specific to your Pi-Top so you probably
want to keep them.



