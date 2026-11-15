naming
methodTrailerClass

	"How the image read writes its methods' trailers: five fixed bytes from Pharo 12 on -- its
	CompiledMethod answers trailerSize -- and Pharo's variable ones before, Candle's too. Where
	its methods do not tell, taken for variable: a guess, right up to Pharo 11 (#118)."

	^ self rememberedAt: 'methodTrailerClass' ifAbsentPut: [
		  ([ (self oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ifAbsent: [ nil ] ]
			   on: PolyphemusError
			   do: [ :refusal | nil ])
			  ifNil: [ OOPVariableMethodTrailer ]
			  ifNotNil: [ OOPFixedMethodTrailer ] ]
