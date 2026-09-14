layout
defaultLayout

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: processList;
				   add: frameList;
				   yourself);
		  add: sourceText;
		  yourself
