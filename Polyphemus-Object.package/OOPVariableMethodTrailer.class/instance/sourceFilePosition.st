accessing
sourceFilePosition

	"The bits above the file bit, less the one step the .changes took."

	| pointer high low |
	pointer := self sourcePointer.
	high := pointer // 16r2000000.
	low := pointer \\ 16r1000000.
	^ ((pointer bitAnd: 16r1000000) ~= 0 or: [ pointer < 16r1000000 ])
		  ifTrue: [ high * 16r1000000 + low ]
		  ifFalse: [ high - 1 * 16r1000000 + low ]
