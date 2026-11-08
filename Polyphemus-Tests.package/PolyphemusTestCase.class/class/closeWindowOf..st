helpers
closeWindowOf: aPresenter

	"Closed by the UI process, which the scrolls Spec deferred to it would otherwise race (#31)."

	self inUIProcess: [ aPresenter window ifNotNil: [ :window | window close ] ]
