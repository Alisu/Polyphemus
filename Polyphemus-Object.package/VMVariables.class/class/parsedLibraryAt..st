libraries
parsedLibraryAt: aPath

	"The VM library at aPath, parsed once for as long as its size and modification time stay
	the same (#135)."

	| file stamp entry |
	file := aPath asFileReference.
	stamp := { file size. file modificationTime }.
	Libraries ifNil: [ Libraries := Dictionary new ].
	entry := Libraries at: aPath ifAbsent: [ nil ].
	(entry notNil and: [ entry key = stamp ]) ifTrue: [ ^ entry value ].
	^ (Libraries at: aPath put: stamp -> (({
		      ('.dylib' -> MachOSharedObject).
		      ('.dll' -> PeSharedObject) }
		      detect: [ :each | aPath asLowercase endsWith: each key ]
		      ifNone: [ nil -> ElfSharedObject ]) value on: aPath)) value
