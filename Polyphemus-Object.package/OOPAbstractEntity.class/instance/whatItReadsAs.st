printing
whatItReadsAs

	"A few words for a refusal: the kind of thing read here and where. Nothing of the image is
	read to say it, as printing may: a refusal must not fail, or go round, on what it refuses."

	^ self class name , (address ifNil: [ '' ] ifNotNil: [ ' at ' , (address printStringRadix: 16) ])
