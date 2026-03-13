' xsupremo_after.vbs
' Eseguito da X-Launcher (RunAfter) dopo la chiusura di Supremo.
' A questo punto X-Launcher ha già:
'   - salvato il settings.dat portatile sulla chiavetta
'   - eliminato il settings.dat portatile dal PC
' Questo script gestisce il ripristino della configurazione
' originale del PC in base a quanto trovato da xsupremo_before:
'   - se esisteva → ripristina da %TEMP%\xsupremo_original.dat
'   - se non esisteva → il PC è già pulito, non fare nulla

Dim fso, settingsPC, settingsDir, backupOrig, sentinella

Set fso = CreateObject("Scripting.FileSystemObject")

settingsPC  = "C:\ProgramData\SupremoRemoteDesktop\settings.dat"
settingsDir = "C:\ProgramData\SupremoRemoteDesktop"
backupOrig  = fso.GetSpecialFolder(2) & "\xsupremo_original.dat"
sentinella  = fso.GetSpecialFolder(2) & "\xsupremo_nooriginal.flag"

If fso.FileExists(sentinella) Then
    ' Sul PC non c'era nessun settings.dat prima della sessione.
    ' X-Launcher ha già eliminato il nostro — il PC è pulito.
    fso.DeleteFile sentinella, True

ElseIf fso.FileExists(backupOrig) Then
    ' Ripristina la configurazione originale del PC
    If Not fso.FolderExists(settingsDir) Then fso.CreateFolder settingsDir
    fso.CopyFile backupOrig, settingsPC, True
    fso.DeleteFile backupOrig, True

End If
' Caso: nessun backup e nessuna sentinella = sessione anomala.
' Non toccare nulla per sicurezza.

Set fso = Nothing
WScript.Quit 0
