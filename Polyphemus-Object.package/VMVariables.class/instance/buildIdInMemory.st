accessing
buildIdInMemory

	"The build-id of the library as loaded: its program headers are in its first page, and a
	note segment's address is relative to where it was loaded."

	| header table |
	header := (memory bytesAt: self base count: 64) ifNil: [ ^ nil ].
	table := (memory
		          bytesAt: self base + ((ElfNote unsignedFrom: header at: 16r20 + 1 size: 8))
		          count: ((ElfNote unsignedFrom: header at: 16r38 + 1 size: 2)) * 56) ifNil: [ ^ nil ].
	1 to: table size by: 56 do: [ :at |
		((ElfNote unsignedFrom: table at: at size: 4)) = 4 ifTrue: [
			(memory
				 bytesAt: self base + ((ElfNote unsignedFrom: table at: at + 16 size: 8))
				 count: ((ElfNote unsignedFrom: table at: at + 32 size: 8))) ifNotNil: [ :notes |
				(ElfNote buildIdIn: notes) ifNotNil: [ :id | ^ id ] ] ] ].
	^ nil
