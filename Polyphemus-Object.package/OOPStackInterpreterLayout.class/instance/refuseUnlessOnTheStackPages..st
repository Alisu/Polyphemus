reading
refuseUnlessOnTheStackPages: anAddress

	(anAddress isInteger and: [
		 memory interpreter stackPages pages anySatisfy: [ :each |
			 anAddress between: each lastAddress and: each baseAddress + memory wordSize ] ]) ifFalse: [
		NotInTheReading signal: 'the address '
			, (anAddress isInteger ifTrue: [ anAddress printStringRadix: 16 ] ifFalse: [ anAddress printString ])
			, ' is on no stack page' ]
