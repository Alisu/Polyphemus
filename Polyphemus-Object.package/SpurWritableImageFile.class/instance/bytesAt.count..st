bytes
bytesAt: anAddress count: aCount

	| offset |
	offset := self offsetOf: anAddress count: aCount.
	^ (bytes copyFrom: offset + 1 to: offset + aCount) asArray
