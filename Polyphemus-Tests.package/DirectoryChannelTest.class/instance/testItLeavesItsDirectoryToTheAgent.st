tests
testItLeavesItsDirectoryToTheAgent

	"The agent makes the directory and says it serves; nothing is written there before. Made by
	an observer run as root, the directory was root's, and an observee run as its own user could
	not serve in it (#90)."

	agent terminate.
	directory ensureDeleteAll.
	self
		should: [ channel ask: '3 + 4' within: 200 milliSeconds ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'nothing was serving') ].
	self deny: directory exists
