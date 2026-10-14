reading
symbolEntriesIn: aTable count: aCount

	"The offsets of the symbol records, 18 bytes each, skipping the auxiliary records each says
	follow it."

	| entries index |
	entries := OrderedCollection new.
	index := 0.
	[ index < aCount ] whileTrue: [
		entries add: aTable + (18 * index).
		index := index + 1 + (self unsignedIn: self bytes at: aTable + (18 * index) + 17 size: 1) ].
	^ entries
