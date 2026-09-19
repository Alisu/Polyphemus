young objects
youngObjectsByShapeDo: aBlock

	"Every object of new space, as far as the walk by shape gets: to the end of past space's
	survivors, never into eden (#8)."

	| address stop |
	self youngSpaceStart ifNil: [ ^ self ].
	stop := self youngObjectsWalk stoppedAt.
	address := self youngSpaceStart.
	[ address notNil and: [ address < stop ] ] whileTrue: [
		(self scanner isFreeChunkAt: address) ifFalse: [ aBlock value: address ].
		address := self scanner objectAfter: address ]
