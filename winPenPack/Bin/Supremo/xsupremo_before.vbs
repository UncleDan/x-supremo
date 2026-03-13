' xsupremo_before.vbs
' Eseguito da X-Launcher (RunBefore) prima di avviare Supremo.
' Salva il settings.dat del PC in %TEMP% se esiste,
' in modo che possa essere ripristinato dopo la sessione.
' Se non esiste, lascia un file sentinella per comunicarlo
' a xsupremo_after.vbs.

Dim fso, settingsPC, backupOrig, sentinella

Set fso = CreateObject("Scripting.FileSystemObject")

settingsPC  = "C:\ProgramData\SupremoRemoteDesktop\settings.dat"
backupOrig  = fso.GetSpecialFolder(2) & "\xsupremo_original.dat"
sentinella  = fso.GetSpecialFolder(2) & "\xsupremo_nooriginal.flag"

' Pulisci eventuali residui di sessioni precedenti
If fso.FileExists(backupOrig) Then fso.DeleteFile backupOrig, True
If fso.FileExists(sentinella) Then fso.DeleteFile sentinella, True

If fso.FileExists(settingsPC) Then
    ' Salva la configurazione originale del PC
    fso.CopyFile settingsPC, backupOrig, True
Else
    ' Nessun settings.dat sul PC — segnalo per il RunAfter
    Dim f : Set f = fso.CreateTextFile(sentinella, True) : f.Close
End If

Set fso = Nothing
WScript.Quit 0
