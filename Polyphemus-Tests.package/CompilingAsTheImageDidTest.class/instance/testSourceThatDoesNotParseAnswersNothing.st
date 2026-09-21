tests
testSourceThatDoesNotParseAnswersNothing

	"#29: a person editing a method mistypes, and SyntaxErrorNotification is not an Error, so
	it went uncaught and took the whole run with it."

	| class |
	class := self memory oopClassNamed: 'Integer'.

	self assert: (self memory compileHostSource: 'foo | a b ' for: class) isNil.
	self assert: (self memory compileHostSource: 'foo ^ ((' for: class) isNil.
	self assert: (self memory compileHostSource: 'foo ^ 42' for: class) notNil
