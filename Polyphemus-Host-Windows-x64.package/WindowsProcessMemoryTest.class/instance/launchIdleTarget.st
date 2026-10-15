helpers
launchIdleTarget

	"The edition's target image on this VM, idle for ten minutes (the test ends it); its pid,
	from PowerShell: cmd.exe, which LibC system: runs, says no pid of what it starts."

	| scratch script launcher pidFile |
	scratch := PolyphemusEdition current scratch.
	script := scratch / 'win-idle.st'.
	script ensureDelete; writeStreamDo: [ :s | s nextPutAll: '(Delay forSeconds: 600) wait. Smalltalk exitSuccess' ].
	pidFile := scratch / 'win-idle.pid'.
	pidFile ensureDelete.
	launcher := scratch / 'win-launch.ps1'.
	launcher ensureDelete; writeStreamDo: [ :s |
		s
			nextPutAll: '$p = Start-Process -PassThru -WindowStyle Hidden -FilePath ''';
			nextPutAll: Smalltalk vm fullPath;
			nextPutAll: ''' -ArgumentList @(''--headless'', ''';
			nextPutAll: PharoImageAccessor pathToTargetImage;
			nextPutAll: ''', ''--no-default-preferences'', ''st'', ''';
			nextPutAll: script fullName;
			nextPutAll: ''')';
			nextPut: Character lf;
			nextPutAll: 'Set-Content -Encoding ascii -Path ''';
			nextPutAll: pidFile fullName;
			nextPutAll: ''' -Value $p.Id' ].
	LibC system: 'powershell -NoProfile -ExecutionPolicy Bypass -File "' , launcher fullName , '"'.
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forSeconds: 5) wait.
	^ pidFile contents trimBoth asNumber
