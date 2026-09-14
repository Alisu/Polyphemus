initialization
connectPresenters

	processList whenSelectionChangedDo: [ :selection |
		self showStackOf: selection selectedItem ].
	frameList whenSelectionChangedDo: [ :selection |
		self showSourceOf: selection selectedItem ]
