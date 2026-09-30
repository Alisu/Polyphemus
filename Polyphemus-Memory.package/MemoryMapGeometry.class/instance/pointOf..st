mapping
pointOf: anAddress

	| index |
	index := self pixelIndexOf: anAddress.
	^ index \\ width @ (index // width)
