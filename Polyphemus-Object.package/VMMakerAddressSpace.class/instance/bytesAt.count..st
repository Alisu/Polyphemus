reading
bytesAt: anAddress count: aCount

	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	^ [ (ByteArray new: aCount) collectWithIndex: [ :each :index |
		    manager unsignedByteAt: anAddress + index - 1 ] ] on: Error do: [ :e | nil ]
