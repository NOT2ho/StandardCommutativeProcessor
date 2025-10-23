# Standard Commutative Processor

it is DIY kit for make your own standard commutative numbering.

it contains scp-0 and haskell compiler. 
using scp-0, you can define `ℕ×ℕ..×ℕ-> ℕ` recursive function. (scp-0 can represent all partial recursive functions, so you can just use scp-0 independently for represent all programs.)

it converts string(as element of commutative monoid) onto godel numbers(range can be greater than set of godel numbers) and compile the number.

## syntax 

#### line 1
Char list. `abc` means `input = (number of a,number of b,number of c)`

#### line 2
scp-0 code. your self-made partial recursive function. 

input will be tuple of line 1, output is a godel number(it is just haskell code coded into natural number, by prime factorization)

#### line 3

string(as element of commutative monoid) made of chars in line 1. 


#### it will count the number of each char in line 3, and make it to tuple(order determined by line 1) and the function in line 2 will turn the tuple into a godel number(haskell code) and the code will be complied.

### some not good example: 

```
abcdefgij
(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8) -- it is sudocode
aaaaaaaaaaaggggggjjjjjjjjjjjjdddddddaaaaajjjjjjjjjjjjjjjjbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiiiiiiiggggggiiiiiiiiiiijjjjjjjjjjjjjjjjjjjjjjaaaaaaaeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffggggabbbbcccccccccfffffffffffffffffaaaaabbbbbbbbbbaaaaaaaaiiiiiiiiiiiiiiiiiiiiiiiiiiigggggggfffffccccggggggiiiiiiiiicaaaaaaacccccbbbbiiijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjgggggggggggggggggggggggggggffffffffffffffffffffffffffeaaaaaddddddddd
```

in this case `aaaaaaaaaaaggggggjjjjjjjjjjjjdddddddaaaaajjjjjjjjjjjjjjjjbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiiiiiiiggggggiiiiiiiiiiijjjjjjjjjjjjjjjjjjjjjjaaaaaaaeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffggggabbbbcccccccccfffffffffffffffffaaaaabbbbbbbbbbaaaaaaaaiiiiiiiiiiiiiiiiiiiiiiiiiiigggggggfffffccccggggggiiiiiiiiicaaaaaaacccccbbbbiiijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjgggggggggggggggggggggggggggffffffffffffffffffffffffffeaaaaaddddddddd` represents `(83,22,19,16,15,96,56,57,83)` and by `(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8)` the number is `45826143037620432864501479442625644954164520255613681749668324069528878752359361242174946715722194008898020316908186168841295342794266793540822091868135825055329354680522875742385669065124120130865452226276538681951371444928626570816955944453448517095486506282272302237751624180901926862210861878069343165732877670521393820285627519956695972280190929227866570811620889424696782846373492982769729638904815383361658940293120000000000000000000` and the haskell code `pure ()` will be compiled. (of course this is not total code so compile error will happen but that is not the point)

the function `(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8)` is not onto. but you can find onto function and use it(trivial example: `(x, ..., _)-> x` i don't know nontrivial thing exists).


# SemiCommutative Processor 0

there is no io, scp-0 just represents a partial recursive function.

scp-0 code is just set of first order formulas representing partial recursive functions, so scp-0 is actually an sublanguage of first order language. nothing special

it contains O, S, I<sup>n</sup> <sub>i</sub>, primitive recursion, μ-recursion, composition. detail: [click here]()

all functions are pure numeric, immutable. so scp-0 is commutative (if you think the blank is binary operation) 

no higher order function allowed yet, functionals are so mendokusina i'll do it later



## syntax

notation: ≃ means both undefined or samely defined. μy[p(y)] search for minimun y s.t. p(y) 

other notations are usual

### functions

#### O
`O` is `const 0`. 

#### S

`S` is successor.

#### I <sup>n</sup> <sub>i</sub>

`I^n_i` is I <sup>n</sup> <sub>i</sub>. it is just projection 

index start at 1

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
putting `:f` somewhere, the program will represent f

`:` must exist uniquely or your program dooms

(why not `f:` ? parser mendokusai issue)

### naming rule

you can name functions using a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,x,0,1,2,3,4,5,6,7,8,9.


### example 

`g>S.I^3_1 f|>I^1_1 f|+>g :f` means `(a, b) ↦ a + b`






---
## cite
first order formulas are from 

Odifreddi, Piergiorgio (1989). Classical Recursion Theory. North-Holland. ISBN 0-444-87295-7.