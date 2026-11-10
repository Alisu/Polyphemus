reading
bridgeSpanFrom: aWord

	"The bytes a segment bridge spans, from the word 16 bytes before its segment's end: a long
	bridge's count word, or a short bridge's own header, which spans nothing."

	^ (aWord bitShift: -56) = 0
		  ifTrue: [ 0 ]
		  ifFalse: [ 8 * (self countInOverflowWord: aWord) ]
