tools
table: someLines

	^ String lf join: (someLines collect: [ :each |
			   each name , '  ' , each count printString , ' objects  ' , each bytes printString , ' bytes' ])
