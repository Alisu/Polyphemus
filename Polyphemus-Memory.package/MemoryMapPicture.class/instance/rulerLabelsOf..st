drawing
rulerLabelsOf: anIndex

	"Row -> the first address it shows, every rulerRows rows."

	| map |
	map := self geometryOf: anIndex.
	^ (0 to: map height - 1 by: self class rulerRows) collect: [ :row |
		  row -> ('16r' , (map addressAt: 0 @ row) printStringHex) ]
