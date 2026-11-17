tests
testRunUntilTakesAMethodsNameAndNothingElse

	"#180: what it is given goes into source the held image evaluates. Anything but a class, an
	optional class, >> and a literal selector is refused, the image asked nothing."

	| handle asked |
	handle := self heldBy: UnaskedDouble new.
	#( 'Object >> #yourself. Smalltalk quit' 'Object >> #yourself) ast. (Smalltalk quit' 'Smalltalk quit'
	   'Object >> #at:put' 'Object>>yourself' '' ) do: [ :each |
		| result |
		result := self resultOf: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: each; yourself).
		self assert: (result at: 'isError') description: each.
		self assert: (((result at: 'content') first at: 'text') includesSubstring: 'Class >> #selector') ].
	asked := OrderedCollection new.
	handle := self heldBy: (self sessionNoting: asked).
	#( 'Object >> #yourself' 'Object class >> #new:' 'Integer>>#+' 'Dictionary >> #at:put:' ) do: [ :each |
		self resultOf: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: each; yourself) ].
	self
		assert: (asked collect: [ :each | each key ]) asArray
		equals: #( 'Object >> #yourself' 'Object class >> #new:' 'Integer>>#+' 'Dictionary >> #at:put:' )