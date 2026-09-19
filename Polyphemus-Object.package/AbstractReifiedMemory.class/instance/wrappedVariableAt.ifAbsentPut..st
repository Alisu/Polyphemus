globals
wrappedVariableAt: aKey ifAbsentPut: aBlock

	"The wrapper for a variable of the image being read, kept so that one name is always one
	object; a fresh wrapper per lookup shifts literal indexes."

	^ self rememberedAt: aKey ifAbsentPut: aBlock
