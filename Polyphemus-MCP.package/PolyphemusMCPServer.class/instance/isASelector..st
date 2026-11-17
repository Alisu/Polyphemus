testing
isASelector: aString

	"A unary, binary or keyword selector, spelled as it is with nothing around it."

	(self isAName: aString) ifTrue: [ ^ true ].
	(aString notEmpty and: [ aString allSatisfy: [ :each | '-+*/\<>=~@%&?,|' includes: each ] ]) ifTrue: [ ^ true ].
	^ aString notEmpty and: [
		  aString last = $: and: [
			  (aString substrings: ':') allSatisfy: [ :each | self isAName: each ] ] ]