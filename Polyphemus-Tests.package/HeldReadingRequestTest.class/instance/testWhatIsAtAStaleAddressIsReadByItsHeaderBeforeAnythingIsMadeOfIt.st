tests
testWhatIsAtAStaleAddressIsReadByItsHeaderBeforeAnythingIsMadeOfIt

	"#212: after a collection the address a held process had may hold anything. It was made an
	object of, and any error at all taken for 'not there'. Its header is read first, from the
	copy: only an object of that hash and of Process's class is made, and a defect then shows."

	| held headerOf heap dumped process reading made |
	held := HeldReading new.
	held instVarNamed: 'hash' put: 77.
	headerOf := [ :hash :classIndex | LittleEndian bytesOf: classIndex + (1 bitShift: 24) + (hash bitShift: 32) + (5 bitShift: 56) size: 8 ].
	heap := (headerOf value: 77 value: 55) , (ByteArray new: 40) , (headerOf value: 12 value: 55) , (ByteArray new: 40)
	        , (headerOf value: 77 value: 9) , (ByteArray new: 40).
	dumped := (DefectiveReadDouble of: Object new)
		          when: #raw answer: [
			          (DefectiveReadDouble of: Object new)
				          when: #scanner answer: [ SpurHeapScanner on: (ByteArrayAddressSpace on: heap at: 16r1000) ];
				          yourself ];
		          yourself.
	held instVarNamed: 'dumped' put: dumped.
	process := (DefectiveReadDouble of: Object new)
		           when: #isObjectOop answer: [ true ];
		           when: #oopHash answer: [ 77 ];
		           when: #oopClassName answer: [ 'Process' ];
		           when: #address answer: [ 16r1000 ];
		           yourself.
	made := OrderedCollection new.
	reading := (DefectiveReadDouble of: Object new)
		           when: #oopClassNamed: answer: [ :name | (DefectiveReadDouble of: Object new) when: #oopHash answer: [ 55 ]; yourself ];
		           when: #reifyOop: answer: [ :address | made add: address. process ];
		           when: #runnableProcesses answer: [ { process } ];
		           yourself.
	#( 16r1030 16r1060 16r9000 ) do: [ :stale |
		held instVarNamed: 'address' put: stale.
		self assert: (held heldIn: reading) identicalTo: process.
		self assert: made isEmpty description: 'something was made of what is at ' , stale printString ].
	held instVarNamed: 'address' put: 16r1000.
	self assert: (held heldIn: reading) identicalTo: process.
	self assert: made asArray equals: #( 16r1000 ).
	reading when: #reifyOop: answer: [ :address | 1 / 0 ].
	self should: [ held heldIn: reading ] raise: ZeroDivide
