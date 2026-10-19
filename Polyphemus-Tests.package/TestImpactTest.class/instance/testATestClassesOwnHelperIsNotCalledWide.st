tests
testATestClassesOwnHelperIsNotCalledWide

	"setUp is everybody's selector, but a test class's own setUp changed selects that class."

	| impact |
	impact := TestImpact fromLines: #( 'ProcessChoiceTest setUp' ).
	self assert: ((impact testClasses collect: [ :each | each name ]) includes: #ProcessChoiceTest).
	self deny: (impact wideSelectors includes: #setUp)
