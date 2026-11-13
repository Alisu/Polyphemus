accessing
oopNumberOfArguments

	"From the header as the layout reads it: a jitted method's slot holds its CogMethod (#184)."

	^ memory interpreter argumentCountOfMethodHeader: (memory methodHeaderOf: address)