# X-Supremo
## Profili Supremo Remote Control portatili su chiavetta USB
### winPenPack X-Launcher

---

## Indice

1. [Requisiti](#requisiti)
2. [Struttura sulla chiavetta](#struttura)
3. [Setup iniziale](#setup)
4. [Creare un nuovo profilo](#creare-profilo)
5. [Uso quotidiano](#uso-quotidiano)
6. [Backup e ripristino](#backup)
7. [Note tecniche](#note)

---

## 1. Requisiti

- **Supremo Remote Control** installato sul PC host
  (scaricabile da https://www.supremocontrol.com/download-supremo/)
- **winPenPack X-Launcher** (X-Launcher.exe)
  (scaricabile da https://sourceforge.net/projects/winpenpack/files/X-Launcher/)
- **Supremo Console** — un account per ogni profilo che vuoi creare
  (https://www.nanosystems.com/signin)
- Chiavetta USB con lettera di unità fissa assegnata
- Windows con privilegi di Amministratore per la prima configurazione

---

## 2. Struttura sulla chiavetta

```
<unita>:\WinPenPack\
│
├── XDrive\
│   ├── X-Supremo-Default.exe      ← X-Launcher.exe rinominato (template)
│   ├── X-Supremo-Default.ini      ← INI template (non modificare)
│   ├── X-Supremo-AziendaRossi.exe ← generato da INIZIALIZZA
│   ├── X-Supremo-AziendaRossi.ini ← generato da INIZIALIZZA
│   ├── X-Supremo-ClienteXYZ.exe
│   └── X-Supremo-ClienteXYZ.ini
│
├── Bin\Supremo\
│   ├── Supremo.exe                ← eseguibile Supremo
│   └── INIZIALIZZA.bat            ← script di configurazione
│
├── User\Supremo\
│   ├── AziendaRossi\
│   │   └── settings.dat           ← profilo attivo
│   └── ClienteXYZ\
│       └── settings.dat
│
└── Backup\Supremo\
    ├── AziendaRossi\
    │   ├── settings.bak1          ← sessione precedente
    │   ├── settings.bak2
    │   ├── settings.bak3
    │   ├── settings.bak4
    │   └── settings.bak5          ← 5 sessioni fa
    └── ClienteXYZ\
        └── ...
```

---

## 3. Setup iniziale (una volta sola)

### Passo 1 — Assegna una lettera fissa alla chiavetta

Su ogni PC che utilizzerai:

1. Inserisci la chiavetta
2. Tasto destro su **Start** → **Gestione disco**
3. Tasto destro sulla partizione della chiavetta → **Cambia lettera e percorsi**
4. Clicca **Cambia** → seleziona una lettera fissa (es. `S:`) → OK

### Passo 2 — Prepara i file sulla chiavetta

Estrai lo ZIP mantenendo la struttura delle cartelle, poi:

- Copia `X-Launcher.exe` in `XDrive\` rinominandolo `X-Supremo-Default.exe`
- Copia `Supremo.exe` in `Bin\Supremo\`

La struttura `WinPenPack\` con tutti i file necessari è già pronta.

---

## 4. Creare un nuovo profilo

Lancia `Bin\Supremo\INIZIALIZZA.bat` come **Amministratore**.

Lo script chiede tre informazioni:

### Nome profilo
Il nome che identificherà questo profilo. Viene usato come:
- Nome del file launcher: `XDrive\X-Supremo-NomeProfilo.exe`
- Nome del file INI: `XDrive\X-Supremo-NomeProfilo.ini`
- Nome della cartella User: `User\Supremo\NomeProfilo\`
- Nome della cartella Backup: `Backup\Supremo\NomeProfilo\`

Usa solo lettere, numeri e trattini. Esempi: `AziendaRossi`, `ClienteXYZ`, `Lavoro-2`

### Licenza
Il codice licenza Supremo associato a questo profilo (formato `XXXXX-XXXXX-XXXXX-XXXXX`).
Ogni profilo ha la sua licenza indipendente.

### Login Supremo Console (passaggio manuale)
Quando Supremo si avvia automaticamente, devi:

1. Aprire **Tools → Options → Console**
2. Accedere con **email e password** dell'account Supremo Console
   associato a questo profilo
3. Verificare che la **rubrica clienti** dell'account sia visibile

> ℹ️ La rubrica non viene configurata separatamente perché è parte
> integrante dell'account Supremo Console. Quando accedi con le
> credenziali di un account, la sua rubrica si carica automaticamente
> in Supremo. Il `settings.dat` salvato sulla chiavetta contiene
> sia la licenza che le credenziali Console (e quindi la rubrica),
> rendendo il profilo completamente autonomo e indipendente.

4. Chiudere Supremo dalla tray → tasto destro → **Esci**
5. Tornare allo script e premere un tasto

Lo script salva il `settings.dat` completo nella cartella del profilo
sulla chiavetta e pulisce ogni traccia dal PC.

### Profili multipli

Al termine di ogni profilo, lo script chiede se vuoi crearne un altro.
Puoi creare tutti i profili che vuoi in una sola sessione, ognuno con
la sua licenza e il suo account Console.

---

## 5. Uso quotidiano

Doppio clic sul launcher del profilo desiderato in `XDrive\`:

```
X-Supremo-AziendaRossi.exe   → apre Supremo con rubrica Azienda Rossi
X-Supremo-ClienteXYZ.exe     → apre Supremo con rubrica Cliente XYZ
```

Non servono privilegi di Amministratore per l'uso quotidiano.

### Cosa succede ad ogni avvio

| Momento | Operazione |
|---------|------------|
| **Avvio** | Rotazione backup (bak1→bak2→...→bak5), poi copia `settings.dat` chiavetta → PC |
| **Durante** | Supremo lavora normalmente con licenza e rubrica del profilo |
| **Chiusura** | `settings.dat` aggiornato copiato PC → chiavetta |
| **Pulizia** | `settings.dat` eliminato dal PC — nessuna traccia lasciata |

> ⚠️ Chiudi sempre Supremo dalla **tray** (tasto destro → Esci) e non
> dalla X della finestra. Solo così X-Launcher rileva la chiusura
> ed esegue il salvataggio e la pulizia.

> ⚠️ Non sfilare la chiavetta mentre Supremo è in esecuzione.

---

## 6. Backup e ripristino

Ad ogni avvio vengono mantenute automaticamente le ultime **5 versioni**
del profilo nella cartella `Backup\Supremo\NomeProfilo\`:

```
settings.bak1  ← sessione precedente  (più recente)
settings.bak2  ← 2 sessioni fa
settings.bak3  ← 3 sessioni fa
settings.bak4  ← 4 sessioni fa
settings.bak5  ← 5 sessioni fa        (più vecchio)
```

### Per ripristinare un backup

1. Assicurati che Supremo sia chiuso
2. Copia il file desiderato (es. `settings.bak1`) in
   `User\Supremo\NomeProfilo\`
3. Rinominalo `settings.dat`
4. Avvia normalmente con il launcher del profilo

---

## 7. Note tecniche

### Come funziona il template

Il file `X-Supremo-Default.ini` contiene il segnaposto `##NOMEPROFILO##`
al posto del nome profilo. Quando INIZIALIZZA.bat crea un nuovo profilo,
copia il template e sostituisce ogni occorrenza di `##NOMEPROFILO##`
con il nome scelto, generando un INI completamente configurato.
Il template originale rimane intatto per usi futuri.

### Percorsi relativi nell'INI

X-Launcher usa `$ScriptDir$` come variabile che punta alla cartella
dell'INI (`XDrive\`). I percorsi verso User e Backup usano `..\` per
risalire alla radice `WinPenPack\`, rendendo il tutto indipendente
dalla lettera di unità della chiavetta.

### Dove Supremo salva la configurazione

Supremo legge e scrive la sua configurazione in:
```
C:\ProgramData\SupremoRemoteDesktop\settings.dat
```
X-Launcher copia il profilo dalla chiavetta in questo percorso prima
dell'avvio, e lo rimuove dopo la chiusura. Il PC non conserva mai
nessuna informazione sensibile tra una sessione e l'altra.

### Aggiornamento di Supremo

Se Supremo viene aggiornato, il formato del `settings.dat` potrebbe
cambiare. In quel caso riesegui `INIZIALIZZA.bat` per rigenerare
i profili con la nuova versione dell'eseguibile.
