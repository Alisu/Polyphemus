tools
top: someArguments

	^ (someArguments at: 'top' ifAbsent: [ 20 ]) max: 1
