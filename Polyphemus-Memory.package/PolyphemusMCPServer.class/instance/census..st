tools
census: someArguments

	| lines |
	lines := ((self imageAt: someArguments) at: #census ifAbsent: [ self error: 'census reads image files; this handle is a core' ]) lines first: (self top: someArguments).
	^ self
		  text: (self table: lines)
		  structured: (Dictionary new at: 'classes' put: (self rows: lines); yourself)
