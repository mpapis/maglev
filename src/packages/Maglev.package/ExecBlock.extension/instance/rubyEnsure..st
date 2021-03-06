*maglev-runtime
rubyEnsure: ensureBlock
   "Ruby ensures are run BEFORE searching up stack for on:do:, see Trac720 .
    If you change this method, 
    you may need to change RubyCompiler>>evalMethodSource:with:binding 
    for number of levels up stack to  $~ and $_  in __evalCaller home context "
  | ensureExecuted |
  ^[
     self onSynchronous: AbstractException do:[:ex | 
       ensureExecuted ifNil:[
         ensureExecuted := 1 .
         [ ensureBlock value .
           ensureExecuted := 2 .
         ] onException: RubyThrowException do:[ :tex|
           ensureExecuted := 2 . "consider it executed"
           tex pass
         ]
       ].
       ex pass  "pass does not return"
     ]
   ] ensure:[ 
     ensureExecuted ifNil:[ 
       ensureExecuted := 3 .
       ensureBlock value  .
     ] ifNotNil:[
       ensureExecuted == 1 ifTrue:[ | msg | 
         msg := 'return from ensure swallowed an Exception' .
         (SessionTemps current at:#Maglev_ruby_debugFlag otherwise: false) ifTrue:[
           Exception new details: msg ; signalNotTrappable
         ] ifFalse:[
           Exception signal: msg
         ].
       ].
     ]
   ]

