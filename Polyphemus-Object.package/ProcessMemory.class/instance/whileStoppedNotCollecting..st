holding it still
whileStoppedNotCollecting: aBlock

	"aBlock's value, stopped at a moment no collection moves or marks objects (#163, risk 4): to
	write into objects that exist. Only the collector's state is read."

	^ self whileStoppedUnless: [ :variables | self class whyCollectingIn: variables ] do: aBlock
