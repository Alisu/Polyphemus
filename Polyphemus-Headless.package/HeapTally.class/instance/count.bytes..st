taking
count: aKey bytes: aNumber

	"One more object under aKey, of so many bytes."

	counts at: aKey put: (counts at: aKey ifAbsent: [ 0 ]) + 1.
	sizes at: aKey put: (sizes at: aKey ifAbsent: [ 0 ]) + aNumber
