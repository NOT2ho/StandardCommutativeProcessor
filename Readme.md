# Standard Commutative Processor

it is DIY kit for make your own standard commutative numbering.

it contains [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0). 
using [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0), you can define `ℕ×ℕ..×ℕ-> ℕ` recursive function. ([scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) can represent all partial recursive functions, so you can just use [scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) independently for represent all programs.)

it converts string(as element of commutative monoid) onto godel numbers(range can be greater than set of godel numbers) and change it to .hs file. you have to prepare haskell compiler to compile it.

## syntax 

#### line 1
Char list. `abc` means `input = (number of a,number of b,number of c)`

#### line 2
[scp-0](https://github.com/NOT2ho/StandardCommutativeProcessor?tab=readme-ov-file#semicommutative-processor-0) code. your self-made partial recursive function. 

input will be tuple of line 1, output is a godel number(it is just haskell code coded into natural number, by prime factorization)

#### line 3

string(as element of commutative monoid) made of chars in line 1. 


#### it will count the number of each char in line 3, and make it to tuple(order determined by line 1) and the function in line 2 will turn the tuple into a godel number(haskell code) and you will compile the code using haskell compiler(i said that you have to prepare haskell compiler).

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
f|+>c
`
means 
 `f(𝑥⃗,0) ≃ p(𝑥⃗)`
` f(𝑥⃗, y+1) ≃ c(𝑥⃗, y, f(𝑥⃗,y))`

 you should define p, c somewhere.

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

you can name functions using a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,x,0,1,2,3,4,5,6,7,8,9.


### example 

`g>S.I^3_3 f|>I^1_1 f|+>g f:` means `(a, b) ↦ a + b`


### warning

unexpected thing can happen if your code has incorrect syntax 

it is all your fault if it happened 


## scpi 

it is scp-0 interpreter works forever (of course there can be some exception)

input syntax : `code [n1, n2, .. nm]`, output is just a number

```
welcome to the scp-0 world. scpi will run forever
scpi> 453
input parse error
scpi> g: g>S.0
input parse error
scpi> g: g>S.0 [2]
1
scpi> g: g>S.0 k: [2]
USER ERROR: why root do not uniquely exist: fromList [["g", "root"], ["k", "root"]]
scpi> f: g>S.I^3_3 f|>I^1_1 f|+>g [1,2,4]
USER ERROR: you wrong! !! your I is 1-ary, not 2-ary
scpi> f: g>S.I^3_3 f|>I^1_1 f|+>g [1,7]
8
```

---
this project is nonsense for make you laugh

## citation
first order formulas are from 

Odifreddi, Piergiorgio (1989). Classical Recursion Theory. North-Holland. ISBN 0-444-87295-7.