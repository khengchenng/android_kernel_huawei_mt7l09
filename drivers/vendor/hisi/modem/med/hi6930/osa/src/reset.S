

/*****************************************************************************
  1 ͷ�ļ�����
*****************************************************************************/
#include <xtensa/coreasm.h>
#include <xtensa/simcall.h>
#include "reset.h"


/*****************************************************************************
  2 ȫ�ֱ�������
*****************************************************************************/


/*****************************************************************************
  3 ����ʵ��
*****************************************************************************/
    .begin      literal_prefix .ResetVector
    .section    .ResetVector.text, "ax"
    .global     _ResetVector
    .align      4

_ResetVector:
    /*
    ��ת��Resetִ��
    */
	j       _Reset

    .end        literal_prefix


    .begin      literal_prefix .Reset
    .section    .Reset.text, "ax"
    .global     _Reset
    .align      4

_Reset:
    /*��������ж�*/
	movi    a0, 0
	wsr     a0, INTENABLE

    /*����жϼĴ�����������ֲ���Ҫ�ĵ����쳣*/
    wsr     a0, IBREAKA_0
    wsr     a0, IBREAKA_1
    wsr     a0, DBREAKA_0
    wsr     a0, DBREAKA_1
	wsr     a0, DBREAKC_0
	wsr     a0, DBREAKC_1
    wsr     a0, IBREAKENABLE

    /*���ICOUNT��ICOUNTLEVEL��������ֲ���Ҫ���쳣ICOUNTexception*/
    wsr     a0, ICOUNT
	wsr     a0, ICOUNTLEVEL
	isync

    /*��ֹ��debug����������ж�*/
	rsil    a1, XCHAL_DEBUGLEVEL - 1

	wsr     a0, CCOUNT
    /*�Ĵ������ڳ�ʼ��*/
	wsr     a0, WINDOWBASE
	rsync
	movi    a1, 1
	wsr     a1, WINDOWSTART

	ssai    0

    /*��ʼ��Level-1�ж�*/
	wsr     a0, EXCSAVE_1
	wsr     a0, EPC_1
	wsr     a0, EXCCAUSE

    /*��ʼ��Level-2�ж�*/
	wsr     a0, EPC_2
	wsr     a0, EPS_2
	wsr     a0, EXCSAVE_2

    /*��ʼ��Level-3�ж�*/
	wsr     a0, EPC_3
	wsr     a0, EPS_3
	wsr     a0, EXCSAVE_3

    /*��ʼ��Level-4�ж�*/
	wsr     a0, EPC_4
	wsr     a0, EPS_4
	wsr     a0, EXCSAVE_4

    /*��ʼ��Level-5�ж�(DEBUG)*/
	wsr     a0, EPC_5
	wsr     a0, EPS_5
	wsr     a0, EXCSAVE_5

    /*��ʼ��NMI�ж�*/
    wsr     a0, EPC_6
	wsr     a0, EPS_6
	wsr     a0, EXCSAVE_6


	/*��ʼ����ʱ��0/1/2*/
	wsr     a0, CCOMPARE_0
	wsr     a0, CCOMPARE_1
	wsr     a0, CCOMPARE_2

    /*�������δ�����ı��ش����жϺ����ж�(��ƽ�������жϱ�����ֻ�����ⲿ�ж�Դ)*/
	movi    a2, XCHAL_INTTYPE_MASK_EXTERN_EDGE | XCHAL_INTTYPE_MASK_SOFTWARE
	wsr     a2, INTCLEAR

	wsr     a0, BR

	/*��ֹЭ������*/
	wsr     a0, CPENABLE

	movi    a2, XCHAL_DEBUGLEVEL - 1
	wsr     a2, PS
	rsync


    /*icache��ʼ��*/
#if (XCHAL_ICACHE_SIZE != 0)
    #if (XCHAL_ICACHE_SIZE == 8192)     //212GP and 330HiFi
	movi    a2, 64
    #elif (XCHAL_ICACHE_SIZE == 16384)  //232L and 570T
    movi    a2, 128
    #elif (XCHAL_ICACHE_SIZE == 32768)  //BALONGV7R1
	movi    a2, 256
    #endif

    /*icache����*/
	movi    a3, 0
	loop    a2, .L0
	iiu     a3, 0
	iiu     a3, XCHAL_ICACHE_LINESIZE
	iiu     a3, XCHAL_ICACHE_LINESIZE*2
	iiu     a3, XCHAL_ICACHE_LINESIZE*3
	addi    a3, a3, XCHAL_ICACHE_LINESIZE*4
.L0:

    #if (XCHAL_ICACHE_SIZE == 8192)     //212GP and 330HiFi
	movi    a2, 64
    #elif (XCHAL_ICACHE_SIZE == 16384)  //232L and 570T
	movi    a2, 128
    #elif (XCHAL_ICACHE_SIZE == 32768)  //BALONGV7R1
	movi    a2, 256
    #endif

    /*icacheʹ��Ч*/
	movi    a3, 0
	loop    a2, .L1
	iii     a3, 0
	iii     a3, XCHAL_ICACHE_LINESIZE
	iii     a3, XCHAL_ICACHE_LINESIZE*2
	iii     a3, XCHAL_ICACHE_LINESIZE*3
	addi    a3, a3, XCHAL_ICACHE_LINESIZE*4
.L1:
	isync
#endif


    /*dcache��ʼ��*/
#if (XCHAL_DCACHE_SIZE != 0)
    #if (XCHAL_DCACHE_SIZE == 8192)     //212GP and 330HiFi
	movi    a2, 64
    #elif (XCHAL_DCACHE_SIZE == 16384)  //232L and 570T
	movi    a2, 128
    #elif (XCHAL_DCACHE_SIZE == 32768)  //BALONGV7R1
	movi    a2, 256
    #endif

    /*dcache����*/
	movi    a3, 0
	loop    a2, .L2
	diu     a3, 0
	diu     a3, XCHAL_DCACHE_LINESIZE
	diu     a3, XCHAL_DCACHE_LINESIZE*2
	diu     a3, XCHAL_DCACHE_LINESIZE*3
	addi    a3, a3, XCHAL_DCACHE_LINESIZE*4
.L2:

    #if (XCHAL_DCACHE_SIZE == 8192)     //212GP and 330HiFi
	movi    a2, 64
    #elif (XCHAL_DCACHE_SIZE == 16384)  //232L and 570T
	movi    a2, 128
    #elif (XCHAL_DCACHE_SIZE == 32768)  //BALONGV7R1
	movi    a2, 256
    #endif


    /*dcacheʹ��Ч*/
    movi    a3, 0
	loop    a2, .L3
	dii     a3, 0
	dii     a3, XCHAL_DCACHE_LINESIZE
	dii     a3, XCHAL_DCACHE_LINESIZE*2
	dii     a3, XCHAL_DCACHE_LINESIZE*3
	addi    a3, a3, XCHAL_DCACHE_LINESIZE*4
.L3:
	dsync
#endif

	/*
	�����ڴ�ӳ��ʹ�ȡ��ʽ
    0x00000000-0x1fffffff   :   ������
    0x20000000-0x3fffffff   :	����
    0x40000000-0x5fffffff   :   DDR PHY��ַ������Ϊcached����
    0x60000000-0x7fffffff   :   ������
    0x80000000-0x9fffffff   :   IP��ַ
    0xa0000000-0xbfffffff   :   ������
    0xc0000000-0xdfffffff   :   ������
    0xe0000000-0xffffffff   :   DDR REMAP��ַ������Ϊuncached����
	*/
	movi    a3, 0x00000000
	set_access_mode PIF_INVALID

	movi    a3, 0x20000000
	set_access_mode PIF_BYPASS

	movi    a3, 0x40000000
	set_access_mode PIF_CACHED

	movi    a3, 0x60000000
	set_access_mode PIF_INVALID

	movi    a3, 0x80000000
	set_access_mode PIF_BYPASS

	movi    a3, 0xa0000000
	set_access_mode PIF_INVALID

	movi    a3, 0xc0000000
	set_access_mode PIF_INVALID

	movi    a3, 0xe0000000
	set_access_mode PIF_BYPASS

    /*��ַӳ�䣬��ʱ������*/
    /* �������ַ0xe0000000ӳ�䵽������ַ0x40000000*/
    movi a2, 0xe0000000 //vpn
    movi a3, 0x40000000 //ppn
    movi a5, 0xE0000000 // tlb mask, upper 3 bits
    and a4, a3, a5      // upper 3 bits of PPN area
    and a7, a2, a5      // upper 3 bits of VPN area

    ritlb1 a5, a7       // get current PPN+AM of segment for I
    rdtlb1 a6, a7       // get current PPN+AM of segment for D
    extui a5, a5, 0, 4  // keep only AM for I
    extui a6, a6, 0, 4  // keep only AM for D
    add a2, a4, a5      // combine new PPN with orig AM for I
    add a3, a4, a6      // combine new PPN with orig AM for D
    witlb a2, a7        // write new tlb mapping for I
    wdtlb a3, a7        // write new tlb mapping for D

    isync


    /*
    ׼��C���л���
    */
	movi    sp, __stack

	movi    a2, PS_WOE_MASK | PS_PROGSTACK_MASK
	wsr     a2, PS
	rsync

	movi    a8, _bss_start
	movi    a10, _bss_end
	sub     a11, a10, a8
	srli    a11, a11, 2

	movi    a9, 0
    loopnez a11, zerodone
	s32i    a9, a8, 0
	addi    a8, a8, 4
zerodone:

callmain:
	movi    a0, 0
	movi    a6, 0   /* clear argc*/
	movi    a7, 0   /* clear argv*/
	movi    a8, 0   /* clear envp*/
	movi    a4, main
	nop
	nop
	callx4  a4

reset_exit:
	movi    a2, SYS_exit

    .end        literal_prefix

#ifdef VOS_VENUS_TEST_STUB
	.text
	.global sim_call
	.type sim_call,@function
	.align 4
sim_call:
	entry sp, 64
	addi    a4, a3,-3
    movi    a3, g_auwVosTestMessageBuf
    movi    a2, SYS_log_msg
    simcall
	retw

#endif

