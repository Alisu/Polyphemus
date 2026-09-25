bytes
storeBytes: aByteArray at: anAddress

	aByteArray doWithIndex: [ :each :index | memory byteAt: anAddress + index - 1 put: each ]
