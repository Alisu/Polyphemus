tests
testAThreadsSystemCallFileIsReadInOnePlace

	"#212: three methods read /proc's syscall file, with two answers for one that does not read.
	Where the Linux package is loaded, one method names that file."

	| found |
	found := OrderedCollection new.
	PolyphemusTestCase methodsOfPolyphemusDo: [ :method |
		(method literals includes: 'syscall') ifTrue: [ found add: method methodClass name , '>>' , method selector ] ].
	self assert: (found reject: [ :each | each = 'LinuxProcessMemory class>>syscallFieldsIn:' ]) asArray equals: #(  )
