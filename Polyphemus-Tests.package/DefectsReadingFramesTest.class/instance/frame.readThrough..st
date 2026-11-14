running
frame: aFrame readThrough: aLayout

	"aFrame as it was read, asking that layout from now on."

	^ aFrame copy
		  memory: (self memoryReadThrough: aLayout);
		  yourself
