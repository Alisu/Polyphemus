accessing
addressOf: aName

	"Its address relative to where the library is loaded, or nil."

	^ self symbols at: aName ifAbsent: [ nil ]
