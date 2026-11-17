tools
census: someArguments

	| lines |
	lines := (self imageAt: someArguments) census lines first: (self top: someArguments).
	^ self
		  text: (self table: lines)
		  structured: (Dictionary new at: 'classes' put: (self rows: lines); yourself)
