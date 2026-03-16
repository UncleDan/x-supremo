# Supremo Remote Control — X-Launcher INI

Portable launcher configuration for **Supremo Remote Control** by Nanosystems,
built for the [winPenPack](http://www.winpenpack.com/) framework using **X-Launcher 1.5.4**.

---

## File

`X-Supremo.ini`

---

## What it does

- Launches `Supremo.exe` from the portable `$Bin$\Supremo\` directory
- Sets the working directory to the executable's folder **before** launch (`SetWorkingDir`), equivalent to a DOS `cd` — ensures Supremo finds its own config files correctly
- Passes the `/portable` flag to Supremo so it creates a `SupremoRemoteDesktop\` folder in the current working directory instead of the user profile

---

## Directory layout (winPenPack conventions)

```
winPenPack\XDrive\
    X-Supremo.exe      ← copy of X-Launcher.exe, renamed
    X-Supremo.ini      ← this file

$Bin$\Supremo\
    Supremo.exe            ← must be downloaded manually before first run
    SupremoRemoteDesktop\  (created by Supremo at first run, due to /portable)
```

> **Setup note:** copy `X-Launcher.exe` into `winPenPack\XDrive\` and rename it `X-Supremo.exe`.
> X-Launcher automatically looks for an `.ini` with the same base name as the executable.

---

## Variables reference

| Variable | Meaning |
|---|---|
| `$Bin$` | winPenPack `\bin\` folder |
| `$AppName$` | `Supremo` (defined in `[Setup]`) |
| `$Home$` | winPenPack user home folder |

---

## Options

| Key | Value | Note |
|---|---|---|
| `DeleteTemp` | `true` | Clean temp files on exit |
| `ShowSplash` | `false` | No splash screen |
| `ShowTrayTip` | `false` | No tray balloon |
| `WriteLog` | `false` | No launcher log |
| `RunWait` | `false` | Launcher exits without waiting for Supremo to close |

---

## Authors

- INI: Daniele Lolli feat. Claude — 16/03/2026
- X-Launcher: Gabriele Tittonel & winPenPack Development Team
- Supremo Remote Control: [Nanosystems](https://www.supremocontrol.com/)
