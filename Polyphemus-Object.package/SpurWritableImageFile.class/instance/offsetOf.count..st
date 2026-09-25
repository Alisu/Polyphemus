private
offsetOf: anAddress count: aCount

	"Where in the copy the bytes at anAddress begin. Refused outside the heap the file holds."

	| segment |
	segment := file segmentHolding: anAddress.
	(segment notNil and: [ segment holdsAddress: anAddress + aCount - 1 ]) ifFalse: [
		^ self error: anAddress printStringHex , ' is not in this image''s heap' ].
	^ segment fileOffsetFor: anAddress
