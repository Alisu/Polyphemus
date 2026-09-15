building a heap
aFewObjects

	"nil, true and false as the first three, then a handful including one large enough to need
	an overflow header."

	^ {
		  #( 1 0 0 ).
		  #( 2 0 0 ).
		  #( 3 0 0 ).
		  #( 17 1 2 ).
		  #( 18 2 5 ).
		  #( 19 16 3 ).
		  #( 20 2 300 ).
		  #( 21 1 1 ) }
