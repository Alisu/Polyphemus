building
overlaid: aDump

	"aDump as it reads, but for the words of #patches: a read of one, whole or of some of its
	bytes, answers what the patch says."

	| read |
	read := [ :address :size |
	        | word |
	        word := self patches at: (address bitClear: 7) ifAbsent: [ nil ].
	        word
		        ifNil: [ aDump unsignedAt: address size: size ]
		        ifNotNil: [ (word bitShift: (address bitAnd: 7) * -8) bitAnd: (1 bitShift: size * 8) - 1 ] ].
	^ (DefectiveReadDouble of: aDump)
		  when: #unsignedAt:size: answer: read;
		  when: #bytesAt:count: answer: [ :address :count |
			  (self patches keys anySatisfy: [ :each | each < (address + count) and: [ each + 8 > address ] ])
				  ifTrue: [ (0 to: count - 1) collect: [ :each | read value: address + each value: 1 ] as: ByteArray ]
				  ifFalse: [ aDump bytesAt: address count: count ] ];
		  yourself
