
Fatbin elf code:
================
arch = sm_30
code version = [1,7]
producer = cuda
host = linux
compile_size = 64bit

Fatbin ptx code:
================
arch = sm_30
code version = [6,2]
producer = cuda
host = linux
compile_size = 64bit
compressed








.version 6.2
.target sm_30
.address_size 64

.func _ZN15PulseChiSqSNNLSD1Ev
(
.param .b64 _ZN15PulseChiSqSNNLSD1Ev_param_0
)
;
.func _ZN15PulseChiSqSNNLSD0Ev
(
.param .b64 _ZN15PulseChiSqSNNLSD0Ev_param_0
)
;
.extern .func free
(
.param .b64 free_param_0
)
;
.global .align 16 .u64 _ZTV15PulseChiSqSNNLS[4] = {0, 0, _ZN15PulseChiSqSNNLSD1Ev, _ZN15PulseChiSqSNNLSD0Ev};
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust6system6detail10sequential3seqE[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust8cuda_cub3parE[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_1E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_2E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_3E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_4E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_5E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_6E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_7E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_8E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders2_9E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust12placeholders3_10E[1];
.global .align 1 .b8 _ZN72_INTERNAL_50_tmpxft_00001958_00000000_6_PulseChiSqSNNLS_cpp1_ii_b656f9b26thrust3seqE[1];

.func _ZN15PulseChiSqSNNLSD1Ev(
.param .b64 _ZN15PulseChiSqSNNLSD1Ev_param_0
)
{
.reg .b64 %rd<5>;


ld.param.u64 %rd1, [_ZN15PulseChiSqSNNLSD1Ev_param_0];
mov.u64 %rd2, _ZTV15PulseChiSqSNNLS;
add.s64 %rd3, %rd2, 16;
cvta.global.u64 %rd4, %rd3;
st.u64 [%rd1], %rd4;
ret;
}

.func _ZN15PulseChiSqSNNLSD0Ev(
.param .b64 _ZN15PulseChiSqSNNLSD0Ev_param_0
)
{
.reg .b64 %rd<5>;


ld.param.u64 %rd1, [_ZN15PulseChiSqSNNLSD0Ev_param_0];
mov.u64 %rd2, _ZTV15PulseChiSqSNNLS;
add.s64 %rd3, %rd2, 16;
cvta.global.u64 %rd4, %rd3;
st.u64 [%rd1], %rd4;

	{
.reg .b32 temp_param_reg;

	.param .b64 param0;
st.param.b64	[param0+0], %rd1;
call.uni 
free, 
(
param0
);


	}
	ret;
}


.visible .entry _Z8DoFitGPUP10_DoFitArgsPd(
.param .u64 _Z8DoFitGPUP10_DoFitArgsPd_param_0,
.param .u64 _Z8DoFitGPUP10_DoFitArgsPd_param_1
)
{
.local .align 8 .b8 __local_depot2[6800];
.reg .b64 %SP;
.reg .b64 %SPL;
.reg .pred %p<44>;
.reg .b16 %rs<31>;
.reg .b32 %r<38>;
.reg .f64 %fd<29>;
.reg .b64 %rd<224>;


mov.u64 %SPL, __local_depot2;
cvta.local.u64 %SP, %SPL;
ld.param.u64 %rd81, [_Z8DoFitGPUP10_DoFitArgsPd_param_0];
cvta.to.global.u64 %rd82, %rd81;
add.u64 %rd83, %SP, 0;
cvta.to.local.u64 %rd1, %rd83;
add.u64 %rd84, %SP, 3952;
cvta.to.local.u64 %rd2, %rd84;
mov.u32 %r14, %ntid.x;
mov.u32 %r15, %ctaid.x;
mov.u32 %r16, %tid.x;
mad.lo.s32 %r17, %r14, %r15, %r16;
mul.wide.s32 %rd85, %r17, 3952;
add.s64 %rd4, %rd82, %rd85;
ld.global.f64 %fd1, [%rd4];
ld.global.f64 %fd2, [%rd4+8];
ld.global.f64 %fd3, [%rd4+16];
ld.global.f64 %fd4, [%rd4+24];
ld.global.f64 %fd5, [%rd4+32];
ld.global.f64 %fd6, [%rd4+40];
ld.global.f64 %fd7, [%rd4+48];
ld.global.f64 %fd8, [%rd4+56];
ld.global.f64 %fd9, [%rd4+64];
ld.global.f64 %fd10, [%rd4+72];
st.local.f64 [%rd1+72], %fd10;
st.local.f64 [%rd1+64], %fd9;
st.local.f64 [%rd1+56], %fd8;
st.local.f64 [%rd1+48], %fd7;
st.local.f64 [%rd1+40], %fd6;
st.local.f64 [%rd1+32], %fd5;
st.local.f64 [%rd1+24], %fd4;
st.local.f64 [%rd1+16], %fd3;
st.local.f64 [%rd1+8], %fd2;
st.local.f64 [%rd1], %fd1;
add.s64 %rd5, %rd4, 80;
add.s64 %rd6, %rd1, 80;
mov.u32 %r34, 0;
mov.pred %p1, 0;
@%p1 bra BB2_2;

BB2_1:
mul.wide.s32 %rd86, %r34, 8;
add.s64 %rd87, %rd5, %rd86;
ld.global.u64 %rd88, [%rd87];
add.s64 %rd89, %rd6, %rd86;
st.local.u64 [%rd89], %rd88;
add.s32 %r34, %r34, 1;
setp.lt.u32	%p2, %r34, 100;
@%p2 bra BB2_1;

BB2_2:
ld.global.f64 %fd11, [%rd4+880];
ld.global.u64 %rd7, [%rd4+904];
st.local.f64 [%rd1+880], %fd11;
st.local.u64 [%rd1+904], %rd7;
ld.global.v2.u8 {%rs2, %rs3}, [%rd4+896];
ld.global.v4.u8 {%rs4, %rs5, %rs6, %rs7}, [%rd4+888];
ld.global.v4.u8 {%rs8, %rs9, %rs10, %rs11}, [%rd4+892];
st.local.v4.u8 [%rd1+892], {%rs8, %rs9, %rs10, %rs11};
st.local.v4.u8 [%rd1+888], {%rs4, %rs5, %rs6, %rs7};
st.local.v2.u8 [%rd1+896], {%rs2, %rs3};
add.s64 %rd8, %rd4, 912;
add.s64 %rd9, %rd1, 912;
mov.u32 %r35, 0;
@%p1 bra BB2_4;

BB2_3:
mul.wide.s32 %rd90, %r35, 8;
add.s64 %rd91, %rd8, %rd90;
ld.global.u64 %rd92, [%rd91];
add.s64 %rd93, %rd9, %rd90;
st.local.u64 [%rd93], %rd92;
add.s32 %r35, %r35, 1;
setp.lt.u32	%p4, %r35, 19;
@%p4 bra BB2_3;

BB2_4:
add.s64 %rd10, %rd4, 1064;
add.s64 %rd11, %rd1, 1064;
mov.u32 %r36, 0;
@%p1 bra BB2_6;

BB2_5:
mul.wide.s32 %rd94, %r36, 8;
add.s64 %rd95, %rd10, %rd94;
ld.global.u64 %rd96, [%rd95];
add.s64 %rd97, %rd11, %rd94;
st.local.u64 [%rd97], %rd96;
add.s32 %r36, %r36, 1;
setp.lt.u32	%p6, %r36, 361;
@%p6 bra BB2_5;

BB2_6:
mov.u64 %rd99, _ZTV15PulseChiSqSNNLS;
add.s64 %rd100, %rd99, 16;
cvta.global.u64 %rd101, %rd100;
st.local.u64 [%rd2], %rd101;
mov.u64 %rd196, 0;
st.local.u64 [%rd2+1688], %rd196;
st.local.u64 [%rd2+1776], %rd196;
st.local.u64 [%rd2+1864], %rd196;
st.local.u64 [%rd2+1952], %rd196;
st.local.u64 [%rd2+2792], %rd196;
st.local.u64 [%rd2+2816], %rd196;
st.local.u64 [%rd2+2832], %rd196;
mov.u16 %rs22, 0;
st.local.u8 [%rd2+2768], %rs22;
mov.u16 %rs23, 1;
st.local.u8 [%rd2+2840], %rs23;
cvt.u32.u64	%r7, %rd7;
ld.local.f64 %fd12, [%rd1];
ld.local.f64 %fd13, [%rd1+8];
ld.local.f64 %fd14, [%rd1+16];
ld.local.f64 %fd15, [%rd1+24];
ld.local.f64 %fd16, [%rd1+32];
ld.local.f64 %fd17, [%rd1+40];
ld.local.f64 %fd18, [%rd1+48];
ld.local.f64 %fd19, [%rd1+56];
ld.local.f64 %fd20, [%rd1+64];
ld.local.f64 %fd21, [%rd1+72];
st.local.f64 [%rd2+8], %fd12;
st.local.f64 [%rd2+16], %fd13;
st.local.f64 [%rd2+24], %fd14;
st.local.f64 [%rd2+32], %fd15;
st.local.f64 [%rd2+40], %fd16;
st.local.f64 [%rd2+48], %fd17;
st.local.f64 [%rd2+56], %fd18;
st.local.f64 [%rd2+64], %fd19;
st.local.f64 [%rd2+72], %fd20;
st.local.f64 [%rd2+80], %fd21;
setp.eq.s64	%p7, %rd7, 0;
@%p7 bra BB2_8;

st.local.u64 [%rd2+2792], %rd7;
mov.u64 %rd196, %rd7;

BB2_8:
setp.lt.s64	%p8, %rd196, 1;
@%p8 bra BB2_18;

and.b64 %rd14, %rd196, 3;
setp.eq.s64	%p9, %rd14, 0;
mov.u64 %rd202, 0;
@%p9 bra BB2_15;

setp.eq.s64	%p10, %rd14, 1;
mov.u64 %rd198, 0;
@%p10 bra BB2_14;

setp.eq.s64	%p11, %rd14, 2;
mov.u64 %rd197, 0;
@%p11 bra BB2_13;

ld.local.u8 %rs24, [%rd1+888];
st.local.u8 [%rd2+2776], %rs24;
mov.u64 %rd197, 1;

BB2_13:
add.s64 %rd106, %rd1, %rd197;
ld.local.u8 %rs25, [%rd106+888];
add.s64 %rd107, %rd2, %rd197;
st.local.u8 [%rd107+2776], %rs25;
add.s64 %rd198, %rd197, 1;

BB2_14:
add.s64 %rd108, %rd1, %rd198;
ld.local.u8 %rs26, [%rd108+888];
add.s64 %rd109, %rd2, %rd198;
st.local.u8 [%rd109+2776], %rs26;
add.s64 %rd202, %rd198, 1;

BB2_15:
setp.lt.u64	%p12, %rd196, 4;
@%p12 bra BB2_18;

add.s64 %rd201, %rd1, %rd202;
add.s64 %rd200, %rd2, %rd202;

BB2_17:
ld.local.u8 %rs27, [%rd201+888];
ld.local.u8 %rs28, [%rd201+889];
ld.local.u8 %rs29, [%rd201+890];
ld.local.u8 %rs30, [%rd201+891];
st.local.u8 [%rd200+2776], %rs27;
st.local.u8 [%rd200+2777], %rs28;
st.local.u8 [%rd200+2778], %rs29;
st.local.u8 [%rd200+2779], %rs30;
add.s64 %rd201, %rd201, 4;
add.s64 %rd200, %rd200, 4;
add.s64 %rd202, %rd202, 4;
setp.lt.s64	%p13, %rd202, %rd196;
@%p13 bra BB2_17;

BB2_18:
and.b64 %rd28, %rd7, 4294967295;
ld.local.u64 %rd110, [%rd2+1688];
setp.eq.s64	%p14, %rd110, %rd28;
@%p14 bra BB2_20;

st.local.u64 [%rd2+1688], %rd28;

BB2_20:
mul.lo.s64 %rd29, %rd28, 10;
setp.eq.s64	%p15, %rd28, 0;
@%p15 bra BB2_30;

mov.u64 %rd112, 1;
max.u64 %rd30, %rd29, %rd112;
and.b64 %rd31, %rd30, 3;
setp.eq.s64	%p16, %rd31, 0;
mov.u64 %rd207, 0;
@%p16 bra BB2_27;

setp.eq.s64	%p17, %rd31, 1;
mov.u64 %rd113, 0;
mov.u64 %rd204, %rd113;
@%p17 bra BB2_26;

setp.eq.s64	%p18, %rd31, 2;
mov.u64 %rd114, 0;
mov.u64 %rd203, %rd114;
@%p18 bra BB2_25;

mov.u64 %rd116, 0;
st.local.u64 [%rd2+888], %rd116;
mov.u64 %rd203, %rd112;

BB2_25:
shl.b64 %rd117, %rd203, 3;
add.s64 %rd118, %rd2, %rd117;
st.local.u64 [%rd118+888], %rd114;
add.s64 %rd204, %rd203, 1;

BB2_26:
shl.b64 %rd120, %rd204, 3;
add.s64 %rd121, %rd2, %rd120;
st.local.u64 [%rd121+888], %rd113;
add.s64 %rd207, %rd204, 1;

BB2_27:
setp.lt.u64	%p19, %rd30, 4;
@%p19 bra BB2_30;

shl.b64 %rd123, %rd207, 3;
add.s64 %rd206, %rd2, %rd123;

BB2_29:
mov.u64 %rd124, 0;
st.local.u64 [%rd206+888], %rd124;
st.local.u64 [%rd206+896], %rd124;
st.local.u64 [%rd206+904], %rd124;
st.local.u64 [%rd206+912], %rd124;
add.s64 %rd206, %rd206, 32;
add.s64 %rd207, %rd207, 4;
setp.lt.s64	%p20, %rd207, %rd29;
@%p20 bra BB2_29;

BB2_30:
ld.local.u64 %rd125, [%rd2+1776];
setp.eq.s64	%p21, %rd125, %rd28;
@%p21 bra BB2_32;

st.local.u64 [%rd2+1776], %rd28;

BB2_32:
@%p15 bra BB2_42;

and.b64 %rd42, %rd7, 3;
setp.eq.s64	%p23, %rd42, 0;
mov.u64 %rd212, 0;
@%p23 bra BB2_39;

setp.eq.s64	%p24, %rd42, 1;
mov.u64 %rd127, 0;
mov.u64 %rd209, %rd127;
@%p24 bra BB2_38;

setp.eq.s64	%p25, %rd42, 2;
mov.u64 %rd128, 0;
mov.u64 %rd208, %rd128;
@%p25 bra BB2_37;

mov.u64 %rd130, 0;
st.local.u64 [%rd2+1696], %rd130;
mov.u64 %rd208, 1;

BB2_37:
shl.b64 %rd131, %rd208, 3;
add.s64 %rd132, %rd2, %rd131;
st.local.u64 [%rd132+1696], %rd128;
add.s64 %rd209, %rd208, 1;

BB2_38:
shl.b64 %rd134, %rd209, 3;
add.s64 %rd135, %rd2, %rd134;
st.local.u64 [%rd135+1696], %rd127;
add.s64 %rd212, %rd209, 1;

BB2_39:
setp.lt.u64	%p26, %rd28, 4;
@%p26 bra BB2_42;

shl.b64 %rd137, %rd212, 3;
add.s64 %rd211, %rd2, %rd137;

BB2_41:
mov.u64 %rd138, 0;
st.local.u64 [%rd211+1696], %rd138;
st.local.u64 [%rd211+1704], %rd138;
st.local.u64 [%rd211+1712], %rd138;
st.local.u64 [%rd211+1720], %rd138;
add.s64 %rd211, %rd211, 32;
add.s64 %rd212, %rd212, 4;
setp.lt.s64	%p27, %rd212, %rd28;
@%p27 bra BB2_41;

BB2_42:
ld.local.u64 %rd139, [%rd2+1864];
setp.eq.s64	%p28, %rd139, %rd28;
@%p28 bra BB2_44;

st.local.u64 [%rd2+1864], %rd28;

BB2_44:
@%p15 bra BB2_54;

and.b64 %rd53, %rd7, 3;
setp.eq.s64	%p30, %rd53, 0;
mov.u64 %rd217, 0;
@%p30 bra BB2_51;

setp.eq.s64	%p31, %rd53, 1;
mov.u64 %rd141, 0;
mov.u64 %rd214, %rd141;
@%p31 bra BB2_50;

setp.eq.s64	%p32, %rd53, 2;
mov.u64 %rd142, 0;
mov.u64 %rd213, %rd142;
@%p32 bra BB2_49;

mov.u64 %rd144, 0;
st.local.u64 [%rd2+1784], %rd144;
mov.u64 %rd213, 1;

BB2_49:
shl.b64 %rd145, %rd213, 3;
add.s64 %rd146, %rd2, %rd145;
st.local.u64 [%rd146+1784], %rd142;
add.s64 %rd214, %rd213, 1;

BB2_50:
shl.b64 %rd148, %rd214, 3;
add.s64 %rd149, %rd2, %rd148;
st.local.u64 [%rd149+1784], %rd141;
add.s64 %rd217, %rd214, 1;

BB2_51:
setp.lt.u64	%p33, %rd28, 4;
@%p33 bra BB2_54;

shl.b64 %rd151, %rd217, 3;
add.s64 %rd216, %rd2, %rd151;

BB2_53:
mov.u64 %rd152, 0;
st.local.u64 [%rd216+1784], %rd152;
st.local.u64 [%rd216+1792], %rd152;
st.local.u64 [%rd216+1800], %rd152;
st.local.u64 [%rd216+1808], %rd152;
add.s64 %rd216, %rd216, 32;
add.s64 %rd217, %rd217, 4;
setp.lt.s64	%p34, %rd217, %rd28;
@%p34 bra BB2_53;

BB2_54:
mov.u32 %r20, 0;
st.local.u32 [%rd2+2824], %r20;
mov.u64 %rd153, 0;
st.local.u64 [%rd2+2832], %rd153;
setp.eq.s32	%p35, %r7, 0;
@%p35 bra BB2_67;

mov.u32 %r37, %r20;

BB2_56:
cvt.u64.u32	%rd154, %r37;
add.s64 %rd155, %rd2, %rd154;
ld.local.u8 %rs1, [%rd155+2776];
cvt.u32.u16	%r22, %rs1;
cvt.s32.s8 %r9, %r22;
add.s32 %r10, %r9, 3;
max.s32 %r11, %r10, %r20;
mov.u32 %r24, 4;
sub.s32 %r25, %r24, %r9;
add.s32 %r26, %r25, %r11;
cvt.s64.s32	%rd64, %r26;
setp.eq.s32	%p36, %r11, 10;
@%p36 bra BB2_66;

setp.gt.s32	%p37, %r10, 0;
mov.u32 %r27, 7;
sub.s32 %r28, %r27, %r9;
cvt.u64.u32	%rd157, %r28;
selp.b64	%rd158, %rd157, 10, %p37;
mov.u64 %rd159, 1;
max.u64 %rd65, %rd158, %rd159;
and.b64 %rd66, %rd65, 3;
setp.eq.s64	%p38, %rd66, 0;
mov.u64 %rd223, %rd153;
@%p38 bra BB2_63;

setp.eq.s64	%p39, %rd66, 1;
mov.u64 %rd219, 0;
@%p39 bra BB2_62;

setp.eq.s64	%p40, %rd66, 2;
mov.u64 %rd218, 0;
@%p40 bra BB2_61;

mul.wide.u32 %rd163, %r37, 10;
cvt.s64.s32	%rd164, %r11;
add.s64 %rd165, %rd164, %rd163;
shl.b64 %rd166, %rd165, 3;
add.s64 %rd167, %rd2, %rd166;
shl.b64 %rd168, %rd64, 3;
add.s64 %rd169, %rd1, %rd168;
ld.local.f64 %fd22, [%rd169+912];
st.local.f64 [%rd167+888], %fd22;
mov.u64 %rd218, %rd159;

BB2_61:
mul.wide.u32 %rd170, %r37, 10;
cvt.s64.s32	%rd171, %r11;
add.s64 %rd172, %rd171, %rd170;
add.s64 %rd173, %rd172, %rd218;
shl.b64 %rd174, %rd173, 3;
add.s64 %rd175, %rd2, %rd174;
add.s64 %rd176, %rd218, %rd64;
shl.b64 %rd177, %rd176, 3;
add.s64 %rd178, %rd1, %rd177;
ld.local.f64 %fd23, [%rd178+912];
st.local.f64 [%rd175+888], %fd23;
add.s64 %rd219, %rd218, 1;

BB2_62:
mul.wide.u32 %rd179, %r37, 10;
cvt.s64.s32	%rd180, %r11;
add.s64 %rd181, %rd180, %rd179;
add.s64 %rd182, %rd181, %rd219;
shl.b64 %rd183, %rd182, 3;
add.s64 %rd184, %rd2, %rd183;
add.s64 %rd185, %rd219, %rd64;
shl.b64 %rd186, %rd185, 3;
add.s64 %rd187, %rd1, %rd186;
ld.local.f64 %fd24, [%rd187+912];
st.local.f64 [%rd184+888], %fd24;
add.s64 %rd223, %rd219, 1;

BB2_63:
setp.lt.u64	%p41, %rd65, 4;
@%p41 bra BB2_66;

sub.s32 %r31, %r11, %r9;
cvt.s64.s32	%rd188, %r31;
add.s64 %rd189, %rd223, %rd188;
shl.b64 %rd190, %rd189, 3;
add.s64 %rd222, %rd1, %rd190;
mul.wide.u32 %rd191, %r37, 80;
shl.b64 %rd192, %rd223, 3;
add.s64 %rd193, %rd191, %rd192;
mul.wide.s32 %rd194, %r11, 8;
add.s64 %rd195, %rd193, %rd194;
add.s64 %rd221, %rd2, %rd195;
mov.u32 %r32, 10;
sub.s32 %r33, %r32, %r11;
cvt.u64.u32	%rd74, %r33;

BB2_65:
ld.local.f64 %fd25, [%rd222+944];
ld.local.f64 %fd26, [%rd222+952];
ld.local.f64 %fd27, [%rd222+960];
ld.local.f64 %fd28, [%rd222+968];
st.local.f64 [%rd221+888], %fd25;
st.local.f64 [%rd221+896], %fd26;
st.local.f64 [%rd221+904], %fd27;
st.local.f64 [%rd221+912], %fd28;
add.s64 %rd222, %rd222, 32;
add.s64 %rd221, %rd221, 32;
add.s64 %rd223, %rd223, 4;
setp.lt.s64	%p42, %rd223, %rd74;
@%p42 bra BB2_65;

BB2_66:
add.s32 %r37, %r37, 1;
setp.lt.u32	%p43, %r37, %r7;
@%p43 bra BB2_56;

BB2_67:
trap;
}


.visible .entry _ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv(

)
{



ret;
}


