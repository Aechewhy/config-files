################################
#Use this when you don't have oh my posh
################################
# $Global:__LastHistoryId = -1

# function Global:__Terminal-Get-LastExitCode {
#   if ($? -eq $True) {
#     return 0
#   }
#   $LastHistoryEntry = $(Get-History -Count 1)
#   $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
#   if ($IsPowerShellError) {
#     return -1
#   }
#   return $LastExitCode
# }

# function prompt {

# # First, emit a mark for the _end_ of the previous command.

# $gle = $(__Terminal-Get-LastExitCode);
#   $LastHistoryEntry = $(Get-History -Count 1)
#   # Skip finishing the command if the first command has not yet started
#   if ($Global:__LastHistoryId -ne -1) {
#     if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
#       # Don't provide a command line or exit code if there was no history entry (eg. ctrl+c, enter on no command)
#       $out += "`e]133;D`a"
#     } else {
#       $out += "`e]133;D;$gle`a"
#     }
#   }

# $loc = $($executionContext.SessionState.Path.CurrentLocation);

# # Prompt started
#   $out += "`e]133;A$([char]07)";

# # CWD
#   $out += "`e]9;9;`"$loc`"$([char]07)";

# # (your prompt here)
#   $out += "PWSH $loc$('>' * ($nestedPromptLevel + 1)) ";

# # Prompt ended, Command started
#   $out += "`e]133;B$([char]07)";

# $Global:__LastHistoryId = $LastHistoryEntry.Id

# return $out
# }
################################
#Use this when have oh my posh (under the oh my posh initialization)
################################
$Global:__OriginalPrompt = $function:Prompt

function Global:__Terminal-Get-LastExitCode {
  if ($? -eq $True) { return 0 }
  $LastHistoryEntry = $(Get-History -Count 1)
  $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
  if ($IsPowerShellError) { return -1 }
  return $LastExitCode
}

function prompt {
  $gle = $(__Terminal-Get-LastExitCode);
  $LastHistoryEntry = $(Get-History -Count 1)
  if ($Global:__LastHistoryId -ne -1) {
    if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
      $out += "`e]133;D`a"
    } else {
      $out += "`e]133;D;$gle`a"
    }
  }
  $loc = $($executionContext.SessionState.Path.CurrentLocation);
  $out += "`e]133;A$([char]07)";
  $out += "`e]9;9;`"$loc`"$([char]07)";
  
  $out += $Global:__OriginalPrompt.Invoke(); # <-- This line adds the original prompt back

  $out += "`e]133;B$([char]07)";
  $Global:__LastHistoryId = $LastHistoryEntry.Id
  return $out
}