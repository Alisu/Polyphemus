initialization
streamOfType: aType in: aHeader

	"Where the first stream of this type starts in the file, from the directory the header points
	to; nil if there is none."

	| directory |
	directory := self
		             tableAtOffset: (LittleEndian unsignedIn: aHeader from: 13 size: 4)
		             count: 12 * (LittleEndian unsignedIn: aHeader from: 9 size: 4).
	1 to: directory size by: 12 do: [ :at |
		(LittleEndian unsignedIn: directory from: at size: 4) = aType ifTrue: [
			^ LittleEndian unsignedIn: directory from: at + 8 size: 4 ] ].
	^ nil
