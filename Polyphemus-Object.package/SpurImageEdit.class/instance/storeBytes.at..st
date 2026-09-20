editing
storeBytes: aByteArray at: anAddress

	"Write them where the heap has anAddress. Refused outside the heap the file holds."

	| segment offset |
	segment := file segmentHolding: anAddress.
	(segment notNil and: [ segment holdsAddress: anAddress + aByteArray size - 1 ]) ifFalse: [
		^ self error: anAddress printStringHex , ' is not in this image''s heap' ].
	offset := segment fileOffsetFor: anAddress.
	1 to: aByteArray size do: [ :index |
		bytes at: offset + index put: (aByteArray at: index) ]
