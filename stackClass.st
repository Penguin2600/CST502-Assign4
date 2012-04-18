Object subclass: #Stack
  instanceVariableNames: 'stackPointer stackArray'
  classVariableNames: ''
  poolDictionaries: ''
  category: nil !

!Stack class methodsFor: 'instance creation' !
new
  | r |               "this is a temporary variable for this method only"
  r := super new.     "super forces search for new in the parent class."
  r init.             "initialize the Stack object -- see below"
  ^ r                 "return the newly created and initialized Stack object."
!!

!Stack methodsFor: 'instance initialization' !
init
  stackPointer := 0.
  stackArray := Array new: 512.
!!
!Stack methodsFor: 'stack manipulation'!
push: value
  stackPointer := stackPointer + 1.
  stackArray at: stackPointer put: value. 
!
pop
  |tempVar|
  tempVar:=stackArray at: stackPointer.
  stackPointer := stackPointer - 1.
  ^tempVar
!!
