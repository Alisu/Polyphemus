signalling
signalFor: aKey

	"Refuse what refusals names aKey, telling the user why."

	^ self new signal: (self refusals at: aKey) value
