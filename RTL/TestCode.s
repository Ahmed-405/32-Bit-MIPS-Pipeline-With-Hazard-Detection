/*
Description: This code stores 6 Number in an array in the memory then it checks the MAX and MIN and the sum of all element
[5,9,25,18,1,21] decimal
[5,9,19,12,1,15] hexadecimal

s0 => 16
t0 => 8
t1 => 9
t2 => 10
t3 => 11
t4 => 12
t5 => 13
t6 => 14
t7 => 15
t8 => 24
t9 => 25

at the end of simulation check the folowing value:
Register t2 represent MAX  =>  regmem[10] = 0x00000019
Register t3 represent MIN  =>  regmem[11] = 0x00000001
Register s0 represent SUM  =>  regmem[16] = 0x0000004F

*/
N_O_P                 // 00000000 (1)

addi t2 $zero 0x5   // 200A0005 (2) max
addi t3 $zero 0x5   // 200B0005 (3) min
addi s0 $zero 0x5   // 20100005 (4) sum

//// Storing elements in the array ////
addi t7 $zero 0x5   // 200F0005 (5)
sw t7 0x0 (t0)      // AD0F0000 (6)

addi t7 $zero 0x9   // 200F0009 (7)
sw t7 0x4 (t0)      // AD0F0004 (8)

addi t7 $zero 0x19  // 200F0019 (9)
sw t7 0x8 (t0)      // AD0F0008 (10)

addi t7 $zero 0x12  // 200F0012 (11)
sw t7 0xC (t0)      // AD0F000C (12)

addi t7 $zero 0x1   // 200F0001 (13)
sw t7 0x10 (t0)     // AD0F0010 (14)

addi t7 $zero 0x15  // 200F0015 (15)
sw t7 0x14 (t0)     // AD0F0014 (16)
//////////////////////////////////////

// for loop
        addi t1 $zero 0x1   // 20090001 (17) i = 1
        addi t6 $zero 0x6   // 200E0006 (18) arr size = 6  

    // Loading element from memory
loop:   addi t0 t0 0x4      // 21080004 (19)
        lw t5 0x0 (t0)      // 8D0D0000 (20) // t5 = arr[i]
        add s0 s0 t5        // 020D8020 (21) // sum += arr[i]
        slt t8 t2 t5        // 014DC02A (22) // if(t2 < t5) => t8 = 1;
        slt t9 t5 t3        // 01ABC82A (23) // if(t5 < t3) => t9 = 1;
        addi t1 t1 0x1      // 21290001 (24) // i = i + 1;
        beq t8 $zero NotMax // 13000001 (25) 
        add t2 $zero t5     // 000D5020 (26) // max = arr[i]
NotMax: beq t9 $zero NotMin // 13200001 (27)
        add t3 $zero t5     // 000D5820 (28) // min = arr[i]
NotMin: bne t1 t6 loop      // 152EFFF5 (29) // loop condition (i < arr.size)

/* Machine Code */
/*
Ins
00000000    //      00000000
200A0005    //      200A0005
200B0005    //      200B0005
20100005    //      20100005
200F0005    //      200F0005
AD0F0000    //      AD0F0000
200F0009    //      200F0009
AD0F0004    //      AD0F0004
200F0019    //      200F0019
AD0F0008    //      AD0F0008
200F0012    //      200F0012
AD0F000C    //      AD0F000C
200F0001    //      200F0001
AD0F0010    //      AD0F0010
200F0015    //      200F0015
AD0F0014    //      AD0F0014
20090001    //      20090001
200E0006    //      200E0006
21080004    //      21080004
8D0D0000    //      8D0D0000
020D8020    //      020D8020
014DC02A    //      014DC02A
01ABC82A    //      01ABC82A
21290001    //      21290001
13000001    //      13000001
000D5020    //      000D5020
13200001    //      13200001
000D5820    //      000D5820
152EFFF5    //      152EFFF5
*/