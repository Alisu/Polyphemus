naming
compilerOptionsWith: someOptions

	"someOptions, plus every inlining and block option stated as the image's own compiler had
	it -- Pharo 10's defaults -- so this host's defaults change nothing (#7). Options this host
	does not have are left out."

	| on off context |
	on := #( optionInlineAndOr optionInlineCase optionInlineIf optionInlineIfNil
	         optionInlineToDo optionInlineWhile optionOptimizeIR ).
	off := #( optionInlineRepeat optionInlineTimesRepeat optionInlineNone
	          optionCleanBlockClosure optionConstantBlockClosure optionLongIvarAccessBytecodes ).
	context := OpalCompiler new compilationContext.
	^ Array streamContents: [ :stream |
		  stream nextPutAll: someOptions.
		  on do: [ :each |
			  (context respondsTo: each) ifTrue: [ stream nextPut: #+; nextPut: each ] ].
		  off do: [ :each |
			  (context respondsTo: each) ifTrue: [ stream nextPut: #-; nextPut: each ] ] ]
