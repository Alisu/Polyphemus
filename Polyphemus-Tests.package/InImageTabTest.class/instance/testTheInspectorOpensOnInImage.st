tests
testTheInspectorOpensOnInImage

	"#95: the tab shown first, before Polyphemus's own Oop tab."

	| inspector |
	inspector := StInspectorPresenter onObject: (self memory oopClassNamed: 'Object') reifiedMethodDictionary.
	[
	inspector open.
	PolyphemusTestCase drawWindowOf: inspector.
	self assert: inspector firstPage selectedPageName equals: 'In image' ]
		ensure: [ inspector withWindowDo: [ :window | window close ] ]
