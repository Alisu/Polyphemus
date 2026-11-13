accessing
stringAt: aName

	"A text for a name it has, as VMVariables reads one; a name it lacks is refused."

	self addressOf: aName.
	^ 'a text'
