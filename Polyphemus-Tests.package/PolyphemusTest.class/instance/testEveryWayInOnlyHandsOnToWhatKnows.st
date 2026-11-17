tests
testEveryWayInOnlyHandsOnToWhatKnows

	"#118: Polyphemus is where code starts, and nothing more: each of its messages is one
	statement that hands on to the object that knows, with no temporary to work in. What needs
	working out belongs to that object, or the class of the ways in grows into the tool itself."

	| working |
	working := (Polyphemus class selectors asSortedCollection select: [ :each |
		            | body |
		            body := (Polyphemus class >> each) ast body.
		            body statements size > 1 or: [ body temporaries notEmpty ] ]) asArray.
	self assert: working equals: #(  )
