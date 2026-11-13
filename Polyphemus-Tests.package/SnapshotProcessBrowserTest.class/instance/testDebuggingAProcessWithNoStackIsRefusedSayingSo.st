tests
testDebuggingAProcessWithNoStackIsRefusedSayingSo

	"#183: no activation to start a session at was an empty collection's error; it says so now."

	self
		should: [ Polyphemus sessionOn: memory reifiedNilObject in: memory ]
		raise: NotInTheReading