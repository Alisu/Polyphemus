words
wordAt: anAddress put: aWord

	| bytes |
	bytes := ByteArray new: 8.
	1 to: 8 do: [ :index |
		bytes at: index put: ((aWord bitShift: index - 1 * -8) bitAnd: 255) ].
	^ self storeBytes: bytes at: anAddress
