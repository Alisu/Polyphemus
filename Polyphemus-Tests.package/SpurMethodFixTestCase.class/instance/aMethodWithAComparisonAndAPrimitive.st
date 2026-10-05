helpers
aMethodWithAComparisonAndAPrimitive

	"A method of Integer or a subclass holding both a comparison and a primitive pragma, which
	this image compiles as the file has it."

	#( 'Integer' 'SmallInteger' 'LargePositiveInteger' 'LargeNegativeInteger' ) do: [ :name |
		| class |
		class := reading oopClassNamed: name.
		class reifiedMethods do: [ :each |
			| source |
			source := [ each getSourceFromFile ] on: Error do: [ :e | nil ].
			(source notNil and: [ (source includesSubstring: ' < ') and: [ source includesSubstring: '<primitive:' ] ])
				ifTrue: [
					| compiled |
					compiled := reading compileHostSource: source for: class.
					(compiled notNil and: [ reading host: compiled first matchesOop: each ]) ifTrue: [ ^ each ] ] ] ].
	^ nil
