running
setUp

	super setUp.
	process := ProcessMemoryReadInBlocks on: ((1 to: 16r20000) collect: [ :each | each \\ 256 ]) asByteArray at: 16r100000
