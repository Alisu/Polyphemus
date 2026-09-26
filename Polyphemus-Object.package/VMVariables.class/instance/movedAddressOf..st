accessing
movedAddressOf: aName

	"VM 10 keeps old space's remembered set in a struct _VMRememberedSet it points to, readied
	for perm space: its fields, laid out as the 10.0.5 library's debug information says."

	| field |
	field := {
		         ('rememberedSetSize' -> 16).
		         ('rememberedSetLimit' -> 24).
		         ('rememberedSet' -> 32) } asDictionary at: aName ifAbsent: [ ^ nil ].
	(self library addressOf: 'fromOldSpaceRememberedSet') ifNil: [ ^ nil ].
	^ (self at: 'fromOldSpaceRememberedSet') + field
