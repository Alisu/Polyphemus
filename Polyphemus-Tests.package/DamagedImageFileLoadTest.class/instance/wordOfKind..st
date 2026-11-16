damaging
wordOfKind: aSymbol

	"The word written, by the matrix's name for it; the last two are blocks, given the distance
	between the reading's addresses and the file's: the special objects array, and past the file."

	| array |
	array := clean reifiedSpecialObjectArray address.
	^ (Dictionary new
		   at: #zero put: 0;
		   at: #tagged put: 16r29;
		   at: #ones put: 16rFFFFFFFFFFFFFFFF;
		   at: #another put: [ :distance | array - distance ];
		   at: #past put: [ :distance | array - distance + 16r10000000 ];
		   yourself) at: aSymbol
