tests
testItFindsTheSpecialObjectsArray

	"Nothing in a dump points at the special objects array -- the VM holds it in a variable,
	and the image header a snapshot writes it into is not part of the memory. It is found by
	its contents instead: the only object whose first three slots are the heap own nil, false
	and true."

	| base space found other |
	base := self baseAddress.
	other := base + 48.
	space := self spaceFor: {
			         #( 3075 0 0 ).
			         #( 3077 0 0 ).
			         #( 3079 0 0 ).
			         { 18. 2. 3. { 16r55555555. base. base + 16 } }.
			         { 18. 2. 5. { base. base + 16. base + 32. 0. 0 } } }.

	found := (SpurHeapScanner on: space)
		         specialObjectsArrayFrom: base
		         upTo: base + space size.

	"the fourth object holds the same oops in the wrong places, and is not it"
	self assert: found equals: other + 32
