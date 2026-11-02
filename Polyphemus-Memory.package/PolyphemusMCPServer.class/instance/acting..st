results
acting: aTool

	"A tool that changes a running VM, which a client may ask about before it runs (#128); undone
	by let_go, so not destructive."

	(aTool at: 'annotations')
		at: 'readOnlyHint' put: false;
		at: 'destructiveHint' put: false.
	^ aTool
