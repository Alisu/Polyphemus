accessing
sourceFileIndex

	"Up to Pharo 11 the bit 16r1000000 names the .sources, any higher pointer the .changes."

	| pointer |
	pointer := self sourcePointer.
	(pointer bitAnd: 16r1000000) ~= 0 ifTrue: [ ^ 1 ].
	^ pointer >= 16r1000000
		  ifTrue: [ 2 ]
		  ifFalse: [ 0 ]
