asking
askingVMMaker: aBlock ifItFails: anotherBlock

	"aBlock's value, which sends to VMMaker's Cogit over the code zone of a dump, or to its loader
	over an image file. Whatever it raises, the value of anotherBlock, which may take what was raised."

	^ aBlock on: Error do: [ :raised | anotherBlock cull: raised ]
