helpers
aMethodWithAComparison

	"A method of Integer holding a comparison, which this image compiles as the file has it."

	^ (reading oopClassNamed: 'Integer') reifiedMethods
		  detect: [ :each |
			  | source |
			  source := [ each getSourceFromFile ] on: Error do: [ :e | nil ].
			  source notNil and: [
				  (source includesSubstring: ' < ') and: [
					  | compiled |
					  compiled := reading
						              compileHostSource: source
						              for: (reading oopClassNamed: 'Integer').
					  compiled notNil and: [ reading host: compiled first matchesOop: each ] ] ] ]
		  ifNone: [ nil ]
