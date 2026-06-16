/*
Description: this code for test the Exception

// s0 regester had previous value 0x7FF0_0000
*/
// Overflow Exception
0x0000    NOP                 // 00000000
0x0008    addi s5 s5 0x0AAA   // 22B50AAA
0x0004    addi s1 s1 0x0A16   // 2231FFFF
0x000C    add s0 s0 s0        // 02108020 // Overflow
0x0010    addi t0 t0 0x4      // 21080004
0x0014    sw s0 0x0 (t0)      // AD100000
// ...
// ...
// ...
// Invalid Exception
0x00DC    addi t2 t2 0x0AAA   // 214A0AAA
0x00E0    SWL $s5 0x8404 $s0  // AA158404 // Invalid Instruction becouse SWL is not supported
0x00E4    addi t0 t0 0x4      // 21080004
0x00E8    sw s0 0x0 (t0)      // AD100000
// ...
// ...
// ...
// Exception Address
0x0100    bne t2 s5 0xFFF6    // 1555FFF6 offcet =>  -10

/*
Overflow Exception Machine Code
2231FFFF
02108020
21080004
AD100000
//
22
31
FF
FF
02
10
80
20
21
08
00
04
AD
10
00
00
*/

/*
Exception Address
214A0100
22B50AAA
1555FFF6
//
21
4A
01
00
22
B5
0A
AA
15
55
FF
F6
*/

/*
Invalid Exception Machine Code
00000000
214A09AA
AA158404
21080004
AD100000
//
00
00
00
00
21
4A
09
AA
AA
15
84
04
21
08
00
04
AD
10
00
00
*/