tests
testAMethodNothingSendsSelectsTheTestsOfItsClass

	"Nothing sends the MCP server's tools by name: a request names them, at run time. A method
	nothing sends is reached that way, so the tests referring to its class stand for its senders."

	self assert: ((self selectedFor: #( 'PolyphemusMCPServer nameOfProcess:' )) includes: #PolyphemusMCPProcessToolsTest)
