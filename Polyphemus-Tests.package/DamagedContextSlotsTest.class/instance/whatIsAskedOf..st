running
whatIsAskedOf: aContext

	"What a context is asked of its own slots, each named: these answer, or refuse by an error
	of Polyphemus's own."

	^ #( #sender #pc #stackp #compiledCode #homeMethod #isDead #receiver #closureOrNil #isBlockContext
	     #outerContext #home #method #methodClass ) collect: [ :each | each -> [ aContext perform: each ] ]
