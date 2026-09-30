painting
paintFrom: aStart upTo: aLimit

	"Every object from aStart to aLimit; where the walk cannot go on, that place is unreadable."

	| address |
	address := aStart.
	[ address < aLimit ] whileTrue: [
		| header size |
		header := [ scanner headerAt: address ] on: Error do: [ :e | nil ].
		size := header ifNotNil: [ [ scanner bytesOfObjectAt: address ] on: Error do: [ :e | nil ] ].
		size ifNil: [
			self paint: #unreadable from: address size: 1.
			^ self closeOpenPixel ].
		self paint: (self categoryOfHeader: header) from: address size: size.
		address := ([ scanner objectAfter: address ] on: Error do: [ :e | nil ]) ifNil: [ address + size ] ].
	self closeOpenPixel
