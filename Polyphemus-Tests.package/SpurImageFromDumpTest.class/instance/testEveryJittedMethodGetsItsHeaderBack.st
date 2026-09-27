tests
testEveryJittedMethodGetsItsHeaderBack

	"Cog keeps a jitted method's header in its CogMethod and puts the CogMethod's address
	where the header was. An image has no code zone, so each header goes back, as
	CogMethodZone>>freeMethod: does it at snapshot. More than 2000 jitted in the VM 9 dump,
	2000 in the VM 10 one."

	| file written |
	self assert: (self methodsWithACogMethodWhereTheirHeaderBelongsIn: raw) >= 1000.

	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.
	self assert: (self methodsWithACogMethodWhereTheirHeaderBelongsIn: written) equals: 0.
	file close
