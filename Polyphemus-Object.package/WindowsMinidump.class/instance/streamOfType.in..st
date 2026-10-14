initialization
streamOfType: aType in: aHeader

	"Where the first stream of this type starts in the file, from the directory the header points
	to; nil if there is none."

	| directory |
	directory := self
		             bytesAtOffset: (self unsignedFrom: aHeader at: 13 size: 4)
		             count: 12 * (self unsignedFrom: aHeader at: 9 size: 4).
	1 to: directory size by: 12 do: [ :at |
		(self unsignedFrom: directory at: at size: 4) = aType ifTrue: [
			^ self unsignedFrom: directory at: at + 8 size: 4 ] ].
	^ nil
