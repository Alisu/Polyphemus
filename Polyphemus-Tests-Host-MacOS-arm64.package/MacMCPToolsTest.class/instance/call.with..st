helpers
call: aToolName with: someArguments

	"A tools/call to a fresh server, as an MCP client sends it (PolyphemusMCPLiveToolsTest)."

	^ PolyphemusMCPLiveToolsTest new call: aToolName with: someArguments on: PolyphemusMCPServer new
