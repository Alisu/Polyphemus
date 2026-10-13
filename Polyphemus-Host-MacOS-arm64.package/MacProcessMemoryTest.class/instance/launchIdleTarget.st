helpers
launchIdleTarget

	"The edition's target image, as downloaded, idle for a minute on this VM; its pid."

	| scratch idle pidFile |
	scratch := PolyphemusEdition current scratch.
	idle := scratch / 'mac-idle.st'.
	idle writeStreamDo: [ :s | s nextPutAll: '(Delay forSeconds: 60) wait. Smalltalk exitSuccess' ].
	pidFile := scratch / 'mac-idle.pid'.
	pidFile ensureDelete.
	LibC system: 'sh -c ''"' , Smalltalk vm fullPath , '" --headless "' , PharoImageAccessor pathToTargetImage
		, '" --no-default-preferences st "' , idle fullName , '" >/dev/null 2>&1 & echo $! > "' , pidFile fullName , '"'''.
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forSeconds: 3) wait.
	^ pidFile contents trimBoth asNumber
