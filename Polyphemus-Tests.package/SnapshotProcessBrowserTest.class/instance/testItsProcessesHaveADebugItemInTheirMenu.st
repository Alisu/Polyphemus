tests
testItsProcessesHaveADebugItemInTheirMenu

	"#138: a right-click on a process offers to debug it."

	self assert: ((browser processMenu menuGroups flatCollect: [ :each | each menuItems ])
			 anySatisfy: [ :each | each name = 'Debug' ])
