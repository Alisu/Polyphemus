tools
census: someArguments

	| lines |
	lines := (self imageAt: someArguments) census lines.
	lines := lines first: ((self top: someArguments) min: lines size).
	^ self
		  text: (self table: lines)
		  structured: (Dictionary new at: 'classes' put: (self rows: lines); yourself)
