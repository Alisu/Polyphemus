inspection
inspectionInImage: aBuilder
	<inspectorPresentationOrder: -1 title: 'In image'>

	"The object as the image it was read from shows it: its text, or its elements or variables
	(#95). Polyphemus's own view is the Oop tab."

	^ self inImageText
		  ifNil: [
			  aBuilder newTable
				  addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :each | each key ]);
				  addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :each | self class inImageDescriptionOf: each value ]);
				  items: (self inImageItems collect: [ :each | StInspectorAssociationNode hostObject: each ]);
				  beResizable;
				  alternateRowsColor;
				  yourself ]
		  ifNotNil: [ :text |
			  aBuilder newText
				  text: text;
				  beNotEditable;
				  yourself ]
