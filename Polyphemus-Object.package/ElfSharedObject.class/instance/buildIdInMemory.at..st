accessing
buildIdInMemory: aMemory at: aBase

	"The build-id of the library as loaded: its program headers are in its first page, and a
	note segment's address is relative to where it was loaded."

	| header table |
	header := (aMemory bytesAt: aBase count: 64) ifNil: [ ^ nil ].
	table := (aMemory
		          bytesAt: aBase + ((ElfNote unsignedFrom: header at: 16r20 + 1 size: 8))
		          count: ((ElfNote unsignedFrom: header at: 16r38 + 1 size: 2)) * 56) ifNil: [ ^ nil ].
	1 to: table size by: 56 do: [ :at |
		((ElfNote unsignedFrom: table at: at size: 4)) = 4 ifTrue: [
			(aMemory
				 bytesAt: aBase + ((ElfNote unsignedFrom: table at: at + 16 size: 8))
				 count: ((ElfNote unsignedFrom: table at: at + 32 size: 8))) ifNotNil: [ :notes |
				(ElfNote buildIdIn: notes) ifNotNil: [ :id | ^ id ] ] ] ].
	^ nil
