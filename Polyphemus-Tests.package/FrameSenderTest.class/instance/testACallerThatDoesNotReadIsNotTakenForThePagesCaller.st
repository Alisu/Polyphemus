tests
testACallerThatDoesNotReadIsNotTakenForThePagesCaller

	"#118: any error reading the caller made #sender answer the page's caller, cutting the stack
	or skipping frames unseen. The error is let through."

	self should: [ FrameWithACallerThatDoesNotRead new sender ] raise: Error
