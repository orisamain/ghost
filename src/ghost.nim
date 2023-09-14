import std / [os,strutils,tables,streams,strscans,algorithm]
import winim/winstr, winim/inc/shellapi, winim/lean
import wNim / [wApp,wSpinCtrl, wComboBox, wFontDialog, wDirDialog, wColorDialog ,wFileDialog, wCheckBox, wFrame, wPanel, wButton, wTextCtrl, wListCtrl, wStaticBox, wMessageDialog, wStatusBar, wIcon, wMenuBarCtrl,wListBox,wStaticText]

const slurpy=staticRead("icon.ico")
var name_id_to_payload = newTable[string, string]()

proc configChecker() =
  try:
    var x = open(getAppDir() & "\\config.txt",fmRead)
    x.close()
    return
  except IOError:
    echo "not existing"
    var x = open(getAppDir() & "\\config.txt",fmWrite)
    x.write("config," & getAppDir() & "\\config.txt" & "\n")
    x.close()
    return

proc readConf()=
  name_id_to_payload.clear
  configChecker()
  let csv = newFileStream(getAppDir() & "\\config.txt", fmRead)
  #let csv = newFileStream("config.txt", fmRead)
  while true:
    if atEnd(csv):
      break
    var line = readLine(csv)
    if line.split(",").len > 1:
      var (success,name_id,payload) = scantuple(line,"$+,$+")
      name_id_to_payload[name_id] = payload

type
  MenuID = enum
    idOpen = wIdUser, idExit, idSave
    idEsc
    idReload

var app = App()
var frame = Frame(title="Ghost", size=(230, 295))
frame.icon = Icon(slurpy)
let sub1 = Panel(frame)
frame.setTransparent(220)


let combosel = ComboBox(sub1,style=wCbSimple or wCbNeededScroll or wBorderSunken)
combosel.getTextCtrl.setBackgroundColor(wLightBlue)
combosel.getlistcontrol.setBackgroundColor(wLightBlue)

proc defaultSkin()  =
  combosel.getTextCtrl.setBackgroundColor(wLightBlue)
  combosel.getlistcontrol.setBackgroundColor(wLightBlue)
  sub1.setBackgroundColor(15790320)
  combosel.getTextCtrl.setForegroundColor(wBlack)
  combosel.getlistcontrol.setForegroundColor(wBlack)

proc darkSkin() =
  combosel.getTextCtrl.setForegroundColor(wWhite)
  combosel.getlistcontrol.setForegroundColor(wWhite)
  combosel.getTextCtrl.setBackgroundColor(wDarkGrey)
  combosel.getlistcontrol.setBackgroundColor(wDarkGrey)
  sub1.setBackgroundColor(wDarkSlateGrey)
  frame.setBackgroundColor(wDarkSlateGrey)

darkSkin()

var accel = AcceleratorTable()
accel.add(wAccelNormal, wKey_Esc, idEsc)
accel.add(wAccelCtrl, wKey_Q, idExit)
accel.add(wAccelCtrl, wKey_H, idReload)
frame.acceleratorTable = accel


proc layout() =
    combosel.position = (10,10)
    combosel.size = (200,240)
    frame.size = (235,305)

proc keypressEvent(input: string) =
  var matches : seq[string]
  var matchesStart : seq[string]
  var matchesContains : seq[string]
  if input.len == 0:
    combosel.getlistcontrol.clear
    return
  else:
    for word in name_id_to_payload.keys:
      if word.toLowerAscii.find(input.toLowerAscii) != -1:
        if word.toLowerAscii.startsWith(input.toLowerAscii):
          matchesStart.add(word)
        else:
          matchesContains.add(word)
    matchesStart.sort()
    matchesContains.sort()
    matches = matchesStart & matchesContains
    combosel.getlistcontrol.clear
    combosel.append(matches)

proc launchShex(payload:string) = 
  ShellExecute(0,"open", payload.strip ,nil,nil,5)


proc launchShexParameter(payload:string, parameters:string) = 
  ShellExecute(0, "open", payload.strip, parameters.strip, nil, SW_SHOWNORMAL);

proc goExec()=
  var matched : string
  var matched2 : string
  if combosel.getValue().len > 0:
    if name_id_to_payload.hasKey(combosel.getValue()) == false and combosel.len > 0:
      if scanf(name_id_to_payload[combosel.getText(0)].strip, "($*)$+", matched, matched2):
        launchShexParameter(matched2,matched)
        frame.delete
      else: 
        launchShex(name_id_to_payload[combosel.getText(0)])
        frame.delete
    else:
      if scanf(name_id_to_payload[combosel.getValue()].strip, "($*)$+", matched, matched2):
        launchShexParameter(matched2,matched)
        frame.delete
      else:
        launchShex(name_id_to_payload[combosel.getValue()])
        frame.delete

combosel.wEvent_Text do (event: wEvent):
  keypressEvent(combosel.getValue())


combosel.wEvent_TextEnter do (event: wEvent):
  if combosel.isListEmpty == false:
    goExec()

combosel.wEvent_CommandLeftDoubleClick do (event: wEvent):
  if combosel.isListEmpty == false:
    goExec()

frame.wEvent_Size do ():
  layout()


frame.idExit do ():
  frame.delete

frame.idEsc do ():
  combosel.getlistcontrol.clear
  combosel.getTextCtrl.clear

frame.idReload do ():
  readConf()

readConf()
layout()

frame.center()
frame.show()
app.mainLoop()

