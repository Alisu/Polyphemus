helpers
launchTargetRunning: aScript

	"The edition's target image, as downloaded, running aScript on this VM; its pid."

	| scratch script pidFile |
	scratch := PolyphemusEdition current scratch.
	script := scratch / 'mac-target.st'.
	script ensureDelete.
	script writeStreamDo: [ :s | s nextPutAll: aScript ].
	pidFile := scratch / 'mac-target.pid'.
	pidFile ensureDelete.
	LibC system: 'sh -c ''"' , Smalltalk vm fullPath , '" --headless "' , PharoImageAccessor pathToTargetImage
		, '" --no-default-preferences st "' , script fullName , '" >/dev/null 2>&1 & echo $! > "' , pidFile fullName , '"'''.
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forSeconds: 3) wait.
	^ pidFile contents trimBoth asNumber
