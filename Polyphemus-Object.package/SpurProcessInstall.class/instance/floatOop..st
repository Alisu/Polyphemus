memory
floatOop: aFloat

	"Not yet: this format holds most floats in a word of their own, and working out which
	needs the machine's own encoding."

	^ self error: 'a float in new code is not put into a running image yet'
