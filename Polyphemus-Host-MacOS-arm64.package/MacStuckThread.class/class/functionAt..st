naming
functionAt: anAddress

	"The library and function holding anAddress here, which names it in every process for the
	system's shared libraries, mapped at the same addresses in all. nil if in none."

	^ (self symbolAt: anAddress) ifNotNil: [ :symbol |
		  symbol value ifNil: [ symbol key ] ifNotNil: [ :name | symbol key , ', in ' , name ] ]
