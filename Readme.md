# Standard Commutative Processor 1

it is DIY kit for make your own standard commutative numbering.

it contains scp-0 and haskell compiler.

using scp-0, you can define `ℕ^n -> ℕ` recursive function. (scp-0 can represent all partial recursive functions, so you can just use scp-0 independently)

it converts string(as element of commutative monoid) onto godel numbers(range can be greater than set of godel numbers).

```
abcdefgij
(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8) -- it is sudocode
aaaaaaaaaaaggggggjjjjjjjjjjjjdddddddaaaaajjjjjjjjjjjjjjjjbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiiiiiiiggggggiiiiiiiiiiijjjjjjjjjjjjjjjjjjjjjjaaaaaaaeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffggggabbbbcccccccccfffffffffffffffffaaaaabbbbbbbbbbaaaaaaaaiiiiiiiiiiiiiiiiiiiiiiiiiiigggggggfffffccccggggggiiiiiiiiicaaaaaaacccccbbbbiiijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjgggggggggggggggggggggggggggffffffffffffffffffffffffffeaaaaaddddddddd
```

in this case `aaaaaaaaaaaggggggjjjjjjjjjjjjdddddddaaaaajjjjjjjjjjjjjjjjbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiiiiiiiggggggiiiiiiiiiiijjjjjjjjjjjjjjjjjjjjjjaaaaaaaeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffggggabbbbcccccccccfffffffffffffffffaaaaabbbbbbbbbbaaaaaaaaiiiiiiiiiiiiiiiiiiiiiiiiiiigggggggfffffccccggggggiiiiiiiiicaaaaaaacccccbbbbiiijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjgggggggggggggggggggggggggggffffffffffffffffffffffffffeaaaaaddddddddd` represents `(83,22,19,16,15,96,56,57,83)` and by `(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8)` the number is `45826143037620432864501479442625644954164520255613681749668324069528878752359361242174946715722194008898020316908186168841295342794266793540822091868135825055329354680522875742385669065124120130865452226276538681951371444928626570816955944453448517095486506282272302237751624180901926862210861878069343165732877670521393820285627519956695972280190929227866570811620889424696782846373492982769729638904815383361658940293120000000000000000000` and the haskell code `pure ()` will be compiled.

the function `(x0,x1,x2,x3,x4,x5,x6,x7,x8)->(2^x0*3^x1*5^x2*7^x3*11^x4*13^x5*17^x6*19^x7*23^x8)` is not onto. but you can find onto function and use it(trivial example: `(x, ...)-> x` i don't know nontrivial thing exists).


# SemiCommutative Processor 0

it contains O, S, I, mu-rec. detail: [click here]()

it is universal `ℕ^ℕ -> ℕ` recursive function.

### syntax

(a,b) |-> a+b

`f|0>0
f|+1>s
`

todo


