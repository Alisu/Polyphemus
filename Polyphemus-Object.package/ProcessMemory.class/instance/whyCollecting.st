testing
whyCollecting

	"Why its heap may not read whole this moment, stopped: a collection under way. nil when
	none, or when its VM does not say (#173)."

	^ VMVariables whereTheVMSays: [ self class whyCollectingIn: (VMVariables on: self) ]
