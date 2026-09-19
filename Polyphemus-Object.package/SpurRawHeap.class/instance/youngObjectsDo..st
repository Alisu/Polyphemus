young objects
youngObjectsDo: aBlock

	"Every live object of new space: past space's survivors, then eden up to where the VM
	allocates next, both read from the VM's variables. By shape when those cannot be read."

	| ranges |
	ranges := self liveYoungRanges ifNil: [ ^ self youngObjectsByShapeDo: aBlock ].
	ranges do: [ :range |
		| address |
		address := range key.
		[ address notNil and: [ address < range value ] ] whileTrue: [
			(self scanner isFreeChunkAt: address) ifFalse: [ aBlock value: address ].
			address := self scanner objectAfter: address ] ]
