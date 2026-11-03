tests
testTheInspectorOpensOnInImage

	"#95: the tab shown first, before Polyphemus's own Oop tab. The inspector is StInspector up to
	Pharo 11."

	| inspector |
	inspector := (Smalltalk globals at: #StInspectorPresenter ifAbsent: [ Smalltalk globals at: #StInspector ]) onObject: (self memory oopClassNamed: 'Object') reifiedMethodDictionary.
	[
	inspector open.
	PolyphemusTestCase drawWindowOf: inspector.
	self assert: inspector firstPage selectedPageName equals: 'In image' ]
		ensure: [ inspector withWindowDo: [ :window | window close ] ]
