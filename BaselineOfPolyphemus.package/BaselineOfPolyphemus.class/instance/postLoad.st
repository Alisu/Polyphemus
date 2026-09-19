baselines
postLoad

	"Open a browser and a playground on what was loaded, where there is a screen. A headless
	load (scripts, CI) has no world, and opening one there made the load fail."

	| browser playground |
	Smalltalk isHeadless ifTrue: [ ^ self ].
	browser := ToolRegistry new openClassBrowser.
	browser packageView filterField updateTextWith: 'Polyphemus'.
	browser owner tileLeft.
	playground := StPlayground openContents: self defaultPlayground.
	playground window tileTopRight
