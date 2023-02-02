grammar main;

start : require* myClass+;

//*-----------------------------------------Parser---------------------------------------------*//
//*--------------------Libraries Declaration--------------------*//
require : Valid (',' Valid)* Equation (totalreq)(','totalreq)* SemiColon;
fromtype: 'from' '<' Valid '>' ('require' | '=>') '<' Valid '>' ;
nonFrom: 'require' '<' Valid '>' ;
totalreq: fromtype | nonFrom;

//*--------------------Class Declaration--------------------*//
myClass: Type? 'class' Valid   (Open_Paranthesis (Valid)? Close_Paranthesis)? implements?  begin classBody end;
implements: 'implements' (Valid) (',' Valid)* ;
//extends: 'extends' (Valid (',' Valid)*)+;
begin: 'begin';
end: 'end';
classBody: (classCode)*;
classCode: obj | func | construct | dataValue | require | myClass | this | expression | exception;
var: Type? Const? ;

obj: var  Valid Valid  (Equation (Valid Open_Paranthesis ((Int | Float)(','IntORFloat)*)? Close_Paranthesis ) | 'Null')? SemiColon ;
func: (Type)? (DataType | 'void' | Valid )  Valid Open_Paranthesis Close_Paranthesis begin (inputFunc)? end ;
construct: constructFunc begin code* end ;
constructFunc: (Type)? Valid (inputFunc)? begin code* end ;
this : This'.' Valid Equation expression SemiColon;
inputFunc: Open_Paranthesis(dataValue Valid)*(','dataValue  Valid)*Close_Paranthesis;
funcByReturn: func begin code*  ((Return expression SemiColon)*)? end ;


//*--------------------Variables Declaration--------------------*//
int: var 'int' Valid  (Equation (Int))?  (',' Valid (Equation Int)?)*  SemiColon;
float: var 'float' Valid (Equation (Int | Float)(',' Valid Equation IntORFloat)*)? SemiColon ;
string: var 'string'  Valid  (Equation String)? SemiColon;
char: var 'char' Valid (Equation Char)? SemiColon;
bool: var 'bool' Valid ((Equation Boolean)? SemiColon);
array: var DataType Valid Open_Braket Close_Braket Equation('new' DataType ((Open_Braket Int Close_Braket ) | (Open_CurlyBraket Close_CurlyBraket)))SemiColon;
dataValue: int | float | string | char | bool | array;

//*--------------------Conditions--------------------*//
for: 'for' Open_Paranthesis forInput Close_Paranthesis begin code* end ;
forInput: (Valid '=' Int SemiColon expression SemiColon expression ) | (Const Valid 'in' Valid ) ;
while: 'while' Open_Paranthesis expression Close_Paranthesis  begin code* end ;
do_while: 'do' begin code* end 'while' Open_Paranthesis expression Close_Paranthesis ;
if : (ifInput) ( (ifInput) | (else_if) )* (else)? ;
ifInput : 'if' Open_Paranthesis expression Close_Paranthesis begin  code*  end ;
else_if : 'else if' Open_Paranthesis expression Close_Paranthesis begin  code*  end ;
else : 'else' begin code* end ;
switch_case : 'switch'  expression  begin ('case' Valid ':' (code)? ('break' SemiColon )? )*  ('default' ':' code ('break' SemiColon )? )?  end  ;
ternary: (expression) '?' (expression | String | Boolean | Int | Float) ':' (expression | String | Boolean | Int | Float)  SemiColon;


dataConditions : for | while | do_while | if | else_if | switch_case | ternary;

code: dataValue | dataConditions | comments | expression | this | exception ;
comments: SingleLineComment | MultipleLineComments;
//*--------------------Expressions--------------------*//
expression:  Open_Paranthesis expression Close_Paranthesis | expression '**' expression | '~' expression | pplusMminus | expression ('*' | '/' | '//' | '%')expression |
 expression ('-' | '+') expression | expression ('<<' | '>>') expression | expression ('==' | '!=' | '<>') expression | expression ('<' | '>' | '<=' | '>=')
 expression | expression ('not' | ( 'and' | 'or' | '||' | '&&')expression) | expression ('=' | '+=' | '-=' | '*=' | '/=') expression | data ;
pplusMminus: ( ('++' | '--')Valid | Valid('++' | '--') ) ;
data : (('+' | '-')? Int) | Valid ;
//string: '“' String((' ')+(String))* '“' ;

//*--------------------Exceptions--------------------*//
exception: 'try' begin code* end 'catch' begin code* end ;

//*-----------------------------------------Lexture---------------------------------------------*//
Int : ([0] | [1-9]+) ;
Digits : [0-9] ;
/*fragment*/ Letter : [A-Za-z] ;
//fragment Letter : ('a'..'z')+ ;

SemiColon : ';' ;
Equation : '=' ;
Open_Braket : '[' ;
Close_Braket : ']' ;
Open_CurlyBraket : '{' ;
Close_CurlyBraket : '}' ;
Open_Paranthesis : '(' ;
Close_Paranthesis : ')' ;

This : 'this';
Const : 'const' ;
Return : 'return';
Type : 'public' | 'private' | 'protected' ;
DataType : ('int' | 'float' | 'string' | 'bool' | 'char');
Valid : (Letter | '$') (Letter | Digits | '$' | '_')+ ;


Char : Letter | Digits;
Float : (Int('.'Int)?);
String : '"' .*? '"' ;
Boolean : ('true' | 'false') ;
ScientificNumber :  Int | Digits '.' Int('e'( '-' | '+')? Int)? ;
Total: Char | Int | Float | String | Boolean | ScientificNumber;

Skip : ('\t' | '\n' | ' ' | '\r') -> skip ;

SingleLineComment : '\\' (.*?)  '\n' -> skip;
MultipleLineComments : '/*' .*? '*/' -> skip ;
