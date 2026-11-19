painting
paintFrom: aStart upTo: aLimit

	"Every object from aStart to aLimit; where the walk cannot go on, or is refused, that place is
	unreadable. A defect of ours is no such place: it shows (#212)."

	| address |
	address := aStart.
	[ address < aLimit ] whileTrue: [
		| header size |
		header := [ scanner headerAt: address ] on: PolyphemusError do: [ :refusal | nil ].
		size := header ifNotNil: [ [ scanner bytesOfObjectAt: address ] on: PolyphemusError do: [ :refusal | nil ] ].
		size ifNil: [
			self paint: #unreadable from: address size: 1.
			^ self closeOpenPixel ].
		self paint: (self categoryOfHeader: header) from: address size: size.
		address := ([ scanner objectAfter: address ] on: PolyphemusError do: [ :refusal | nil ]) ifNil: [ address + size ] ].
	self closeOpenPixel
