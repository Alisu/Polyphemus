accessing
directoryShared: aSharedDirectory else: anOwnDirectory

	"aSharedDirectory if this user can make it and a file in it (isWritable reads the owner's bits),
	else anOwnDirectory: one made before it was opened to all is its owner's helper to open."

	| probe made |
	probe := aSharedDirectory / ('.writable-' , UUID new asString).
	made := [
	        self madeAt: aSharedDirectory.
	        probe ensureCreateFile.
	        probe exists ] on: Error do: [ :error | false ].
	probe ensureDelete.
	^ made
		  ifTrue: [ aSharedDirectory ]
		  ifFalse: [ self madeAt: anOwnDirectory ]
