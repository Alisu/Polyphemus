bytes
storeBytes: aByteArray at: anAddress

	| offset |
	offset := self offsetOf: anAddress count: aByteArray size.
	bytes replaceFrom: offset + 1 to: offset + aByteArray size with: aByteArray startingAt: 1
