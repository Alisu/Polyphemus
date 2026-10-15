reading the map
regionsDo: aBlock

	"Each region of user space with its start, size, state and protection (VirtualQueryEx;
	MEMORY_BASIC_INFORMATION: base at 0, size at 24, state at 32, protection at 36)."

	| info address |
	info := self class pinned: 48.
	address := 0.
	[ address < 16r7FFFFFFF0000 and: [ (self class query: self handle at: address into: info size: 48) = 48 ] ]
		whileTrue: [
			| from bytes |
			from := info unsignedLongLongAt: 1.
			bytes := info unsignedLongLongAt: 25.
			aBlock value: from value: bytes value: (info unsignedLongAt: 33) value: (info unsignedLongAt: 37).
			address := from + bytes ]
