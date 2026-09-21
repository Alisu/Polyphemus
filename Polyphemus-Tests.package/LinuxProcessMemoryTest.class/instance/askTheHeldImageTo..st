helpers
askTheHeldImageTo: aSource

	"What the held image runs before it goes back to work. Its own compiler does it, which is
	how a method changed in place has its machine code discarded."

	(self spikeDirectory / 'do.st') writeStreamDo: [ :stream | stream nextPutAll: aSource ]
