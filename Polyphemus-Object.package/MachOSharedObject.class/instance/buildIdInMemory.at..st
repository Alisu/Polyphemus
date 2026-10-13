accessing
buildIdInMemory: aMemory at: aBase

	"The UUID in the header as loaded at aBase: its load commands follow it in the first page."

	| header |
	header := (aMemory bytesAt: aBase count: 32) ifNil: [ ^ nil ].
	^ self uuidIn: ((aMemory bytesAt: aBase count: 32 + (self unsignedIn: header at: 20 size: 4)) ifNil: [ ^ nil ])
