editing
storeWord: aWord at: anAddress

	"Write one little endian word where the heap has anAddress. Refused outside the heap the
	file holds."

	| segment offset |
	segment := file segmentHolding: anAddress.
	(segment notNil and: [ segment holdsAddress: anAddress + 7 ]) ifFalse: [
		^ self error: anAddress printStringHex , ' is not in this image''s heap' ].
	offset := segment fileOffsetFor: anAddress.
	0 to: 7 do: [ :index |
		bytes at: offset + index + 1 put: ((aWord bitShift: index * -8) bitAnd: 255) ]
