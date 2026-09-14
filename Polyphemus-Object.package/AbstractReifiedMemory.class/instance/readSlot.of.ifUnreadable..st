reading damaged images
readSlot: anIndex of: anObject ifUnreadable: aBlock

	"A slot of a damaged image can hold something that is not an oop at all. Reifying it
	does not answer a broken object, it raises, and it raises from a long way down: the
	word is taken for an address, its header for a class index, and the failure surfaces
	as a key missing from a dictionary, naming a number that means nothing to whoever is
	reading the image.

	Everything that walks an image it did not write reads its slots through here. Stage
	one is for images that are damaged; raising in the middle of the walk says nothing
	about what is wrong, and hides everything that is still intact."

	^ [ anObject reifiedSlotAt: anIndex ] on: Error do: [ :e | aBlock value ]
