Main() {
   NumRepeats := ParseCLI()
   StartHatching(NumRepeats, 900, 800, 15000)
   PrintEndingMessage(NumRepeats)
   ExitApp
}

ParseCLI() {
   if A_Args.Length() > 1 {
      PrintParseError()
   } else if A_Args[1] == "h" {
      PrintUsage()
   } else if A_Args[1] is not integer {
      PrintParseError()
   } else {
      return A_Args[1]
   }

   ExitApp
}

PrintParseError() {
   MsgBox % "Script requires an integer as the number of repeats as a parameter, or ""h"" for help"
}

PrintUsage() {
   MsgBox % "Usage: EggInc.ahk numRepeats [h]`nFor infinite repeats, set numRepeats to -1"
}

PrintEndingMessage(NumRepeats) {
   MsgBox % "Successfully repeated " NumRepeats " times"
}

HatchAndRelease(TimeToHatchMs, TimeToReleaseMs) {
   MouseClick, , , , , , D
   sleep TimeToHatchMs
   MouseClick, , , , , , U
   sleep TimeToReleaseMs
}

InitialHatch(TimeToEmptyMs) {
   HatchAndRelease(TimeToEmptyMs * 0.85, 0)
}

StartHatching(NumRepeats, TimeToHatchMs, TimeToReleaseMs, TimeToEmptyMs) {
   MouseClick
   InitialHatch(TimeToEmptyMs)
   Loop {
      FileAppend, %A_Index%, *
      if (NumRepeats != -1 && A_Index > NumRepeats) {
         break
      } else {
         HatchAndRelease(TimeToHatchMs, TimeToReleaseMs)
      }
   }
}

ForceExitApp() {
   MouseClick, , , , , , U
   ExitApp
}

Main()

Esc::ForceExitApp()