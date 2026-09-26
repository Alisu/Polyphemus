baselines
postLoad

	"Refuse a host the edition is not made for, by name. Then open a browser and a playground,
	where there is a screen: a headless load (scripts, CI) has no world to open them in."

	| browser playground |
	(Smalltalk at: #PolyphemusEdition) current checkHost.
	Smalltalk isHeadless ifTrue: [ ^ self ].
	browser := ToolRegistry new openClassBrowser.
	browser packageView filterField updateTextWith: 'Polyphemus'.
	browser owner tileLeft.
	playground := StPlayground openContents: self defaultPlayground.
	playground window tileTopRight
