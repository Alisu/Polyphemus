inspection
inspectionItems: aBuilder
	<inspectorPresentationOrder: 0 title: 'Oop'>

	"The value of a slot can be typed in when the reading has an editor (#20)."

	| values |
	values := (SpStringTableColumn
		           title: 'Value'
		           evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each value ])
		          beSortable;
		          yourself.
	memory editor ifNotNil: [
		values
			beEditable;
			onAcceptEdition: [ :node :text | self storeTyped: text inItemKeyed: node key telling: UIManager default ] ].
	^ aBuilder newTable
		addColumn: (SpStringTableColumn
			title: 'Key'
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ])
			beSortable;
		addColumn: values;
		items: (self inspectionItems collect: [:e | StInspectorAssociationNode hostObject: e ]);
		beResizable;
		alternateRowsColor;
		yourself
