tools
methodNameIn: someArguments

	"The method run_until is given. It goes into source the held image evaluates, so it is a
	class, class for its class side, >> and a literal selector, or it is refused (#180)."

	| method cut class selector |
	method := someArguments at: 'method' ifAbsent: [ nil ].
	method isString ifFalse: [ ^ ToolCallFailed signal: 'run_until needs a method, as Class >> #selector' ].
	cut := method indexOfSubCollection: '>>'.
	cut = 0 ifTrue: [ ^ ToolCallFailed signal: method printString , ' is no method as run_until takes one: Class >> #selector' ].
	class := (method first: cut - 1) substrings.
	selector := (method allButFirst: cut + 1) trimBoth.
	((class size between: 1 and: 2) and: [
		 (self isAName: class first) and: [
			 (class size = 1 or: [ class last = 'class' ]) and: [
				 selector notEmpty and: [ selector first = $# and: [ self isASelector: selector allButFirst ] ] ] ] ])
		ifFalse: [ ^ ToolCallFailed signal: method printString , ' is no method as run_until takes one: Class >> #selector' ].
	^ method