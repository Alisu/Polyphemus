naming
functionAt: aPc in: aMappedFile among: someMappedFiles

	"Through the file's own symbols, relative to where it was loaded: the start of its mapping
	at offset 0. nil when the file cannot be read here."

	^ [ | base |
	  base := (someMappedFiles detect: [ :each | each path = aMappedFile path and: [ each fileOffset = 0 ] ]) start.
	  (ElfSharedObject on: aMappedFile path) nameOfAddress: aPc - base ]
		  on: Error
		  do: [ :e | nil ]
