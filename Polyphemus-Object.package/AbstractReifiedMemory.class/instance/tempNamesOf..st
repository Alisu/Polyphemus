naming
tempNamesOf: anActivation

	"Every name in scope in this activation, arguments included -- none unless the code
	compiled here is the file's, since names and slots come from our own analysis (#6)."

	(self faithfulCodeOf: anActivation) ifNil: [ ^ #(  ) ].
	^ (self astScopeOf: anActivation) allTempNames
