testing
hasAReadableName

	"Whether its name is a string that reads: oopName answers a placeholder when it is not."

	^ [ self classNameObject isStringOop ] on: PolyphemusError do: [ :refusal | false ]
