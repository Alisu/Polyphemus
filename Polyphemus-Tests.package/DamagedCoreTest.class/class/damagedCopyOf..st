building
damagedCopyOf: aCoreFile

	"A copy of the core in this edition's scratch folder, each word of #damagesIn: written at
	the offset of its address in the file. Made anew for each run: a core is the setup's own."

	| clean space damages copy stream |
	clean := Polyphemus readCoreDump: aCoreFile fullName.
	space := clean vmLayout raw space.
	damages := (self damagesIn: clean) collect: [ :each |
		           ((space segmentHolding: each key) fileOffsetFor: each key) -> each value ].
	space close.
	copy := PolyphemusEdition current scratch / 'polyphemus-damaged.core'.
	copy ensureDelete.
	aCoreFile copyTo: copy.
	stream := (File named: copy fullName) writeStream.
	[
	damages do: [ :each |
		stream
			position: each key;
			nextPutAll: (each value asByteArrayOfSize: 8) reversed ] ] ensure: [
		stream
			flush;
			close ].
	^ copy
