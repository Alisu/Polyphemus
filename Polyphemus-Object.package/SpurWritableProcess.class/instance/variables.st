accessing
variables

	"The machine's own variables, where it keeps its new space and its remembered set."

	^ variables ifNil: [ variables := VMVariables on: process ]
