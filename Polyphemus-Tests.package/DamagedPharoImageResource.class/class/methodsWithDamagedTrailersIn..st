building
methodsWithDamagedTrailersIn: someContexts

	"The methods of the twelfth and fourteenth contexts: the first gets a source pointer far past
	its file, the second a trailer saying it embeds two gigabytes of source."

	^ { (someContexts at: 12) homeMethod. (someContexts at: 14) homeMethod }
