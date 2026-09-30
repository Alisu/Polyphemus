drawing
rulerLabels

	"Row -> the first address it shows, every rulerRows rows."

	^ (0 to: self geometry height - 1 by: self class rulerRows) collect: [ :row |
		  row -> ('16r' , (self geometry addressAt: 0 @ row) printStringHex) ]
