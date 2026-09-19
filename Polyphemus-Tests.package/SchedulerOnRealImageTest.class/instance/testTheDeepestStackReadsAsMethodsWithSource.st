tests
testTheDeepestStackReadsAsMethodsWithSource

	"The deepest stack reads as methods with source."

	| deepest stack lines |
	deepest := reifiedMemory allReifiedProcesses
		           detectMax: [ :each | (reifiedMemory contextsOfProcess: each) size ].
	stack := reifiedMemory contextsOfProcess: deepest.
	lines := reifiedMemory stackDescriptionOfProcess: deepest.

	self assert: stack size > 15.
	self assert: (lines allSatisfy: [ :each | each includesSubstring: '>>' ]).

	"blocks appear, and are marked as such"
	self assert: (lines anySatisfy: [ :each | each endsWith: '[block]' ]).
	"class side methods keep the class in the name"
	self assert: (lines anySatisfy: [ :each | each includesSubstring: ' class>>' ]).
	"the handler that ran the command line is in there"
	self assert: (lines anySatisfy: [ :each | each includesSubstring: 'CommandLineHandler' ]).

	"and every frame of it has source"
	stack do: [ :context |
		self deny: (reifiedMemory sourceOfContext: context) isNil ]
