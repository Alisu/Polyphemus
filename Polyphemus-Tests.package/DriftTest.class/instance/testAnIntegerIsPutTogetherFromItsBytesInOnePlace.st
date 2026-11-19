tests
testAnIntegerIsPutTogetherFromItsBytesInOnePlace

	"#212: eight methods each had the loop that reads a little endian integer, and four the one
	that writes it. LittleEndian has both; no other method shifts bytes into an integer, or out."

	| found |
	found := OrderedCollection new.
	PolyphemusTestCase methodsOfPolyphemusDo: [ :method |
		| source |
		source := method sourceCode.
		(#( 'bitShift: 8) +' '* 256 +' '* -8)' ) anySatisfy: [ :each | source includesSubstring: each ]) ifTrue: [
			found add: method methodClass name , '>>' , method selector ] ].
	self
		assert: found asArray sort
		equals: #( 'LittleEndian class>>bytesOf:size:' 'LittleEndian class>>unsignedIn:from:size:' )
