*Polyphemus-Memory
keyValueTableOf: someItems in: aBuilder

	"The inspector's table of key -> value items that are only read, as a frame's and a stack
	page's are: two sortable columns."

	^ aBuilder newTable
		  addColumn: (SpStringTableColumn title: 'Key' evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ]) beSortable;
		  addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each value ]) beSortable;
		  items: someItems;
		  yourself
