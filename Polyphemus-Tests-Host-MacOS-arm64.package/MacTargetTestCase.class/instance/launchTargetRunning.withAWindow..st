helpers
launchTargetRunning: aScript withAWindow: aBoolean

	"As launchTargetRunning:, its window open if aBoolean, as a user starts one (pharo-ui): in
	that user's graphical session (launchctl asuser), which sudo alone does not reach."

	| directory script pidFile command |
	directory := PolyphemusEdition current scratch / 'mac-target'.
	directory ensureDeleteAll; ensureCreateDirectory.
	script := directory / 'target.st'.
	script writeStreamDo: [ :s | s nextPutAll: aScript ].
	pidFile := directory / 'pid'.
	self giveToTheObservee: directory.
	command := '"' , Smalltalk vm fullPath , '"' , (aBoolean ifTrue: [ '' ] ifFalse: [ ' --headless' ]) , ' "' , PharoImageAccessor pathToTargetImage
		, '" --no-default-preferences st "' , script fullName , '" >/dev/null 2>&1 & echo $! > "' , pidFile fullName , '"'.
	LibC system: (self observeeUser
			 ifNil: [ 'sh -c ''' , command , '''' ]
			 ifNotNil: [ :user |
				 (aBoolean ifTrue: [ 'launchctl asuser "$(id -u ' , user , ')" ' ] ifFalse: [ '' ])
				 , 'sudo -H -u ' , user , ' sh -c ''' , command , '''' ]).
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forSeconds: 3) wait.
	^ pidFile contents trimBoth asNumber
