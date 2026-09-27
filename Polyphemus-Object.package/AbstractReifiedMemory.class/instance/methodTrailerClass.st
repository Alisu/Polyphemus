naming
methodTrailerClass

	"How the image read writes its methods' trailers: five fixed bytes from Pharo 12 on -- its
	CompiledMethod answers trailerSize -- and Pharo's variable ones before, Candle's too."

	^ self rememberedAt: 'methodTrailerClass' ifAbsentPut: [
		  ([ (self oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ]
			   on: Error
			   do: [ :e | nil ])
			  ifNil: [ OOPVariableMethodTrailer ]
			  ifNotNil: [ OOPFixedMethodTrailer ] ]
