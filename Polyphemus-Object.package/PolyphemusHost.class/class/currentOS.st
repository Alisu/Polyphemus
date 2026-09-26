private
currentOS

	Smalltalk os isWindows ifTrue: [ ^ 'Windows' ].
	Smalltalk os isMacOS ifTrue: [ ^ 'MacOS' ].
	(Smalltalk os version beginsWith: 'linux') ifTrue: [ ^ 'Linux' ].
	^ Smalltalk os platformName
