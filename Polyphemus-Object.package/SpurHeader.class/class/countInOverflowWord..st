reading
countInOverflowWord: aWord

	"The slot count kept in the word before a header whose own count is 255."

	^ aWord bitAnd: (1 bitShift: 56) - 1
