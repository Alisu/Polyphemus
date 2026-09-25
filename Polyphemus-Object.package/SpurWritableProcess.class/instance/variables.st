accessing
variables

	"The machine's own variables, where it keeps its eden and its remembered set."

	^ variables ifNil: [ variables := VMVariables on: process ]
