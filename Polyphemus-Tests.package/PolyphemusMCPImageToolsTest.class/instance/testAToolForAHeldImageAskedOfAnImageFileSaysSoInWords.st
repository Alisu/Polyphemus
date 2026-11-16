tests
testAToolForAHeldImageAskedOfAnImageFileSaysSoInWords

	"#118: a handle was a dictionary, and a tool asked of a handle of another kind failed on a key
	it did not have. It says what the handle is and what the tool needs."

	| server opened result |
	server := PolyphemusMCPServer new.
	opened := self callOn: server tool: 'open_image' with: (Dictionary new at: 'path' put: PharoImageAccessor pathToCandle64Bit asFileReference fullName; yourself).
	result := self callOn: server tool: 'step' with: (Dictionary new at: 'handle' put: ((opened at: 'structuredContent') at: 'handle'); yourself).
	self assert: (result at: 'isError').
	self assert: ((self textOf: result) includesSubstring: 'is an image file, not a held image').
	self deny: ((self textOf: result) includesSubstring: 'key ')
