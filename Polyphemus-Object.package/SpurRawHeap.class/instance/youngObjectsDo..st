young objects
youngObjectsDo: aBlock

	"Every object of new space, as far as the walk gets."

	| address stop |
	self youngSpaceStart ifNil: [ ^ self ].
	stop := self youngObjectsWalk stoppedAt.
	address := self youngSpaceStart.
	[ address notNil and: [ address < stop ] ] whileTrue: [
		(self scanner isFreeChunkAt: address) ifFalse: [ aBlock value: address ].
		address := self scanner objectAfter: address ]
