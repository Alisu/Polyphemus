drawing
draw

	| picture canvas font counts legend |
	picture := Form extent: self mapOrigin x + self geometry width + 20 @ (self mapOrigin y + self geometry height + 80) depth: 32.
	picture fillColor: Color white.
	canvas := picture getCanvas.
	canvas drawImage: self mapForm at: self mapOrigin.
	font := TextStyle defaultFont.
	self rulerLabels do: [ :each |
		| y |
		y := self mapOrigin y + each key.
		canvas line: self mapOrigin x - 6 @ y to: self mapOrigin x - 1 @ y color: Color black.
		canvas drawString: each value at: 8 @ (y - 6) font: font color: Color black ].
	counts := Bag new.
	0 to: self geometry pixelCount - 1 do: [ :index | counts add: (painter categoryOfPixel: index) ].
	legend := MemoryMapPainter categories allButFirst.
	legend withIndexDo: [ :category :index |
		| at |
		at := self mapOrigin x + (index - 1 \\ 5 * 200) @ (self mapOrigin y + self geometry height + 15 + (index - 1 // 5 * 22)).
		canvas fillRectangle: (at extent: 14 @ 14) color: (self class colourOf: category).
		canvas frameRectangle: (at extent: 14 @ 14) color: Color gray.
		canvas
			drawString: category , ' ' , (counts occurrencesOf: category) printString
			at: at + (20 @ 0)
			font: font
			color: Color black ].
	^ picture
