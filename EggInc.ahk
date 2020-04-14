/*
How to use: Replace 15 and 10 in Main() with how many seconds it takes to completely empty and completely fill
your hatchery, repectively. Then run the script from the command line with the number of times you want to
repeat the script, or -1 to have it run infinitely
*/
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
   ; 5% as a buffer, can tinker with Delay (%) to try to get the most performance
   Delay = 0.0226
   InitialTimeMs := TimeToEmptyS * 0.80 * 1000
   RemainingTimeMs := TimeToEmptyS * 0.15 * 1000

   /*
   Math (I can still do algebra)
   hatch time + release time = remaining time & hatch time = ratio * release time
   ratio * release time + release time = remaining time
   release time * (ratio + 1) = remaining time
   release time = remaining time / (ratio + 1)
   */
   Ratio := TimeToEmptyS / TimeToFullS
   TimeToReleaseMs := RemainingTimeMs / (Ratio + 1)
   TimeToHatchMs := RemainingTimeMs - TimeToReleaseMs - (TimeToEmptyS * Delay * 1000)

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