naming
tempNamesOf: anActivation

	"Every name in scope in this activation, arguments included."

	^ (self astScopeOf: anActivation) allTempNames
