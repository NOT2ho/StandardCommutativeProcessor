# Standard Commutative Processor


it is DIY kit for make your own standard commutative numbering.

# SCP-n 

you can iterate [this](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#SCP-1) forever (replace scp-0 to scp-(n-1), scp-1 to scp-n)

# SCP-1

***(not tested yet)***

it contains [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0). 
using [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0), you can define `ℕ×ℕ..×ℕ-> ℕ` recursive function. ([scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) can represent all partial recursive functions, so you can just use [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) independently for represent all programs.)

it converts string(as element of commutative monoid) onto godel numbers(range can be greater than set of godel numbers) and change it to .scp file.



you can change scp-0 to other language if you want. (in this case you should change the function 'symbols'(Numbering.hs:80) and recompile)



## syntax 

#### line 1
Char list. `abc` means `input = (number of a,number of b,number of c)`

#### line 2
[scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) code. your self-made partial recursive function. 

input will be tuple of line 1, output is a godel number(it is just scp-0 code coded into natural number, by prime factorization)

#### line 3

string(as element of commutative monoid) made of chars in line 1. 


#### it will count the number of each char in line 3, and make it to tuple(order determined by line 1) and the function in line 2 will turn the tuple into a godel number(it is scp-0 code). and you can ctrl c v it in scpi.

### some example: 
todo

# SemiCommutative Processor 0

scp-0 represents a partial recursive function. 

scp-0 code is just set of first order formulas representing partial recursive functions, so scp-0 is actually an sublanguage of first order language. nothing special

it contains O, S, I<sup>n</sup> <sub>i</sub>, primitive recursion, μ-recursion, composition. detail: [click here]()

all functions are pure numeric, immutable. so scp-0 is commutative (if you think the blank is binary operation) 

no higher order function allowed yet, functionals are so mendokusaina i'll do it later



## syntax

notation: ≃ means both undefined or samely defined. μy[p(y)] search for minimun y s.t. p(y) 

other notations are usual

scp-0 is set of words. so order and duplicated words are ignored.

useless inputs, word which is not subnode of root will be ignored `g h: h>O ㄷㄱ해독히ㅜ대ㅑ허 [3,5]` is equal to `h: h>O []` (it is just 0) - convenience of parsing (i don't sure that O can be 0-ary..)

### functions

#### O
`O` is `const 0`. 

#### S

`S` is successor.

#### I <sup>n</sup> <sub>i</sub>

`I^n_i` is I <sup>n</sup> <sub>i</sub>. it is just projection 

index starts at 1

example: `I^3_2` is a function `(_,x,_) ↦ x`

#### primitive recursion

`f|>p
f|>>c
`
means 
 `f(𝑥⃗,0) ≃ p(𝑥⃗)`
` f(𝑥⃗, y+1) ≃ c(𝑥⃗, y, f(𝑥⃗,y))`

 you should define p, c somewhere.

(it was `f|>p
f|+>c
` in version less or equal than 0.0)


#### μ-recursion

`f<p` means `f(𝑥⃗) ≃ μy[(∀z ≤ y)(p(𝑥⃗,z)↓) ∧ p(𝑥⃗,y) ≃ 0]`

if there is no such y, f will be undefined so program will not stop forever


#### composition
`f>g.c1,...cm` means `f(𝑥⃗)≃g(c1​(𝑥⃗),…,cm​(𝑥⃗))`

if c1​(𝑥⃗)↑ ∨ … ∨ cm​(𝑥⃗)↑, f will be undefined so program will not stop forever

#### :
putting `f:` somewhere, the program will represent f

`:` must exist uniquely or your program dooms 

### naming rule


you can name functions using permutation of a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,x,0,1,2,3,4,5,6,7,8,9. *≤ v0.0*

you can use !,@,#,$,%,^,&,\*,(,),-,+,_,=,/,\,?,',",\[,\],{,},`,~,;. *from 0.1*

empty name not allowed ('Semi' in 'SemiCommutative Processor' is abb of 'Semigroup' (joke))


### *syntactic sugars*

#### more pretty premitive recursion

you can use `f|p>
f|c>>` to replace `f|>p
f|>>c` respectively.  *from 0.1*

#### composition iteration 

`c: c>S.S.S.S.S.S.S` now allowed

greater then 1 ary e.g. `c: c>a,S.S.S,b.d,S.O (some code omitted)` also allowed
 
(i don't sure whether it works well or there exist some ambiguity issue, but composition is associative)

*from 0.1*

#### S^n

iterate `S` n times. e.g. `S^3` equals to `s3: s2>S.S s3>S.s2` (it is `+ 3`) 

*from 0.1*

#### :=

just renaming the initial function. `id: id:=I^1_1` is just `I^1_1`.

*from 0.1*


### how to make it

for your freedom of function name choice, there are no useless built-in function. (this language does not have scope)

so functions below are not built-in functions. it is just example.

#### constant

`S^n.O` is `const n` (i recommend to name it as number itself e.g. `3: 3>S^n.O`)


#### identity function

id: `I^1_1`

#### predecessor
`-1: p|>O p|>>I^2_1`


#### binary addition
`+: f>S.I^3_3 +|>I^1_1 +|>>f`


#### proper subtraction `(a, b) ↦ max (a - b, 0)`

`-: -|>I^1_1 -|>>c c>-1.I^3_3` (code for -1 omitted)

#### multiplication
`*: *|>O *|>>a a>+.I^3_1,I^3_3 ` (code for + omitted)

#### power
`^: ^|s> s>S.O ^|c>> c>*.I^3_3,I^3_1`
(code for * omitted)


#### if-else `f = if c [x1, .. , xm] == 0 then g[x1, .. , xm] else h [x1, .. , xm]`

`f: f>+.if,else 
 if>*.ch,g
 else>*.ch',h
 ch'>z'.c 
 z'|>1 z'|>>O  
 ch>z.c 
 z|>O z|>>1 `

(code for *, +, 1 omitted)

if you want another characteristic function, make it yourself.

*from 0.1*

### warning

*regulations are written in blood.*

unexpected thing can happen if your code has incorrect syntax 


it is all your fault if it happened 


## scpi 

it is scp-0 interpreter works forever (of course there can be some exception, i'm trying..)

### input syntax 
`code [n1, n2, .. nm]`, output is just a number

### slowness

it is slow so you should rearrange your input sequence if you can until i fix it. (`g>S.I^3_3 f|>I^1_1 f|>>g f: [1,100]` takes very very long time but `g>S.I^3_3 f|>I^1_1 f|>>g f: [100,1]` ends immediately)

### example

```
welcome to the scp-0 world. scpi will run forever
scpi> 453
input parse error
scpi> g: g>S.0
input parse error
scpi> g: g>S.0 [2]
1
scpi> g: g>S.0 k: [2]
USER ERROR: why root do not uniquely exist: g,k
scpi> f: g>S.I^3_3 f|>I^1_1 f|>>g [1,2,4]
USER ERROR: you wrong! !! your I is 1-ary, not 2-ary
scpi> f: g>S.I^3_3 f|>I^1_1 f|>>g [1,7]
8
scpi> g>S.I^3_3 f|>I^1_1 f|>>g m: m<g [2,5]
* hangs forever *

```
infinite loop is not error (if you find the way to know whether it is infinite loop or not then the world explode)


---
this project is nonsense for make you laugh

## citation
first order formulas are from 

Odifreddi, Piergiorgio (1989). Classical Recursion Theory. North-Holland. ISBN 0-444-87295-7.
