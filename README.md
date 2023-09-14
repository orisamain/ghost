# Ghost

Ghost is a minimal Windows launcher, it simply forwards the path of apps that you want to launch to the Windows builtin ```ShellExecute```, so it can do everything ```ShellExecute``` can, for example:

```
- Launch programs or their shortcuts
- Open files with their default program
- Open Folders
- Open websites with the default browser
- Execute Scripts
- Open any Windows settings
```

### Demo:
[Demo](assets/demo.mp4)

### Install:

Grab the executable from the releases page and run it.

#### (Optional):
Since a launcher that can't be invoked fast is not very useful, it is recommended that you use [AutoHotkey](https://www.autohotkey.com/) to call Ghost. As a reference this is the script I use to call Ghost using the ```CapsLock``` key.
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
To have Ghost available at Windows startup you can place the invoking script in the Windows startup folder ```C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup``` or add a task to the Windows ```TaskScheduler``` to start the script at login, in that case it's recommended to check "Run with highest privileges" to have Ghost up and running immediately at startup while the other programs are still loading.



### Configuration:
When Ghost is called for the first time it will create a ```config.txt``` file in the same folder as the executable. Edit this file to list all the apps you want to launch following these rules:

- One command per line;
- Use this format: app name, comma, path of the app. For example ```calculator, calc.exe```;
- To launch an app with parameters use this format: app name, comma, (parameters)path. For example ```backup, (C:\myscripts\backup.ps1)powershell.exe```.


### Usage:
Run Ghost, type the app to launch, press enter.

### Some configuration examples:
- Open a folder: ```programs, C:\Program Files```
- Open a file: ```my notes, C:\Users\user\Desktop\notes.txt```
- Open a program: ```foobar, C:\Program Files\foobar2000\foobar2000.exe```
- Open a webpage: ```ChatGPT, https://chat.openai.com/chat```
- Open a shortcut: ```whatsapp, C:\Users\user\Desktop\Shortcuts\whatsapp.lnk```
- Shellexecute understands [CLSID](https://www.elevenforum.com/t/list-of-windows-11-clsid-key-guid-shortcuts.1075/):
```recycle bin, ::{645FF040-5081-101B-9F08-00AA002F954E}```
- Shellexecute understands [URI commands](https://4sysops.com/wiki/list-of-ms-settings-uri-commands-to-open-specific-settings-in-windows-10/): ```bluetooth, (ms-settings:bluetooth)explorer.exe ```


### Security:
Ghost is written in [Nim](https://nim-lang.org/) and as a well known [issue](https://forum.nim-lang.org/t/9850) Nim executables might sometimes get flagged by antivirus software. It's a false positive. Ghost is absolutely clean, cannot connect to the internet, and the source can be easily inspected and built upon (it's barely 200 lines of code, really minimal 😊)
