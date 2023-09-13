# Ghost

Ghost is a minimal Windows launcher, it simply forwards the things you want to launch to the Windows builtin ```ShellExecute``` command, so it can do everything ```ShellExecute``` can, for example:

```
- Launch Programs
- Launch Shortcuts
- Launch Files with the default program associated with that class of files
- Open Folders
- Open websites with the default browser
- Launch Scripts
```

### Demo:

### Install:

Grab the executable from the releases page and run it.

#### (Optional):
Since a launcher that can't be invoked fast is not very useful, it is recommended that you use [AutoHotkey](https://www.autohotkey.com/) to call Ghost. As a reference this is the AutoHotkey script I use to call Ghost using the ```CapsLock``` key.
```
#SingleInstance ignore
+CapsLock::CapsLock
CapsLock::
IfWinExist, ahk_exe ghost.exe
{
WinActivate, ahk_exe ghost.exe
return
}
else
{
Run, C:\your\path\to\ghost.exe
Sleep 500
WinActivate, ahk_exe ghost.exe
return
}
```
To have Ghost available at startup you can copy the AutoHotkey script in the Windows startup folder ```C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup``` or add a task to the Windows ```TaskScheduler``` to start the script at login, in that case you should check "Run with highest privileges" to have it up and running immediately while the other programs are still loading.



### Configuration:
When Ghost is called for the first time it will create a ```config.txt``` file in the same folder as the executable. Edit this file to add the things you want to launch following these rules:

- One command per line;
- In the following format: ```shortcut name, C:/path/to/the/object```. For example ```calculator, C:\Windows\System32\calc.exe```;
- To launch a program with parameters: ```name,(parameters)C:/path/to/the/object```. For example ```uninstall or modify a program, (appwiz.cpl)control.exe```.


### Usage:
Run Ghost, start typing the short handle of the thing you want to launch, press enter to launch


