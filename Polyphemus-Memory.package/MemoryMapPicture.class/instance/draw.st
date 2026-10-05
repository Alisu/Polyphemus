drawing
draw

	| last bottom picture canvas font counts |
	last := sections size.
	bottom := (self originOf: last) y + (self geometryOf: last) height.
	picture := Form
		           extent: 150 + ((1 to: last) inject: 0 into: [ :most :each | most max: (self geometryOf: each) width ]) + 20
			           @ (bottom + 80)
		           depth: 32.
	picture fillColor: Color white.
	canvas := picture getCanvas.
	font := TextStyle defaultFont.
	counts := Bag new.
	1 to: last do: [ :index |
		| origin |
		origin := self originOf: index.
		(sections at: index) key ifNotNil: [ :label |
			canvas drawString: label at: origin x @ (origin y - 18) font: font color: Color black ].
		canvas drawImage: (self mapFormOf: index) at: origin.
		(self rulerLabelsOf: index) do: [ :each |
			| y |
			y := origin y + each key.
			canvas line: origin x - 6 @ y to: origin x - 1 @ y color: Color black.
			canvas drawString: each value at: 8 @ (y - 6) font: font color: Color black ].
		0 to: (self geometryOf: index) pixelCount - 1 do: [ :each |
			counts add: ((self painterOf: index) categoryOfPixel: each) ] ].
	MemoryMapPainter categories allButFirst withIndexDo: [ :category :index |
		| at |
		at := 150 + (index - 1 \\ 5 * 200) @ (bottom + 15 + (index - 1 // 5 * 22)).
		canvas fillRectangle: (at extent: 14 @ 14) color: (self class colourOf: category).
		canvas frameRectangle: (at extent: 14 @ 14) color: Color gray.
		canvas
			drawString: category , ' ' , (counts occurrencesOf: category) printString
			at: at + (20 @ 0)
			font: font
			color: Color black ].
	^ picture
