baselines
postLoad

	"Open a browser and a playground on what was just loaded -- where there is a screen to
	open them on. A headless load, which is how scripts and continuous integration load
	things, has no world, and opening a browser there was one more way for the load to
	fail after everything had actually loaded."

	| browser playground |
	Smalltalk isHeadless ifTrue: [ ^ self ].
	browser := ToolRegistry new openClassBrowser.
	browser packageView filterField updateTextWith: 'Polyphemus'.
	browser owner tileLeft.
	playground := StPlayground openContents: self defaultPlayground.
	playground window tileTopRight
