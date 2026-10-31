baselines
postLoad

	"Refuse a host the edition is not made for, by name; give Pharo back what an old load took
	(#143). Then a browser and a playground, where there is a screen to open them in."

	| browser playground |
	(Smalltalk at: #PolyphemusEdition) current checkHost.
	(Smalltalk at: #DebugSessionRepair) restore.
	Smalltalk isHeadless ifTrue: [ ^ self ].
	browser := ToolRegistry new openClassBrowser.
	browser packageView filterField updateTextWith: 'Polyphemus'.
	browser owner tileLeft.
	playground := StPlayground openContents: self defaultPlayground.
	playground window tileTopRight
