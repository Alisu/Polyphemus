accessing
movedAddressOf: aName

	"Where VM 10 moved a variable: into a struct it points to, laid out as the 10.0.5 library's
	debug information says -- old space's remembered set, and the memory map of its spaces."

	| field |
	field := {
		         ('rememberedSetSize' -> ('fromOldSpaceRememberedSet' -> 16)).
		         ('rememberedSetLimit' -> ('fromOldSpaceRememberedSet' -> 24)).
		         ('rememberedSet' -> ('fromOldSpaceRememberedSet' -> 32)).
		         ('oldSpaceStart' -> ('memoryMap' -> 0)).
		         ('endOfMemory' -> ('memoryMap' -> 8)).
		         ('newSpaceStart' -> ('memoryMap' -> 16)).
		         ('newSpaceEnd' -> ('memoryMap' -> 24)).
		         ('oldSpaceMask' -> ('memoryMap' -> 80)).
		         ('codeZoneStart' -> ('memoryMap' -> 96)).
		         ('codeZoneEnd' -> ('memoryMap' -> 104)).
		         ('spaceMaskToUse' -> ('memoryMap' -> 144)).
		         ('permSpaceMask' -> ('memoryMap' -> 152)).
		         ('newSpaceMask' -> ('memoryMap' -> 160)) } asDictionary
		         at: aName
		         ifAbsent: [ ^ nil ].
	(self library addressOf: field key) ifNil: [ ^ nil ].
	^ (self at: field key) + field value
