naming
functionAt: aPc in: aMappedFile among: someMappedFiles

	"Through the file's own symbols, relative to where it was loaded: the start of its mapping
	at offset 0. nil when the file is not mapped from its start, is not there, or is no library
	this reads."

	| base |
	base := (someMappedFiles
		         detect: [ :each | each path = aMappedFile path and: [ each fileOffset = 0 ] ]
		         ifNone: [ ^ nil ]) start.
	^ [ (ElfSharedObject on: aMappedFile path) nameOfAddress: aPc - base ]
		  on: FileException , PolyphemusError
		  do: [ :unread | nil ]
