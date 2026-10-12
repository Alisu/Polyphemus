tools
census: someArguments

	| lines |
	lines := ((self imageAt: someArguments) at: #census) lines first: (self top: someArguments).
	^ self
		  text: (self table: lines)
		  structured: (Dictionary new at: 'classes' put: (self rows: lines); yourself)
