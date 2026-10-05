helpers
hostTempNamesOf: aFrame

	"How this host names the temporaries of a context running the same method: Context>>tempNames
	(its astScope's allTempNames) up to Pharo 13, and the method's debugInfo in Pharo 14, give
	these names in this order. CompiledMethod>>tempNames, gone in Pharo 14, lists them in another."

	^ (self hostMethodOf: aFrame) ast scope allTempNames asArray
