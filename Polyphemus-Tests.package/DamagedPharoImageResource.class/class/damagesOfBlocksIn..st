damages
damagesOfBlocksIn: aCleanReading

	"In the blocks of two methods of Set, a class no other damage is on (#208): the last literal
	of collect:'s block, the method it is in, a tagged word; the first of rehash's zeroed."

	| blockOf |
	blockOf := [ :name |
	           ((aCleanReading oopClassNamed: 'Set') methodNamed: name ifAbsent: [ self error: 'no Set>>' , name ])
		           allCompiledBlocks first ].
	^ {
		  ((DamagedCandleImage slot: (blockOf value: 'collect:') numberOfLiterals + 1 of: (blockOf value: 'collect:'))
		   -> self taggedWord).
		  ((DamagedCandleImage slot: 2 of: (blockOf value: 'rehash')) -> 0) }
