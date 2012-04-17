"exec" "gst" "-q" "$0" "-a" "$@"
"exit"

"====BEGIN imports and Vars===="
FileStream fileIn: 'stackClass.st' .

Smalltalk at: #codeArray put: (Array new:512).
Smalltalk at: #rtStack   put: (Stack new).
Smalltalk at: #rtDict    put: (Dictionary new).
Smalltalk at: #progCount put: 1.

"====END imports and Vars===="


"====BEGIN get filename from cmd ARGS===="
|clArgs fileName|
clArgs := Smalltalk getArgv: 1 .

(clArgs size) > 0 ifTrue:  [
fileName := clArgs.
Transcript show: '### loading int code from: ', fileName, ' ###'; cr.
] ifFalse: [                 
Transcript show: ' '; cr.
Transcript show: '### missing filename arguement ###'; cr.
Transcript show: ' '; cr.
].
"====END get filename from cmd ARGS===="


"====BEGIN read instructions into codeArray===="
|aFile aLine aToken aSet cnt|
cnt:=1.
aFile := (FileStream open: fileName mode: FileStream read).
[aFile atEnd ] whileFalse: [
aLine:= aFile upTo: Character lf.
aToken:= aLine copyUpTo: Character space.
codeArray at: cnt put: (aLine).
cnt := cnt + 1.
].
"====END read instructions into codeArray===="


"====BEGIN parse and Execute codeArray===="
|currentTokens dVal didJump aVal bVal tVal|
didJump:=0.

[(codeArray at:progCount) = 'END'] whileFalse: [
currentTokens:= ((codeArray at:progCount) subStrings: Character space).
(currentTokens at:1) = 'READ'  ifTrue: [
Transcript show: '#>'.
rtStack push: (stdin nextLine).
].

(currentTokens at:1) = 'PRINT' ifTrue: [
(rtStack pop) printNl.
].

(currentTokens at:1) = 'PUSH' ifTrue: [
dVal:=rtDict at: (currentTokens at:2) ifAbsent: [dVal:=(currentTokens at:2).].
rtStack push: (dVal asNumber).
].

(currentTokens at:1) = 'STOR' ifTrue: [
rtDict at: (currentTokens at:2) put: rtStack pop.
].

(currentTokens at:1) = 'JMP' ifTrue: [
progCount:=(currentTokens at:2) asNumber.
didJump:=didJump+1.
].

(currentTokens at:1) = 'JIF' ifTrue: [
tVal:=(rtStack pop).
(tVal = 0.0) ifTrue: [
progCount:=(currentTokens at:2) asNumber.
didJump:=didJump+1.].
].

(currentTokens at:1) = 'ADD' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
tVal:=(aVal + bVal).
rtStack push: tVal.
].

(currentTokens at:1) = 'MUL' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
tVal:= (aVal * bVal).
rtStack push: tVal.
].
(currentTokens at:1) = 'SUB' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
tVal:= (aVal - bVal).
rtStack push: tVal.
].
(currentTokens at:1) = 'DIV' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
tVal:= (aVal / bVal).
rtStack push: tVal.
].

(currentTokens at:1) = 'TGT' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
(aVal > bVal) ifTrue: [
rtStack push: 1.0.] ifFalse: [
rtStack push: 0.0.].
].

(currentTokens at:1) = 'TLT' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
(aVal < bVal) ifTrue: [
rtStack push: 1.0.] ifFalse: [
rtStack push: 0.0.].
].

(currentTokens at:1) = 'TEQ' ifTrue: [
bVal:=(rtStack pop).
aVal:=(rtStack pop).
(aVal = bVal) ifTrue: [
rtStack push: 1.0.] ifFalse: [
rtStack push: 0.0.].
].

Transcript show: ' '; cr.
(didJump > 0) ifFalse: [progCount:= progCount + 1.].
didJump:=0.
].
"====END parse and Execute codeArray===="

