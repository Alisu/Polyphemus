testing
isAName: aString

	"Letters, digits and underscores, not starting with a digit: a class or a unary selector."

	^ aString notEmpty and: [
		  aString first isDigit not and: [
			  aString allSatisfy: [ :each | each isAlphaNumeric or: [ each = $_ ] ] ] ]