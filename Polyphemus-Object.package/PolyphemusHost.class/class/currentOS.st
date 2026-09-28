private
currentOS

	OSPlatform current isWindows ifTrue: [ ^ 'Windows' ].
	OSPlatform current isMacOS ifTrue: [ ^ 'MacOS' ].
	(OSPlatform current version beginsWith: 'linux') ifTrue: [ ^ 'Linux' ].
	^ OSPlatform current platformName
