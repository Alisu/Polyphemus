accessing
addressOf: aName

	"The value of a symbol, relative to where the file is loaded; nil if it has none."

	^ self symbols at: aName ifAbsent: [ nil ]
