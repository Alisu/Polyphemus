helpers
launchTargetRunning: aScript

	"The edition's target image, as downloaded, running aScript on this VM, as the observee user
	under sudo (observeeUser), from a directory of its own; its pid."

	| directory script pidFile command |
	directory := PolyphemusEdition current scratch / 'mac-target'.
	directory ensureDeleteAll; ensureCreateDirectory.
	script := directory / 'target.st'.
	script writeStreamDo: [ :s | s nextPutAll: aScript ].
	pidFile := directory / 'pid'.
	self giveToTheObservee: directory.
	command := '"' , Smalltalk vm fullPath , '" --headless "' , PharoImageAccessor pathToTargetImage
		, '" --no-default-preferences st "' , script fullName , '" >/dev/null 2>&1 & echo $! > "' , pidFile fullName , '"'.
	LibC system: (self observeeUser
			 ifNil: [ 'sh -c ''' , command , '''' ]
			 ifNotNil: [ :user | 'sudo -H -u ' , user , ' sh -c ''' , command , '''' ]).
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forSeconds: 3) wait.
	^ pidFile contents trimBoth asNumber
