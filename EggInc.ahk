StartHatching(NumRepeats, TimeToEmptyS, TimeToFullS) {
   GetHatchReleaseInitialTimesMs(TimeToEmptyS, TimeToFullS, TimeToHatchMs, TimeToReleaseMs, InitialTimeMs)

   MouseClick
   ; Initial hatch
   HatchAndRelease(InitialTimeMs, 0)
   Loop {
      if (NumRepeats != -1 && A_Index > NumRepeats) {
         break
      } else {
         HatchAndRelease(TimeToHatchMs, TimeToReleaseMs)
      }
   }
}

GetHatchReleaseInitialTimesMs(TimeToEmptyS, TimeToFullS, ByRef TimeToHatchMs, ByRef TimeToReleaseMs, ByRef InitialTimeMs) {
   ; 3% subtracted to hatch to account for delay and 5% as a buffer
   InitialTimeMs := TimeToEmptyS * 0.80 * 1000
   RemainingTimeMs := TimeToEmptyS * 0.12 * 1000

   /*
   Math (I can still do algebra)
   hatch time + release time = remaining time & hatch time = ratio * release time
   ratio * release time + release time = remaining time
   release time * (ratio + 1) = remaining time
   release time = remaining time / (ratio + 1)
   */
   Ratio := TimeToEmptyS / TimeToFullS
   TimeToReleaseMs := RemainingTimeMs / (Ratio + 1)
   TimeToHatchMs := RemainingTimeMs - TimeToReleaseMs - (TimeToEmptyS * 0.03 * 1000)

   return
}

HatchAndRelease(TimeToHatchMs, TimeToReleaseMs) {
   MouseClick, , , , , , D
   sleep TimeToHatchMs
   MouseClick, , , , , , U
   sleep TimeToReleaseMs
}

Main() {
   NumRepeats := ParseCLI()
   StartHatching(NumRepeats, 15, 10)
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

ForceExitApp() {
   MouseClick, , , , , , U
   ExitApp
}

Main()

Esc::ForceExitApp()