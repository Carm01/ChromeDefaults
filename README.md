# Setting Chrome Defaults
This will explain how to set up a Chrome Browser defaults


Chrome is a little more tricky to set up because of Googles documentation and it is scattered all over the place and using the master_preferences file does not fully function. Some additional regedits aka google Group policies have to be added(more on that in a sceond ) 

In my iteration there is a master_preferences which contains some settings like setting the bookmark file, show home button, home pages, show the bookmark bar, desktop icons, some first runs, etc work with just the addition of this file. However thing like the default nagging on Windows 10 is broken and those are handled via a regedit, so some work, some do not. Most do, The other issue with Chrome First runs is that the first run might work fine, but the second lauch is where issue arise in that an additional tab is launched called: 'chrome://welcome/?variant=everywhere'. I cannot find at this time how to prevent this issue. There is no documentation that I can find to avoid this. 

The master_preferences and bookmarks.html go in the locatio of the chrome exe which is usually here: 
C:\Program Files (x86)\Google\Chrome\Application
The regedits go in one place and are listed in ChromeDefaults.cmd file. 
These setting of course can be changed based off the adm template. The adm emplate can be found here:
https://support.google.com/chrome/a/answer/187202?hl=en
It is located in the zip file - Windows - Adm, then choose your language and place it in a folder here:
C:\Windows\System32\GroupPolicy\ADM
then you can open the GPeditor and and browse under local machine Adm templates , then Classic Adm templates. 
All policies live in the registry here: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome

Once you figured out your reg settings there is no need to import the adm file to every machine. Just capture your regedits and that is it. 
; https://www.jamf.com/jamf-nation/discussions/10331/chrome-master-preferences-file-and-suppressing-first-run-browser
