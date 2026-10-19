helpers
drawWindowOf: aPresenter

	"Draw aPresenter's window on a canvas of its own, in this process: what a screen would show,
	with every error it raises raised here."

	aPresenter withWindowDo: [ :window |
		| morph |
		morph := window adapter widget.
		morph fullDrawOn: (Form extent: morph extent depth: 32) getCanvas ]
