tools
letGo: someArguments

	"The held image runs on, and its handle is forgotten."

	^ self endTheHoldOf: someArguments by: [ :session | session letTheImageGo ] saying: 'Let go: the image runs on.'
