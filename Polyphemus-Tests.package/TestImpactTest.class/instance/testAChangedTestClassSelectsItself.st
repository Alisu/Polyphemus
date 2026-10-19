tests
testAChangedTestClassSelectsItself

	self assert: ((self selectedFor: #( 'ProcessChoiceTest' )) includes: #ProcessChoiceTest).
	self assert: ((self selectedFor: #( 'ProcessChoiceTest testAProcessIsFoundByItsName' )) includes: #ProcessChoiceTest)
