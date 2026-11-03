menus
processMenu

	"What can be done with the process selected (#138)."

	^ self newMenu
		  addItem: [ :item |
			  item
				  name: 'Debug';
				  action: [ self debugSelectedProcess ] ];
		  yourself
