
multifit_gpu_kernels_generated_PulseChiSqSNNLS.cu.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <__nv_save_fatbinhandle_for_managed_rt(void**)>:
//#define PulseChiSqSNNLS_cxx
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # 13 <__nv_save_fatbinhandle_for_managed_rt(void**)+0x13>	f: R_X86_64_PC32	.bss+0x4
  13:	90                   	nop
  14:	5d                   	pop    rbp
  15:	c3                   	ret    

0000000000000016 <__internal_float2half(float, unsigned int&, unsigned int&)>:
#undef __CUDA_HOSTDEVICE__
#undef __CUDA_ALIGN__

#ifndef __CUDACC_RTC__  /* no host functions in NVRTC mode */
static unsigned short __internal_float2half(float f, unsigned int &sign, unsigned int &remainder)
{
  16:	55                   	push   rbp
  17:	48 89 e5             	mov    rbp,rsp
  1a:	f3 0f 11 45 dc       	movss  DWORD PTR [rbp-0x24],xmm0
  1f:	48 89 7d d0          	mov    QWORD PTR [rbp-0x30],rdi
  23:	48 89 75 c8          	mov    QWORD PTR [rbp-0x38],rsi
    unsigned int x, u, shift, exponent, mantissa;
    memcpy(&x, &f, sizeof(f));
  27:	8b 45 dc             	mov    eax,DWORD PTR [rbp-0x24]
  2a:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    u = (x & 0x7fffffffU);
  2d:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  30:	25 ff ff ff 7f       	and    eax,0x7fffffff
  35:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
    sign = ((x >> 16) & 0x8000U);
  38:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  3b:	c1 e8 10             	shr    eax,0x10
  3e:	25 00 80 00 00       	and    eax,0x8000
  43:	89 c2                	mov    edx,eax
  45:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  49:	89 10                	mov    DWORD PTR [rax],edx
    // NaN/+Inf/-Inf
    if (u >= 0x7f800000U) {
  4b:	81 7d fc ff ff 7f 7f 	cmp    DWORD PTR [rbp-0x4],0x7f7fffff
  52:	76 2b                	jbe    7f <__internal_float2half(float, unsigned int&, unsigned int&)+0x69>
        remainder = 0;
  54:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  58:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	81 7d fc 00 00 80 7f 	cmp    DWORD PTR [rbp-0x4],0x7f800000
  65:	75 0e                	jne    75 <__internal_float2half(float, unsigned int&, unsigned int&)+0x5f>
  67:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  6b:	8b 00                	mov    eax,DWORD PTR [rax]
  6d:	80 cc 7c             	or     ah,0x7c
  70:	e9 c7 00 00 00       	jmp    13c <__internal_float2half(float, unsigned int&, unsigned int&)+0x126>
  75:	b8 ff 7f 00 00       	mov    eax,0x7fff
  7a:	e9 bd 00 00 00       	jmp    13c <__internal_float2half(float, unsigned int&, unsigned int&)+0x126>
    }
    // Overflows
    if (u > 0x477fefffU) {
  7f:	81 7d fc ff ef 7f 47 	cmp    DWORD PTR [rbp-0x4],0x477fefff
  86:	76 19                	jbe    a1 <__internal_float2half(float, unsigned int&, unsigned int&)+0x8b>
        remainder = 0x80000000U;
  88:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  8c:	c7 00 00 00 00 80    	mov    DWORD PTR [rax],0x80000000
        return static_cast<unsigned short>(sign | 0x7bffU);
  92:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  96:	8b 00                	mov    eax,DWORD PTR [rax]
  98:	66 0d ff 7b          	or     ax,0x7bff
  9c:	e9 9b 00 00 00       	jmp    13c <__internal_float2half(float, unsigned int&, unsigned int&)+0x126>
    }
    // Normal numbers
    if (u >= 0x38800000U) {
  a1:	81 7d fc ff ff 7f 38 	cmp    DWORD PTR [rbp-0x4],0x387fffff
  a8:	76 27                	jbe    d1 <__internal_float2half(float, unsigned int&, unsigned int&)+0xbb>
        remainder = u << 19;
  aa:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  ad:	c1 e0 13             	shl    eax,0x13
  b0:	89 c2                	mov    edx,eax
  b2:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  b6:	89 10                	mov    DWORD PTR [rax],edx
        u -= 0x38000000U;
  b8:	81 6d fc 00 00 00 38 	sub    DWORD PTR [rbp-0x4],0x38000000
        return static_cast<unsigned short>(sign | (u >> 13));
  bf:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  c3:	8b 00                	mov    eax,DWORD PTR [rax]
  c5:	89 c2                	mov    edx,eax
  c7:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  ca:	c1 e8 0d             	shr    eax,0xd
  cd:	09 d0                	or     eax,edx
  cf:	eb 6b                	jmp    13c <__internal_float2half(float, unsigned int&, unsigned int&)+0x126>
    }
    // +0/-0
    if (u < 0x33000001U) {
  d1:	81 7d fc 00 00 00 33 	cmp    DWORD PTR [rbp-0x4],0x33000000
  d8:	77 11                	ja     eb <__internal_float2half(float, unsigned int&, unsigned int&)+0xd5>
        remainder = u;
  da:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  de:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
  e1:	89 10                	mov    DWORD PTR [rax],edx
        return static_cast<unsigned short>(sign);
  e3:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
  e7:	8b 00                	mov    eax,DWORD PTR [rax]
  e9:	eb 51                	jmp    13c <__internal_float2half(float, unsigned int&, unsigned int&)+0x126>
    }
    // Denormal numbers
    exponent = u >> 23;
  eb:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  ee:	c1 e8 17             	shr    eax,0x17
  f1:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
    mantissa = (u & 0x7fffffU);
  f4:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  f7:	25 ff ff 7f 00       	and    eax,0x7fffff
  fc:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
    shift = 0x7eU - exponent;
  ff:	b8 7e 00 00 00       	mov    eax,0x7e
 104:	2b 45 f8             	sub    eax,DWORD PTR [rbp-0x8]
 107:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
    mantissa |= 0x800000U;
 10a:	81 4d f4 00 00 80 00 	or     DWORD PTR [rbp-0xc],0x800000
    remainder = mantissa << (32 - shift);
 111:	b8 20 00 00 00       	mov    eax,0x20
 116:	2b 45 f0             	sub    eax,DWORD PTR [rbp-0x10]
 119:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
 11c:	89 c1                	mov    ecx,eax
 11e:	d3 e2                	shl    edx,cl
 120:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
 124:	89 10                	mov    DWORD PTR [rax],edx
    return static_cast<unsigned short>(sign | (mantissa >> shift));
 126:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
 12a:	8b 00                	mov    eax,DWORD PTR [rax]
 12c:	89 c6                	mov    esi,eax
 12e:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 131:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
 134:	89 c1                	mov    ecx,eax
 136:	d3 ea                	shr    edx,cl
 138:	89 d0                	mov    eax,edx
 13a:	09 f0                	or     eax,esi
}
 13c:	5d                   	pop    rbp
 13d:	c3                   	ret    

000000000000013e <__internal_half2float(unsigned short)>:
    return val;
}

#ifndef __CUDACC_RTC__  /* no host functions in NVRTC mode */
static float __internal_half2float(unsigned short h)
{
 13e:	55                   	push   rbp
 13f:	48 89 e5             	mov    rbp,rsp
 142:	89 f8                	mov    eax,edi
 144:	66 89 45 dc          	mov    WORD PTR [rbp-0x24],ax
    unsigned int sign = ((h >> 15) & 1);
 148:	0f b7 45 dc          	movzx  eax,WORD PTR [rbp-0x24]
 14c:	66 c1 e8 0f          	shr    ax,0xf
 150:	0f b7 c0             	movzx  eax,ax
 153:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
    unsigned int exponent = ((h >> 10) & 0x1f);
 156:	0f b7 45 dc          	movzx  eax,WORD PTR [rbp-0x24]
 15a:	c1 f8 0a             	sar    eax,0xa
 15d:	83 e0 1f             	and    eax,0x1f
 160:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
    unsigned int mantissa = ((h & 0x3ff) << 13);
 163:	0f b7 45 dc          	movzx  eax,WORD PTR [rbp-0x24]
 167:	c1 e0 0d             	shl    eax,0xd
 16a:	25 00 e0 7f 00       	and    eax,0x7fe000
 16f:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
    float f;
    if (exponent == 0x1fU) { /* NaN or Inf */
 172:	83 7d f8 1f          	cmp    DWORD PTR [rbp-0x8],0x1f
 176:	75 26                	jne    19e <__internal_half2float(unsigned short)+0x60>
        mantissa = (mantissa ? (sign = 0, 0x7fffffU) : 0);
 178:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 17b:	85 c0                	test   eax,eax
 17d:	74 0e                	je     18d <__internal_half2float(unsigned short)+0x4f>
 17f:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
 186:	b8 ff ff 7f 00       	mov    eax,0x7fffff
 18b:	eb 05                	jmp    192 <__internal_half2float(unsigned short)+0x54>
 18d:	b8 00 00 00 00       	mov    eax,0x0
 192:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
        exponent = 0xffU;
 195:	c7 45 f8 ff 00 00 00 	mov    DWORD PTR [rbp-0x8],0xff
 19c:	eb 44                	jmp    1e2 <__internal_half2float(unsigned short)+0xa4>
    } else if (!exponent) { /* Denorm or Zero */
 19e:	83 7d f8 00          	cmp    DWORD PTR [rbp-0x8],0x0
 1a2:	75 3a                	jne    1de <__internal_half2float(unsigned short)+0xa0>
        if (mantissa) {
 1a4:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 1a7:	85 c0                	test   eax,eax
 1a9:	74 37                	je     1e2 <__internal_half2float(unsigned short)+0xa4>
            unsigned int msb;
            exponent = 0x71U;
 1ab:	c7 45 f8 71 00 00 00 	mov    DWORD PTR [rbp-0x8],0x71
            do {
                msb = (mantissa & 0x400000U);
 1b2:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 1b5:	25 00 00 40 00       	and    eax,0x400000
 1ba:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
                mantissa <<= 1; /* normalize */
 1bd:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 1c0:	01 c0                	add    eax,eax
 1c2:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
                --exponent;
 1c5:	83 6d f8 01          	sub    DWORD PTR [rbp-0x8],0x1
            } while (!msb);
 1c9:	83 7d f4 00          	cmp    DWORD PTR [rbp-0xc],0x0
 1cd:	75 02                	jne    1d1 <__internal_half2float(unsigned short)+0x93>
            do {
 1cf:	eb e1                	jmp    1b2 <__internal_half2float(unsigned short)+0x74>
            mantissa &= 0x7fffffU; /* 1.mantissa is implicit */
 1d1:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 1d4:	25 ff ff 7f 00       	and    eax,0x7fffff
 1d9:	89 45 f0             	mov    DWORD PTR [rbp-0x10],eax
 1dc:	eb 04                	jmp    1e2 <__internal_half2float(unsigned short)+0xa4>
        }
    } else {
        exponent += 0x70U;
 1de:	83 45 f8 70          	add    DWORD PTR [rbp-0x8],0x70
    }
    unsigned int u = ((sign << 31) | (exponent << 23) | mantissa);
 1e2:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 1e5:	c1 e0 1f             	shl    eax,0x1f
 1e8:	89 c2                	mov    edx,eax
 1ea:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
 1ed:	c1 e0 17             	shl    eax,0x17
 1f0:	09 c2                	or     edx,eax
 1f2:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
 1f5:	09 d0                	or     eax,edx
 1f7:	89 45 e8             	mov    DWORD PTR [rbp-0x18],eax
    memcpy(&f, &u, sizeof(u));
 1fa:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
 1fd:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    return f;
 200:	f3 0f 10 45 ec       	movss  xmm0,DWORD PTR [rbp-0x14]
}
 205:	5d                   	pop    rbp
 206:	c3                   	ret    

0000000000000207 <thrust::cuda_cub::throw_on_error(cudaError, char const*)>:
#endif
}

static void __host__ __device__ 
throw_on_error(cudaError_t status, char const *msg)
{
 207:	55                   	push   rbp
 208:	48 89 e5             	mov    rbp,rsp
 20b:	41 54                	push   r12
 20d:	53                   	push   rbx
 20e:	48 83 ec 10          	sub    rsp,0x10
 212:	89 7d ec             	mov    DWORD PTR [rbp-0x14],edi
 215:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  if (cudaSuccess != status)
 219:	83 7d ec 00          	cmp    DWORD PTR [rbp-0x14],0x0
 21d:	74 5e                	je     27d <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x76>
  {
#if !defined(__CUDA_ARCH__)
    throw thrust::system_error(status, thrust::cuda_category(), msg);
 21f:	bf 40 00 00 00       	mov    edi,0x40
 224:	e8 00 00 00 00       	call   229 <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x22>	225: R_X86_64_PLT32	__cxa_allocate_exception-0x4
 229:	48 89 c3             	mov    rbx,rax
 22c:	e8 00 00 00 00       	call   231 <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x2a>	22d: R_X86_64_PLT32	thrust::system::cuda_category()-0x4
 231:	48 89 c6             	mov    rsi,rax
 234:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
 237:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
 23b:	48 89 d1             	mov    rcx,rdx
 23e:	48 89 f2             	mov    rdx,rsi
 241:	89 c6                	mov    esi,eax
 243:	48 89 df             	mov    rdi,rbx
 246:	e8 00 00 00 00       	call   24b <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x44>	247: R_X86_64_PLT32	thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)-0x4
 24b:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 252 <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x4b>	24e: R_X86_64_REX_GOTPCRELX	thrust::system::system_error::~system_error()-0x4
 252:	48 89 c2             	mov    rdx,rax
 255:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 25c <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x55>	258: R_X86_64_REX_GOTPCRELX	typeinfo for thrust::system::system_error-0x4
 25c:	48 89 c6             	mov    rsi,rax
 25f:	48 89 df             	mov    rdi,rbx
 262:	e8 00 00 00 00       	call   267 <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x60>	263: R_X86_64_PLT32	__cxa_throw-0x4
 267:	49 89 c4             	mov    r12,rax
 26a:	48 89 df             	mov    rdi,rbx
 26d:	e8 00 00 00 00       	call   272 <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x6b>	26e: R_X86_64_PLT32	__cxa_free_exception-0x4
 272:	4c 89 e0             	mov    rax,r12
 275:	48 89 c7             	mov    rdi,rax
 278:	e8 00 00 00 00       	call   27d <thrust::cuda_cub::throw_on_error(cudaError, char const*)+0x76>	279: R_X86_64_PLT32	_Unwind_Resume-0x4
    printf("Error %d: %s \n", (int)status, msg);
#endif
    cuda_cub::terminate();
#endif
  }
}
 27d:	90                   	nop
 27e:	48 83 c4 10          	add    rsp,0x10
 282:	5b                   	pop    rbx
 283:	41 5c                	pop    r12
 285:	5d                   	pop    rbp
 286:	c3                   	ret    
 287:	90                   	nop

0000000000000288 <PulseChiSqSNNLS::DoFit(Eigen::Matrix<double, 10, 1, 0, 10, 1> const&, Eigen::Matrix<double, 10, 10, 0, 10, 10> const&, double, Eigen::Matrix<char, -1, 1, 0, 10, 1> const&, Eigen::Matrix<double, 19, 1, 0, 19, 1> const&, Eigen::Matrix<double, 19, 19, 0, 19, 19> const&)>:
  *result = pulse.DoFit(args.samples, args.samplecor, args.pederr, args.bxs, args.fullpulse, args.fullpulsecov);
}

__device__ bool PulseChiSqSNNLS::DoFit(const SampleVector &samples, const SampleMatrix &samplecor, 
                                       double pederr, const BXVector &bxs, const FullSampleVector &fullpulse,
                                       const FullSampleMatrix &fullpulsecov) {
 288:	55                   	push   rbp
 289:	48 89 e5             	mov    rbp,rsp
 28c:	48 83 ec 50          	sub    rsp,0x50
 290:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 294:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
 298:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
 29c:	f2 0f 11 45 d0       	movsd  QWORD PTR [rbp-0x30],xmm0
 2a1:	48 89 4d c8          	mov    QWORD PTR [rbp-0x38],rcx
 2a5:	4c 89 45 c0          	mov    QWORD PTR [rbp-0x40],r8
 2a9:	4c 89 4d b8          	mov    QWORD PTR [rbp-0x48],r9
 2ad:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
  
  _chisq = chisq0;  
  
  return status;
  
}
 2b4:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 2b7:	89 c7                	mov    edi,eax
 2b9:	e8 00 00 00 00       	call   2be <PulseChiSqSNNLS::Minimize(Eigen::Matrix<double, 10, 10, 0, 10, 10> const&, double, Eigen::Matrix<double, 19, 19, 0, 19, 19> const&)>	2ba: R_X86_64_PLT32	exit-0x4

00000000000002be <PulseChiSqSNNLS::Minimize(Eigen::Matrix<double, 10, 10, 0, 10, 10> const&, double, Eigen::Matrix<double, 19, 19, 0, 19, 19> const&)>:

__device__ bool PulseChiSqSNNLS::Minimize(const SampleMatrix &samplecor, double pederr, 
                                          const FullSampleMatrix &fullpulsecov) {
 2be:	55                   	push   rbp
 2bf:	48 89 e5             	mov    rbp,rsp
 2c2:	48 83 ec 30          	sub    rsp,0x30
 2c6:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 2ca:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
 2ce:	f2 0f 11 45 d8       	movsd  QWORD PTR [rbp-0x28],xmm0
 2d3:	48 89 55 d0          	mov    QWORD PTR [rbp-0x30],rdx
 2d7:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
    ++iter;    
  }  
  
  return status;  
  
}
 2de:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 2e1:	89 c7                	mov    edi,eax
 2e3:	e8 00 00 00 00       	call   2e8 <PulseChiSqSNNLS::updateCov(Eigen::Matrix<double, 10, 10, 0, 10, 10> const&, double, Eigen::Matrix<double, 19, 19, 0, 19, 19> const&)>	2e4: R_X86_64_PLT32	exit-0x4

00000000000002e8 <PulseChiSqSNNLS::updateCov(Eigen::Matrix<double, 10, 10, 0, 10, 10> const&, double, Eigen::Matrix<double, 19, 19, 0, 19, 19> const&)>:

__device__ bool PulseChiSqSNNLS::updateCov(const SampleMatrix &samplecor, double pederr,
                                           const FullSampleMatrix &fullpulsecov) {
 2e8:	55                   	push   rbp
 2e9:	48 89 e5             	mov    rbp,rsp
 2ec:	48 83 ec 30          	sub    rsp,0x30
 2f0:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 2f4:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
 2f8:	f2 0f 11 45 d8       	movsd  QWORD PTR [rbp-0x28],xmm0
 2fd:	48 89 55 d0          	mov    QWORD PTR [rbp-0x30],rdx
 301:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
//   std::cout << " updateCov " << " done "  << std::endl;
  
  bool status = true;
  return status;
  
}
 308:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 30b:	89 c7                	mov    edi,eax
 30d:	e8 00 00 00 00       	call   312 <PulseChiSqSNNLS::ComputeChiSq()>	30e: R_X86_64_PLT32	exit-0x4

0000000000000312 <PulseChiSqSNNLS::ComputeChiSq()>:

__device__ double PulseChiSqSNNLS::ComputeChiSq() {
 312:	55                   	push   rbp
 313:	48 89 e5             	mov    rbp,rsp
 316:	48 83 ec 20          	sub    rsp,0x20
 31a:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 31e:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
  
  // TODO: port Eigen::LLT solve to gpu
  // return _covdecomp.matrixL().solve(_pulsemat*_ampvec - _sampvec).squaredNorm();
  return 1.0;
  
}
 325:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 328:	89 c7                	mov    edi,eax
 32a:	e8 00 00 00 00       	call   32f <PulseChiSqSNNLS::ComputeChiSq()+0x1d>	32b: R_X86_64_PLT32	exit-0x4
 32f:	90                   	nop

0000000000000330 <PulseChiSqSNNLS::ComputeApproxUncertainty(unsigned int)>:

__device__ double PulseChiSqSNNLS::ComputeApproxUncertainty(unsigned int ipulse) {
 330:	55                   	push   rbp
 331:	48 89 e5             	mov    rbp,rsp
 334:	48 83 ec 20          	sub    rsp,0x20
 338:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 33c:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
 33f:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
  // TODO: port Eigen::LLT solve to gpu
  // return 1./_covdecomp.matrixL().solve(_pulsemat.col(ipulse)).norm();

  return 1.;
  
}
 346:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 349:	89 c7                	mov    edi,eax
 34b:	e8 00 00 00 00       	call   350 <PulseChiSqSNNLS::NNLS()>	34c: R_X86_64_PLT32	exit-0x4

0000000000000350 <PulseChiSqSNNLS::NNLS()>:

__device__ bool PulseChiSqSNNLS::NNLS() {
 350:	55                   	push   rbp
 351:	48 89 e5             	mov    rbp,rsp
 354:	48 83 ec 20          	sub    rsp,0x20
 358:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
 35c:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [rbp-0x4],0x1
//   std::cout << "     -> _ampvec = " << _ampvec << std::endl;
  
  return true;
  
  
}
 363:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 366:	89 c7                	mov    edi,eax
 368:	e8 00 00 00 00       	call   36d <PulseChiSqSNNLS::NNLS()+0x1d>	369: R_X86_64_PLT32	exit-0x4
 36d:	90                   	nop

000000000000036e <PulseChiSqSNNLS::PulseChiSqSNNLS()>:

__device__ __host__ PulseChiSqSNNLS::PulseChiSqSNNLS() : _chisq(0.), _computeErrors(true) {}
 36e:	55                   	push   rbp
 36f:	48 89 e5             	mov    rbp,rsp
 372:	48 83 ec 10          	sub    rsp,0x10
 376:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 37a:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 381 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x13>	37d: R_X86_64_REX_GOTPCRELX	vtable for PulseChiSqSNNLS-0x4
 381:	48 8d 50 10          	lea    rdx,[rax+0x10]
 385:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 389:	48 89 10             	mov    QWORD PTR [rax],rdx
 38c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 390:	48 83 c0 08          	add    rax,0x8
 394:	48 89 c7             	mov    rdi,rax
 397:	e8 00 00 00 00       	call   39c <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x2e>	398: R_X86_64_PLT32	Eigen::Matrix<double, 10, 1, 0, 10, 1>::Matrix()-0x4
 39c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3a0:	48 83 c0 58          	add    rax,0x58
 3a4:	48 89 c7             	mov    rdi,rax
 3a7:	e8 00 00 00 00       	call   3ac <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x3e>	3a8: R_X86_64_PLT32	Eigen::Matrix<double, 10, 10, 0, 10, 10>::Matrix()-0x4
 3ac:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3b0:	48 05 78 03 00 00    	add    rax,0x378
 3b6:	48 89 c7             	mov    rdi,rax
 3b9:	e8 00 00 00 00       	call   3be <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x50>	3ba: R_X86_64_PLT32	Eigen::Matrix<double, 10, -1, 0, 10, 10>::Matrix()-0x4
 3be:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3c2:	48 05 a0 06 00 00    	add    rax,0x6a0
 3c8:	48 89 c7             	mov    rdi,rax
 3cb:	e8 00 00 00 00       	call   3d0 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x62>	3cc: R_X86_64_PLT32	Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()-0x4
 3d0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3d4:	48 05 f8 06 00 00    	add    rax,0x6f8
 3da:	48 89 c7             	mov    rdi,rax
 3dd:	e8 00 00 00 00       	call   3e2 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x74>	3de: R_X86_64_PLT32	Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()-0x4
 3e2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3e6:	48 05 50 07 00 00    	add    rax,0x750
 3ec:	48 89 c7             	mov    rdi,rax
 3ef:	e8 00 00 00 00       	call   3f4 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x86>	3f0: R_X86_64_PLT32	Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()-0x4
 3f4:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 3f8:	48 05 a8 07 00 00    	add    rax,0x7a8
 3fe:	48 89 c7             	mov    rdi,rax
 401:	e8 00 00 00 00       	call   406 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0x98>	402: R_X86_64_PLT32	Eigen::LLT<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::LLT()-0x4
 406:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 40a:	48 05 d8 0a 00 00    	add    rax,0xad8
 410:	48 89 c7             	mov    rdi,rax
 413:	e8 00 00 00 00       	call   418 <PulseChiSqSNNLS::PulseChiSqSNNLS()+0xaa>	414: R_X86_64_PLT32	Eigen::Matrix<char, -1, 1, 0, 10, 1>::Matrix()-0x4
 418:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 41c:	48 05 f0 0a 00 00    	add    rax,0xaf0
 422:	48 89 c7             	mov    rdi,rax
 425:	e8 00 00 00 00       	call   42a <PulseChiSqSNNLS::PulseChiSqSNNLS()+0xbc>	426: R_X86_64_PLT32	Eigen::Matrix<char, -1, 1, 0, 10, 1>::Matrix()-0x4
 42a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 42e:	66 0f ef c0          	pxor   xmm0,xmm0
 432:	f2 0f 11 80 10 0b 00 00 	movsd  QWORD PTR [rax+0xb10],xmm0
 43a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 43e:	c6 80 18 0b 00 00 01 	mov    BYTE PTR [rax+0xb18],0x1
 445:	90                   	nop
 446:	c9                   	leave  
 447:	c3                   	ret    

0000000000000448 <PulseChiSqSNNLS::~PulseChiSqSNNLS()>:
 448:	55                   	push   rbp
 449:	48 89 e5             	mov    rbp,rsp
 44c:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 450:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 457 <PulseChiSqSNNLS::~PulseChiSqSNNLS()+0xf>	453: R_X86_64_REX_GOTPCRELX	vtable for PulseChiSqSNNLS-0x4
 457:	48 8d 50 10          	lea    rdx,[rax+0x10]
 45b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 45f:	48 89 10             	mov    QWORD PTR [rax],rdx
 462:	90                   	nop
 463:	5d                   	pop    rbp
 464:	c3                   	ret    
 465:	90                   	nop

0000000000000466 <PulseChiSqSNNLS::~PulseChiSqSNNLS()>:
 466:	55                   	push   rbp
 467:	48 89 e5             	mov    rbp,rsp
 46a:	48 83 ec 10          	sub    rsp,0x10
 46e:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 472:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 476:	48 89 c7             	mov    rdi,rax
 479:	e8 00 00 00 00       	call   47e <PulseChiSqSNNLS::~PulseChiSqSNNLS()+0x18>	47a: R_X86_64_PLT32	PulseChiSqSNNLS::~PulseChiSqSNNLS()-0x4
 47e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 482:	be 20 0b 00 00       	mov    esi,0xb20
 487:	48 89 c7             	mov    rdi,rax
 48a:	e8 00 00 00 00       	call   48f <PulseChiSqSNNLS::~PulseChiSqSNNLS()+0x29>	48b: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
 48f:	c9                   	leave  
 490:	c3                   	ret    

0000000000000491 <____nv_dummy_param_ref(void*)>:
#else /* __GNUC__ */
#define __nv_dummy_param_ref(param) \
        { volatile static void **__ref; __ref = (volatile void **)param; }
#endif /* __GNUC__ */

static void ____nv_dummy_param_ref(void *param) __nv_dummy_param_ref(param)
 491:	55                   	push   rbp
 492:	48 89 e5             	mov    rbp,rsp
 495:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 499:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 49d:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # 4a4 <____nv_dummy_param_ref(void*)+0x13>	4a0: R_X86_64_PC32	.bss+0x24
 4a4:	90                   	nop
 4a5:	5d                   	pop    rbp
 4a6:	c3                   	ret    

00000000000004a7 <__cudaUnregisterBinaryUtil()>:
}

static void **__cudaFatCubinHandle;

static void __cdecl __cudaUnregisterBinaryUtil(void)
{
 4a7:	55                   	push   rbp
 4a8:	48 89 e5             	mov    rbp,rsp
  ____nv_dummy_param_ref((void *)&__cudaFatCubinHandle);
 4ab:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # 4b2 <__cudaUnregisterBinaryUtil()+0xb>	4ae: R_X86_64_PC32	.bss+0x2c
 4b2:	e8 da ff ff ff       	call   491 <____nv_dummy_param_ref(void*)>
  __cudaUnregisterFatBinary(__cudaFatCubinHandle);
 4b7:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 4be <__cudaUnregisterBinaryUtil()+0x17>	4ba: R_X86_64_PC32	.bss+0x2c
 4be:	48 89 c7             	mov    rdi,rax
 4c1:	e8 00 00 00 00       	call   4c6 <__cudaUnregisterBinaryUtil()+0x1f>	4c2: R_X86_64_PLT32	__cudaUnregisterFatBinary-0x4
}
 4c6:	90                   	nop
 4c7:	5d                   	pop    rbp
 4c8:	c3                   	ret    

00000000000004c9 <__nv_init_managed_rt_with_module(void**)>:

static char __nv_init_managed_rt_with_module(void **handle)
{
 4c9:	55                   	push   rbp
 4ca:	48 89 e5             	mov    rbp,rsp
 4cd:	48 83 ec 10          	sub    rsp,0x10
 4d1:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
  return __cudaInitModule(handle);
 4d5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 4d9:	48 89 c7             	mov    rdi,rax
 4dc:	e8 00 00 00 00       	call   4e1 <__nv_init_managed_rt_with_module(void**)+0x18>	4dd: R_X86_64_PLT32	__cudaInitModule-0x4
}
 4e1:	c9                   	leave  
 4e2:	c3                   	ret    

00000000000004e3 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)>:
 4e3:	55                   	push   rbp
 4e4:	48 89 e5             	mov    rbp,rsp
 4e7:	48 83 ec 60          	sub    rsp,0x60
 4eb:	48 89 7d a8          	mov    QWORD PTR [rbp-0x58],rdi
 4ef:	48 89 75 a0          	mov    QWORD PTR [rbp-0x60],rsi
 4f3:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
 4fa:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 4fd:	48 98                	cdqe   
 4ff:	48 8d 55 a8          	lea    rdx,[rbp-0x58]
 503:	48 89 54 c5 e0       	mov    QWORD PTR [rbp+rax*8-0x20],rdx
 508:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
 50c:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
 50f:	48 98                	cdqe   
 511:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
 515:	48 89 54 c5 e0       	mov    QWORD PTR [rbp+rax*8-0x20],rdx
 51a:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
 51e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 525 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x42>	521: R_X86_64_REX_GOTPCRELX	DoFitGPU(_DoFitArgs*, double*)-0x4
 525:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # 52c <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x49>	528: R_X86_64_PC32	.bss+0x34
 52c:	48 8d 45 d0          	lea    rax,[rbp-0x30]
 530:	b9 01 00 00 00       	mov    ecx,0x1
 535:	ba 01 00 00 00       	mov    edx,0x1
 53a:	be 01 00 00 00       	mov    esi,0x1
 53f:	48 89 c7             	mov    rdi,rax
 542:	e8 00 00 00 00       	call   547 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x64>	543: R_X86_64_PLT32	dim3::dim3(unsigned int, unsigned int, unsigned int)-0x4
 547:	48 8d 45 c0          	lea    rax,[rbp-0x40]
 54b:	b9 01 00 00 00       	mov    ecx,0x1
 550:	ba 01 00 00 00       	mov    edx,0x1
 555:	be 01 00 00 00       	mov    esi,0x1
 55a:	48 89 c7             	mov    rdi,rax
 55d:	e8 00 00 00 00       	call   562 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x7f>	55e: R_X86_64_PLT32	dim3::dim3(unsigned int, unsigned int, unsigned int)-0x4
 562:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
 566:	48 8d 55 b8          	lea    rdx,[rbp-0x48]
 56a:	48 8d 75 c0          	lea    rsi,[rbp-0x40]
 56e:	48 8d 45 d0          	lea    rax,[rbp-0x30]
 572:	48 89 c7             	mov    rdi,rax
 575:	e8 00 00 00 00       	call   57a <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x97>	576: R_X86_64_PLT32	__cudaPopCallConfiguration-0x4
 57a:	85 c0                	test   eax,eax
 57c:	0f 95 c0             	setne  al
 57f:	84 c0                	test   al,al
 581:	0f 85 8a 00 00 00    	jne    611 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x12e>
 587:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
 58b:	75 45                	jne    5d2 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0xef>
 58d:	48 8b 7d b0          	mov    rdi,QWORD PTR [rbp-0x50]
 591:	48 8b 75 b8          	mov    rsi,QWORD PTR [rbp-0x48]
 595:	48 8d 45 e0          	lea    rax,[rbp-0x20]
 599:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
 59c:	48 63 d2             	movsxd rdx,edx
 59f:	48 c1 e2 03          	shl    rdx,0x3
 5a3:	4c 8d 0c 10          	lea    r9,[rax+rdx*1]
 5a7:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
 5ab:	44 8b 45 c8          	mov    r8d,DWORD PTR [rbp-0x38]
 5af:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
 5b3:	8b 45 d8             	mov    eax,DWORD PTR [rbp-0x28]
 5b6:	57                   	push   rdi
 5b7:	56                   	push   rsi
 5b8:	48 89 d6             	mov    rsi,rdx
 5bb:	89 c2                	mov    edx,eax
 5bd:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 5c4 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0xe1>	5c0: R_X86_64_REX_GOTPCRELX	DoFitGPU(_DoFitArgs*, double*)-0x4
 5c4:	48 89 c7             	mov    rdi,rax
 5c7:	e8 0b 05 00 00       	call   ad7 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)>
 5cc:	48 83 c4 10          	add    rsp,0x10
 5d0:	eb 3f                	jmp    611 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x12e>
 5d2:	48 8b 7d b0          	mov    rdi,QWORD PTR [rbp-0x50]
 5d6:	48 8b 75 b8          	mov    rsi,QWORD PTR [rbp-0x48]
 5da:	4c 8d 4d e0          	lea    r9,[rbp-0x20]
 5de:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
 5e2:	44 8b 45 c8          	mov    r8d,DWORD PTR [rbp-0x38]
 5e6:	48 8b 55 d0          	mov    rdx,QWORD PTR [rbp-0x30]
 5ea:	8b 45 d8             	mov    eax,DWORD PTR [rbp-0x28]
 5ed:	57                   	push   rdi
 5ee:	56                   	push   rsi
 5ef:	48 89 d6             	mov    rsi,rdx
 5f2:	89 c2                	mov    edx,eax
 5f4:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 5fb <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x118>	5f7: R_X86_64_REX_GOTPCRELX	DoFitGPU(_DoFitArgs*, double*)-0x4
 5fb:	48 89 c7             	mov    rdi,rax
 5fe:	e8 d4 04 00 00       	call   ad7 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)>
 603:	48 83 c4 10          	add    rsp,0x10
 607:	eb 08                	jmp    611 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x12e>
 609:	48 89 c7             	mov    rdi,rax
 60c:	e8 00 00 00 00       	call   611 <__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)+0x12e>	60d: R_X86_64_PLT32	_Unwind_Resume-0x4
 611:	c9                   	leave  
 612:	c3                   	ret    

0000000000000613 <DoFitGPU(_DoFitArgs*, double*)>:
__global__ void DoFitGPU(DoFitArgs* parameters, double* result){
 613:	55                   	push   rbp
 614:	48 89 e5             	mov    rbp,rsp
 617:	48 83 ec 10          	sub    rsp,0x10
 61b:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 61f:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
 623:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
 627:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 62b:	48 89 d6             	mov    rsi,rdx
 62e:	48 89 c7             	mov    rdi,rax
 631:	e8 00 00 00 00       	call   636 <DoFitGPU(_DoFitArgs*, double*)+0x23>	632: R_X86_64_PLT32	__device_stub__Z8DoFitGPUP10_DoFitArgsPd(_DoFitArgs*, double*)-0x4
}
 636:	90                   	nop
 637:	c9                   	leave  
 638:	c3                   	ret    

0000000000000639 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()>:
 639:	55                   	push   rbp
 63a:	48 89 e5             	mov    rbp,rsp
 63d:	48 83 ec 40          	sub    rsp,0x40
 641:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
 648:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 64f <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x16>	64b: R_X86_64_REX_GOTPCRELX	void thrust::cuda_cub::cub::EmptyKernel<void>()-0x4
 64f:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # 656 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x1d>	652: R_X86_64_PC32	.bss+0x3c
 656:	48 8d 45 e0          	lea    rax,[rbp-0x20]
 65a:	b9 01 00 00 00       	mov    ecx,0x1
 65f:	ba 01 00 00 00       	mov    edx,0x1
 664:	be 01 00 00 00       	mov    esi,0x1
 669:	48 89 c7             	mov    rdi,rax
 66c:	e8 00 00 00 00       	call   671 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x38>	66d: R_X86_64_PLT32	dim3::dim3(unsigned int, unsigned int, unsigned int)-0x4
 671:	48 8d 45 d0          	lea    rax,[rbp-0x30]
 675:	b9 01 00 00 00       	mov    ecx,0x1
 67a:	ba 01 00 00 00       	mov    edx,0x1
 67f:	be 01 00 00 00       	mov    esi,0x1
 684:	48 89 c7             	mov    rdi,rax
 687:	e8 00 00 00 00       	call   68c <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x53>	688: R_X86_64_PLT32	dim3::dim3(unsigned int, unsigned int, unsigned int)-0x4
 68c:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
 690:	48 8d 55 c8          	lea    rdx,[rbp-0x38]
 694:	48 8d 75 d0          	lea    rsi,[rbp-0x30]
 698:	48 8d 45 e0          	lea    rax,[rbp-0x20]
 69c:	48 89 c7             	mov    rdi,rax
 69f:	e8 00 00 00 00       	call   6a4 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x6b>	6a0: R_X86_64_PLT32	__cudaPopCallConfiguration-0x4
 6a4:	85 c0                	test   eax,eax
 6a6:	0f 95 c0             	setne  al
 6a9:	84 c0                	test   al,al
 6ab:	0f 85 8a 00 00 00    	jne    73b <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x102>
 6b1:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
 6b5:	75 45                	jne    6fc <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0xc3>
 6b7:	48 8b 7d c0          	mov    rdi,QWORD PTR [rbp-0x40]
 6bb:	48 8b 75 c8          	mov    rsi,QWORD PTR [rbp-0x38]
 6bf:	48 8d 45 f0          	lea    rax,[rbp-0x10]
 6c3:	8b 55 fc             	mov    edx,DWORD PTR [rbp-0x4]
 6c6:	48 63 d2             	movsxd rdx,edx
 6c9:	48 c1 e2 03          	shl    rdx,0x3
 6cd:	4c 8d 0c 10          	lea    r9,[rax+rdx*1]
 6d1:	48 8b 4d d0          	mov    rcx,QWORD PTR [rbp-0x30]
 6d5:	44 8b 45 d8          	mov    r8d,DWORD PTR [rbp-0x28]
 6d9:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
 6dd:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
 6e0:	57                   	push   rdi
 6e1:	56                   	push   rsi
 6e2:	48 89 d6             	mov    rsi,rdx
 6e5:	89 c2                	mov    edx,eax
 6e7:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 6ee <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0xb5>	6ea: R_X86_64_REX_GOTPCRELX	void thrust::cuda_cub::cub::EmptyKernel<void>()-0x4
 6ee:	48 89 c7             	mov    rdi,rax
 6f1:	e8 e1 03 00 00       	call   ad7 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)>
 6f6:	48 83 c4 10          	add    rsp,0x10
 6fa:	eb 3f                	jmp    73b <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x102>
 6fc:	48 8b 7d c0          	mov    rdi,QWORD PTR [rbp-0x40]
 700:	48 8b 75 c8          	mov    rsi,QWORD PTR [rbp-0x38]
 704:	4c 8d 4d f0          	lea    r9,[rbp-0x10]
 708:	48 8b 4d d0          	mov    rcx,QWORD PTR [rbp-0x30]
 70c:	44 8b 45 d8          	mov    r8d,DWORD PTR [rbp-0x28]
 710:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
 714:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
 717:	57                   	push   rdi
 718:	56                   	push   rsi
 719:	48 89 d6             	mov    rsi,rdx
 71c:	89 c2                	mov    edx,eax
 71e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 725 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0xec>	721: R_X86_64_REX_GOTPCRELX	void thrust::cuda_cub::cub::EmptyKernel<void>()-0x4
 725:	48 89 c7             	mov    rdi,rax
 728:	e8 aa 03 00 00       	call   ad7 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)>
 72d:	48 83 c4 10          	add    rsp,0x10
 731:	eb 08                	jmp    73b <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x102>
 733:	48 89 c7             	mov    rdi,rax
 736:	e8 00 00 00 00       	call   73b <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()+0x102>	737: R_X86_64_PLT32	_Unwind_Resume-0x4
 73b:	c9                   	leave  
 73c:	c3                   	ret    

000000000000073d <void thrust::cuda_cub::cub::__wrapper__device_stub_EmptyKernel<void>()>:
 73d:	55                   	push   rbp
 73e:	48 89 e5             	mov    rbp,rsp
 741:	e8 f3 fe ff ff       	call   639 <__device_stub__ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv()>
 746:	90                   	nop
 747:	5d                   	pop    rbp
 748:	c3                   	ret    

0000000000000749 <__nv_cudaEntityRegisterCallback(void**)>:
 749:	55                   	push   rbp
 74a:	48 89 e5             	mov    rbp,rsp
 74d:	48 83 ec 10          	sub    rsp,0x10
 751:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 755:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 759:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # 760 <__nv_cudaEntityRegisterCallback(void**)+0x17>	75c: R_X86_64_PC32	.bss+0x44
 760:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 764:	48 89 c7             	mov    rdi,rax
 767:	e8 94 f8 ff ff       	call   0 <__nv_save_fatbinhandle_for_managed_rt(void**)>
 76c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 770:	6a 00                	push   0x0
 772:	6a 00                	push   0x0
 774:	6a 00                	push   0x0
 776:	6a 00                	push   0x0
 778:	41 b9 00 00 00 00    	mov    r9d,0x0
 77e:	41 b8 ff ff ff ff    	mov    r8d,0xffffffff
 784:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 78b <__nv_cudaEntityRegisterCallback(void**)+0x42>	787: R_X86_64_PC32	.rodata+0x1cc
 78b:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 792 <__nv_cudaEntityRegisterCallback(void**)+0x49>	78e: R_X86_64_PC32	.rodata+0x1cc
 792:	48 8b 35 00 00 00 00 	mov    rsi,QWORD PTR [rip+0x0]        # 799 <__nv_cudaEntityRegisterCallback(void**)+0x50>	795: R_X86_64_REX_GOTPCRELX	void thrust::cuda_cub::cub::EmptyKernel<void>()-0x4
 799:	48 89 c7             	mov    rdi,rax
 79c:	e8 00 00 00 00       	call   7a1 <__nv_cudaEntityRegisterCallback(void**)+0x58>	79d: R_X86_64_PLT32	__cudaRegisterFunction-0x4
 7a1:	48 83 c4 20          	add    rsp,0x20
 7a5:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 7a9:	6a 00                	push   0x0
 7ab:	6a 00                	push   0x0
 7ad:	6a 00                	push   0x0
 7af:	6a 00                	push   0x0
 7b1:	41 b9 00 00 00 00    	mov    r9d,0x0
 7b7:	41 b8 ff ff ff ff    	mov    r8d,0xffffffff
 7bd:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 7c4 <__nv_cudaEntityRegisterCallback(void**)+0x7b>	7c0: R_X86_64_PC32	.rodata+0x1f7
 7c4:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 7cb <__nv_cudaEntityRegisterCallback(void**)+0x82>	7c7: R_X86_64_PC32	.rodata+0x1f7
 7cb:	48 8b 35 00 00 00 00 	mov    rsi,QWORD PTR [rip+0x0]        # 7d2 <__nv_cudaEntityRegisterCallback(void**)+0x89>	7ce: R_X86_64_REX_GOTPCRELX	DoFitGPU(_DoFitArgs*, double*)-0x4
 7d2:	48 89 c7             	mov    rdi,rax
 7d5:	e8 00 00 00 00       	call   7da <__nv_cudaEntityRegisterCallback(void**)+0x91>	7d6: R_X86_64_PLT32	__cudaRegisterFunction-0x4
 7da:	48 83 c4 20          	add    rsp,0x20
 7de:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 7e2:	6a 00                	push   0x0
 7e4:	6a 00                	push   0x0
 7e6:	41 b9 01 00 00 00    	mov    r9d,0x1
 7ec:	41 b8 00 00 00 00    	mov    r8d,0x0
 7f2:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 7f9 <__nv_cudaEntityRegisterCallback(void**)+0xb0>	7f5: R_X86_64_PC32	.rodata+0x214
 7f9:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 800 <__nv_cudaEntityRegisterCallback(void**)+0xb7>	7fc: R_X86_64_PC32	.rodata+0x214
 800:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 807 <__nv_cudaEntityRegisterCallback(void**)+0xbe>	803: R_X86_64_PC32	.bss+0x11
 807:	48 89 c7             	mov    rdi,rax
 80a:	e8 00 00 00 00       	call   80f <__nv_cudaEntityRegisterCallback(void**)+0xc6>	80b: R_X86_64_PLT32	__cudaRegisterVar-0x4
 80f:	48 83 c4 10          	add    rsp,0x10
 813:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 817:	6a 00                	push   0x0
 819:	6a 00                	push   0x0
 81b:	41 b9 01 00 00 00    	mov    r9d,0x1
 821:	41 b8 00 00 00 00    	mov    r8d,0x0
 827:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 82e <__nv_cudaEntityRegisterCallback(void**)+0xe5>	82a: R_X86_64_PC32	.rodata+0x28c
 82e:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 835 <__nv_cudaEntityRegisterCallback(void**)+0xec>	831: R_X86_64_PC32	.rodata+0x28c
 835:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 83c <__nv_cudaEntityRegisterCallback(void**)+0xf3>	838: R_X86_64_PC32	.bss+0x1d
 83c:	48 89 c7             	mov    rdi,rax
 83f:	e8 00 00 00 00       	call   844 <__nv_cudaEntityRegisterCallback(void**)+0xfb>	840: R_X86_64_PLT32	__cudaRegisterVar-0x4
 844:	48 83 c4 10          	add    rsp,0x10
 848:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 84c:	6a 00                	push   0x0
 84e:	6a 00                	push   0x0
 850:	41 b9 01 00 00 00    	mov    r9d,0x1
 856:	41 b8 00 00 00 00    	mov    r8d,0x0
 85c:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 863 <__nv_cudaEntityRegisterCallback(void**)+0x11a>	85f: R_X86_64_PC32	.rodata+0x2f4
 863:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 86a <__nv_cudaEntityRegisterCallback(void**)+0x121>	866: R_X86_64_PC32	.rodata+0x2f4
 86a:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 871 <__nv_cudaEntityRegisterCallback(void**)+0x128>	86d: R_X86_64_PC32	.bss+0x12
 871:	48 89 c7             	mov    rdi,rax
 874:	e8 00 00 00 00       	call   879 <__nv_cudaEntityRegisterCallback(void**)+0x130>	875: R_X86_64_PLT32	__cudaRegisterVar-0x4
 879:	48 83 c4 10          	add    rsp,0x10
 87d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 881:	6a 00                	push   0x0
 883:	6a 00                	push   0x0
 885:	41 b9 01 00 00 00    	mov    r9d,0x1
 88b:	41 b8 00 00 00 00    	mov    r8d,0x0
 891:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 898 <__nv_cudaEntityRegisterCallback(void**)+0x14f>	894: R_X86_64_PC32	.rodata+0x35c
 898:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 89f <__nv_cudaEntityRegisterCallback(void**)+0x156>	89b: R_X86_64_PC32	.rodata+0x35c
 89f:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 8a6 <__nv_cudaEntityRegisterCallback(void**)+0x15d>	8a2: R_X86_64_PC32	.bss+0x13
 8a6:	48 89 c7             	mov    rdi,rax
 8a9:	e8 00 00 00 00       	call   8ae <__nv_cudaEntityRegisterCallback(void**)+0x165>	8aa: R_X86_64_PLT32	__cudaRegisterVar-0x4
 8ae:	48 83 c4 10          	add    rsp,0x10
 8b2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 8b6:	6a 00                	push   0x0
 8b8:	6a 00                	push   0x0
 8ba:	41 b9 01 00 00 00    	mov    r9d,0x1
 8c0:	41 b8 00 00 00 00    	mov    r8d,0x0
 8c6:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 8cd <__nv_cudaEntityRegisterCallback(void**)+0x184>	8c9: R_X86_64_PC32	.rodata+0x3c4
 8cd:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 8d4 <__nv_cudaEntityRegisterCallback(void**)+0x18b>	8d0: R_X86_64_PC32	.rodata+0x3c4
 8d4:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 8db <__nv_cudaEntityRegisterCallback(void**)+0x192>	8d7: R_X86_64_PC32	.bss+0x14
 8db:	48 89 c7             	mov    rdi,rax
 8de:	e8 00 00 00 00       	call   8e3 <__nv_cudaEntityRegisterCallback(void**)+0x19a>	8df: R_X86_64_PLT32	__cudaRegisterVar-0x4
 8e3:	48 83 c4 10          	add    rsp,0x10
 8e7:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 8eb:	6a 00                	push   0x0
 8ed:	6a 00                	push   0x0
 8ef:	41 b9 01 00 00 00    	mov    r9d,0x1
 8f5:	41 b8 00 00 00 00    	mov    r8d,0x0
 8fb:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 902 <__nv_cudaEntityRegisterCallback(void**)+0x1b9>	8fe: R_X86_64_PC32	.rodata+0x42c
 902:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 909 <__nv_cudaEntityRegisterCallback(void**)+0x1c0>	905: R_X86_64_PC32	.rodata+0x42c
 909:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 910 <__nv_cudaEntityRegisterCallback(void**)+0x1c7>	90c: R_X86_64_PC32	.bss+0x15
 910:	48 89 c7             	mov    rdi,rax
 913:	e8 00 00 00 00       	call   918 <__nv_cudaEntityRegisterCallback(void**)+0x1cf>	914: R_X86_64_PLT32	__cudaRegisterVar-0x4
 918:	48 83 c4 10          	add    rsp,0x10
 91c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 920:	6a 00                	push   0x0
 922:	6a 00                	push   0x0
 924:	41 b9 01 00 00 00    	mov    r9d,0x1
 92a:	41 b8 00 00 00 00    	mov    r8d,0x0
 930:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 937 <__nv_cudaEntityRegisterCallback(void**)+0x1ee>	933: R_X86_64_PC32	.rodata+0x494
 937:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 93e <__nv_cudaEntityRegisterCallback(void**)+0x1f5>	93a: R_X86_64_PC32	.rodata+0x494
 93e:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 945 <__nv_cudaEntityRegisterCallback(void**)+0x1fc>	941: R_X86_64_PC32	.bss+0x16
 945:	48 89 c7             	mov    rdi,rax
 948:	e8 00 00 00 00       	call   94d <__nv_cudaEntityRegisterCallback(void**)+0x204>	949: R_X86_64_PLT32	__cudaRegisterVar-0x4
 94d:	48 83 c4 10          	add    rsp,0x10
 951:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 955:	6a 00                	push   0x0
 957:	6a 00                	push   0x0
 959:	41 b9 01 00 00 00    	mov    r9d,0x1
 95f:	41 b8 00 00 00 00    	mov    r8d,0x0
 965:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 96c <__nv_cudaEntityRegisterCallback(void**)+0x223>	968: R_X86_64_PC32	.rodata+0x4fc
 96c:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 973 <__nv_cudaEntityRegisterCallback(void**)+0x22a>	96f: R_X86_64_PC32	.rodata+0x4fc
 973:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 97a <__nv_cudaEntityRegisterCallback(void**)+0x231>	976: R_X86_64_PC32	.bss+0x17
 97a:	48 89 c7             	mov    rdi,rax
 97d:	e8 00 00 00 00       	call   982 <__nv_cudaEntityRegisterCallback(void**)+0x239>	97e: R_X86_64_PLT32	__cudaRegisterVar-0x4
 982:	48 83 c4 10          	add    rsp,0x10
 986:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 98a:	6a 00                	push   0x0
 98c:	6a 00                	push   0x0
 98e:	41 b9 01 00 00 00    	mov    r9d,0x1
 994:	41 b8 00 00 00 00    	mov    r8d,0x0
 99a:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 9a1 <__nv_cudaEntityRegisterCallback(void**)+0x258>	99d: R_X86_64_PC32	.rodata+0x564
 9a1:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 9a8 <__nv_cudaEntityRegisterCallback(void**)+0x25f>	9a4: R_X86_64_PC32	.rodata+0x564
 9a8:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 9af <__nv_cudaEntityRegisterCallback(void**)+0x266>	9ab: R_X86_64_PC32	.bss+0x18
 9af:	48 89 c7             	mov    rdi,rax
 9b2:	e8 00 00 00 00       	call   9b7 <__nv_cudaEntityRegisterCallback(void**)+0x26e>	9b3: R_X86_64_PLT32	__cudaRegisterVar-0x4
 9b7:	48 83 c4 10          	add    rsp,0x10
 9bb:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 9bf:	6a 00                	push   0x0
 9c1:	6a 00                	push   0x0
 9c3:	41 b9 01 00 00 00    	mov    r9d,0x1
 9c9:	41 b8 00 00 00 00    	mov    r8d,0x0
 9cf:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # 9d6 <__nv_cudaEntityRegisterCallback(void**)+0x28d>	9d2: R_X86_64_PC32	.rodata+0x5cc
 9d6:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 9dd <__nv_cudaEntityRegisterCallback(void**)+0x294>	9d9: R_X86_64_PC32	.rodata+0x5cc
 9dd:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 9e4 <__nv_cudaEntityRegisterCallback(void**)+0x29b>	9e0: R_X86_64_PC32	.bss+0x19
 9e4:	48 89 c7             	mov    rdi,rax
 9e7:	e8 00 00 00 00       	call   9ec <__nv_cudaEntityRegisterCallback(void**)+0x2a3>	9e8: R_X86_64_PLT32	__cudaRegisterVar-0x4
 9ec:	48 83 c4 10          	add    rsp,0x10
 9f0:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 9f4:	6a 00                	push   0x0
 9f6:	6a 00                	push   0x0
 9f8:	41 b9 01 00 00 00    	mov    r9d,0x1
 9fe:	41 b8 00 00 00 00    	mov    r8d,0x0
 a04:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # a0b <__nv_cudaEntityRegisterCallback(void**)+0x2c2>	a07: R_X86_64_PC32	.rodata+0x634
 a0b:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # a12 <__nv_cudaEntityRegisterCallback(void**)+0x2c9>	a0e: R_X86_64_PC32	.rodata+0x634
 a12:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # a19 <__nv_cudaEntityRegisterCallback(void**)+0x2d0>	a15: R_X86_64_PC32	.bss+0x1a
 a19:	48 89 c7             	mov    rdi,rax
 a1c:	e8 00 00 00 00       	call   a21 <__nv_cudaEntityRegisterCallback(void**)+0x2d8>	a1d: R_X86_64_PLT32	__cudaRegisterVar-0x4
 a21:	48 83 c4 10          	add    rsp,0x10
 a25:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 a29:	6a 00                	push   0x0
 a2b:	6a 00                	push   0x0
 a2d:	41 b9 01 00 00 00    	mov    r9d,0x1
 a33:	41 b8 00 00 00 00    	mov    r8d,0x0
 a39:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # a40 <__nv_cudaEntityRegisterCallback(void**)+0x2f7>	a3c: R_X86_64_PC32	.rodata+0x69c
 a40:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # a47 <__nv_cudaEntityRegisterCallback(void**)+0x2fe>	a43: R_X86_64_PC32	.rodata+0x69c
 a47:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # a4e <__nv_cudaEntityRegisterCallback(void**)+0x305>	a4a: R_X86_64_PC32	.bss+0x1b
 a4e:	48 89 c7             	mov    rdi,rax
 a51:	e8 00 00 00 00       	call   a56 <__nv_cudaEntityRegisterCallback(void**)+0x30d>	a52: R_X86_64_PLT32	__cudaRegisterVar-0x4
 a56:	48 83 c4 10          	add    rsp,0x10
 a5a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 a5e:	6a 00                	push   0x0
 a60:	6a 00                	push   0x0
 a62:	41 b9 01 00 00 00    	mov    r9d,0x1
 a68:	41 b8 00 00 00 00    	mov    r8d,0x0
 a6e:	48 8d 0d 00 00 00 00 	lea    rcx,[rip+0x0]        # a75 <__nv_cudaEntityRegisterCallback(void**)+0x32c>	a71: R_X86_64_PC32	.rodata+0x704
 a75:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # a7c <__nv_cudaEntityRegisterCallback(void**)+0x333>	a78: R_X86_64_PC32	.rodata+0x704
 a7c:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # a83 <__nv_cudaEntityRegisterCallback(void**)+0x33a>	a7f: R_X86_64_PC32	.bss+0x1c
 a83:	48 89 c7             	mov    rdi,rax
 a86:	e8 00 00 00 00       	call   a8b <__nv_cudaEntityRegisterCallback(void**)+0x342>	a87: R_X86_64_PLT32	__cudaRegisterVar-0x4
 a8b:	48 83 c4 10          	add    rsp,0x10
 a8f:	90                   	nop
 a90:	c9                   	leave  
 a91:	c3                   	ret    

0000000000000a92 <__sti____cudaRegisterAll()>:
 a92:	55                   	push   rbp
 a93:	48 89 e5             	mov    rbp,rsp
 a96:	48 83 ec 10          	sub    rsp,0x10
 a9a:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # aa1 <__sti____cudaRegisterAll()+0xf>	a9d: R_X86_64_PC32	.nvFatBinSegment-0x4
 aa1:	e8 00 00 00 00       	call   aa6 <__sti____cudaRegisterAll()+0x14>	aa2: R_X86_64_PLT32	__cudaRegisterFatBinary-0x4
 aa6:	48 89 05 00 00 00 00 	mov    QWORD PTR [rip+0x0],rax        # aad <__sti____cudaRegisterAll()+0x1b>	aa9: R_X86_64_PC32	.bss+0x2c
 aad:	48 8d 05 95 fc ff ff 	lea    rax,[rip+0xfffffffffffffc95]        # 749 <__nv_cudaEntityRegisterCallback(void**)>
 ab4:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
 ab8:	48 8b 15 00 00 00 00 	mov    rdx,QWORD PTR [rip+0x0]        # abf <__sti____cudaRegisterAll()+0x2d>	abb: R_X86_64_PC32	.bss+0x2c
 abf:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 ac3:	48 89 d7             	mov    rdi,rdx
 ac6:	ff d0                	call   rax
 ac8:	48 8d 3d d8 f9 ff ff 	lea    rdi,[rip+0xfffffffffffff9d8]        # 4a7 <__cudaUnregisterBinaryUtil()>
 acf:	e8 00 00 00 00       	call   ad4 <__sti____cudaRegisterAll()+0x42>	ad0: R_X86_64_PLT32	atexit-0x4
 ad4:	90                   	nop
 ad5:	c9                   	leave  
 ad6:	c3                   	ret    

0000000000000ad7 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)>:
 * \note_null_stream
 *
 * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)"
 */
template<class T>
static __inline__ __host__ cudaError_t cudaLaunchKernel(
 ad7:	55                   	push   rbp
 ad8:	48 89 e5             	mov    rbp,rsp
 adb:	48 83 ec 30          	sub    rsp,0x30
 adf:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
 ae3:	48 89 c8             	mov    rax,rcx
 ae6:	44 89 c1             	mov    ecx,r8d
 ae9:	4c 89 4d d0          	mov    QWORD PTR [rbp-0x30],r9
 aed:	48 89 75 e8          	mov    QWORD PTR [rbp-0x18],rsi
 af1:	89 55 f0             	mov    DWORD PTR [rbp-0x10],edx
 af4:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
 af8:	89 4d e0             	mov    DWORD PTR [rbp-0x20],ecx
  void **args,
  size_t sharedMem = 0,
  cudaStream_t stream = 0
)
{
    return ::cudaLaunchKernel((const void *)func, gridDim, blockDim, args, sharedMem, stream);
 afb:	4c 8b 45 d0          	mov    r8,QWORD PTR [rbp-0x30]
 aff:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
 b03:	8b 7d e0             	mov    edi,DWORD PTR [rbp-0x20]
 b06:	48 8b 75 e8          	mov    rsi,QWORD PTR [rbp-0x18]
 b0a:	8b 55 f0             	mov    edx,DWORD PTR [rbp-0x10]
 b0d:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
 b11:	ff 75 18             	push   QWORD PTR [rbp+0x18]
 b14:	ff 75 10             	push   QWORD PTR [rbp+0x10]
 b17:	4d 89 c1             	mov    r9,r8
 b1a:	41 89 f8             	mov    r8d,edi
 b1d:	48 89 c7             	mov    rdi,rax
 b20:	e8 00 00 00 00       	call   b25 <cudaError cudaLaunchKernel<char>(char const*, dim3, dim3, void**, unsigned long, CUstream_st*)+0x4e>	b21: R_X86_64_PLT32	cudaLaunchKernel-0x4
 b25:	48 83 c4 10          	add    rsp,0x10
}
 b29:	c9                   	leave  
 b2a:	c3                   	ret    

0000000000000b2b <__static_initialization_and_destruction_0(int, int)>:
 b2b:	55                   	push   rbp
 b2c:	48 89 e5             	mov    rbp,rsp
 b2f:	53                   	push   rbx
 b30:	48 83 ec 28          	sub    rsp,0x28
 b34:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
 b37:	89 75 d8             	mov    DWORD PTR [rbp-0x28],esi
 b3a:	83 7d dc 01          	cmp    DWORD PTR [rbp-0x24],0x1
 b3e:	0f 85 35 01 00 00    	jne    c79 <__static_initialization_and_destruction_0(int, int)+0x14e>
 b44:	81 7d d8 ff ff 00 00 	cmp    DWORD PTR [rbp-0x28],0xffff
 b4b:	0f 85 28 01 00 00    	jne    c79 <__static_initialization_and_destruction_0(int, int)+0x14e>
  * v(seq(2,last-2)).setOnes();
  * \endcode
  *
  * \sa end
  */
static const Symbolic::SymbolExpr<internal::symbolic_last_tag> last;
 b51:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # b58 <__static_initialization_and_destruction_0(int, int)+0x2d>	b54: R_X86_64_PC32	.bss+0xc
 b58:	e8 00 00 00 00       	call   b5d <__static_initialization_and_destruction_0(int, int)+0x32>	b59: R_X86_64_PLT32	Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>::SymbolExpr()-0x4

#ifndef EIGEN_PARSED_BY_DOXYGEN

#if EIGEN_HAS_CXX14
template<int N>
static const internal::FixedInt<N> fix{};
 b5d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b64 <__static_initialization_and_destruction_0(int, int)+0x39>	b60: R_X86_64_REX_GOTPCRELX	guard variable for Eigen::fix<1>-0x4
 b64:	0f b6 00             	movzx  eax,BYTE PTR [rax]
 b67:	84 c0                	test   al,al
 b69:	75 19                	jne    b84 <__static_initialization_and_destruction_0(int, int)+0x59>
 b6b:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b72 <__static_initialization_and_destruction_0(int, int)+0x47>	b6e: R_X86_64_REX_GOTPCRELX	guard variable for Eigen::fix<1>-0x4
 b72:	c6 00 01             	mov    BYTE PTR [rax],0x1
 b75:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b7c <__static_initialization_and_destruction_0(int, int)+0x51>	b78: R_X86_64_REX_GOTPCRELX	Eigen::fix<1>-0x4
 b7c:	48 89 c7             	mov    rdi,rax
 b7f:	e8 00 00 00 00       	call   b84 <__static_initialization_and_destruction_0(int, int)+0x59>	b80: R_X86_64_PLT32	Eigen::internal::FixedInt<1>::FixedInt()-0x4
#ifdef EIGEN_PARSED_BY_DOXYGEN
static const auto end = last+1;
#else
// Using a FixedExpr<1> expression is important here to make sure the compiler
// can fully optimize the computation starting indices with zero overhead.
static const Symbolic::AddExpr<Symbolic::SymbolExpr<internal::symbolic_last_tag>,Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > end(last+fix<1>());
 b84:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b8b <__static_initialization_and_destruction_0(int, int)+0x60>	b87: R_X86_64_REX_GOTPCRELX	Eigen::fix<1>-0x4
 b8b:	48 89 c7             	mov    rdi,rax
 b8e:	e8 00 00 00 00       	call   b93 <__static_initialization_and_destruction_0(int, int)+0x68>	b8f: R_X86_64_PLT32	Eigen::internal::FixedInt<1>::operator()() const-0x4
 b93:	48 83 ec 08          	sub    rsp,0x8
 b97:	53                   	push   rbx
 b98:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # b9f <__static_initialization_and_destruction_0(int, int)+0x74>	b9b: R_X86_64_PC32	.bss+0xc
 b9f:	e8 00 00 00 00       	call   ba4 <__static_initialization_and_destruction_0(int, int)+0x79>	ba0: R_X86_64_PLT32	Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::operator+<1>(Eigen::internal::FixedInt<1>) const-0x4
 ba4:	48 83 c4 10          	add    rsp,0x10

/** \var all
  * \ingroup Core_Module
  * Can be used as a parameter to DenseBase::operator()(const RowIndices&, const ColIndices&) to index all rows or columns
  */
static const Eigen::internal::all_t all;
 ba8:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # baf <__static_initialization_and_destruction_0(int, int)+0x84>	bab: R_X86_64_PC32	.bss+0xf
 baf:	e8 00 00 00 00       	call   bb4 <__static_initialization_and_destruction_0(int, int)+0x89>	bb0: R_X86_64_PLT32	Eigen::internal::all_t::all_t()-0x4
  extern wostream wclog;	/// Linked to standard error (buffered)
#endif
  //@}

  // For construction of filebuffers for cout, cin, cerr, clog et. al.
  static ios_base::Init __ioinit;
 bb4:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # bbb <__static_initialization_and_destruction_0(int, int)+0x90>	bb7: R_X86_64_PC32	.bss+0x10
 bbb:	e8 00 00 00 00       	call   bc0 <__static_initialization_and_destruction_0(int, int)+0x95>	bbc: R_X86_64_PLT32	std::ios_base::Init::Init()-0x4
 bc0:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # bc7 <__static_initialization_and_destruction_0(int, int)+0x9c>	bc3: R_X86_64_PC32	__dso_handle-0x4
 bc7:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # bce <__static_initialization_and_destruction_0(int, int)+0xa3>	bca: R_X86_64_PC32	.bss+0x10
 bce:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # bd5 <__static_initialization_and_destruction_0(int, int)+0xaa>	bd1: R_X86_64_REX_GOTPCRELX	std::ios_base::Init::~Init()-0x4
 bd5:	48 89 c7             	mov    rdi,rax
 bd8:	e8 00 00 00 00       	call   bdd <__static_initialization_and_destruction_0(int, int)+0xb2>	bd9: R_X86_64_PLT32	__cxa_atexit-0x4


#ifdef __CUDA_ARCH__
static const __device__ tag seq;
#else
static const tag seq;
 bdd:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # be4 <__static_initialization_and_destruction_0(int, int)+0xb9>	be0: R_X86_64_PC32	.bss+0x11
 be4:	e8 00 00 00 00       	call   be9 <__static_initialization_and_destruction_0(int, int)+0xbe>	be5: R_X86_64_PLT32	thrust::system::detail::sequential::tag::tag()-0x4
/*! \p thrust::placeholders::_1 is the placeholder for the first function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<0>::type _1;
#else
static const thrust::detail::functional::placeholder<0>::type _1;
 be9:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # bf0 <__static_initialization_and_destruction_0(int, int)+0xc5>	bec: R_X86_64_PC32	.bss+0x12
 bf0:	e8 00 00 00 00       	call   bf5 <__static_initialization_and_destruction_0(int, int)+0xca>	bf1: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<0u> >::actor()-0x4
/*! \p thrust::placeholders::_2 is the placeholder for the second function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<1>::type _2;
#else
static const thrust::detail::functional::placeholder<1>::type _2;
 bf5:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # bfc <__static_initialization_and_destruction_0(int, int)+0xd1>	bf8: R_X86_64_PC32	.bss+0x13
 bfc:	e8 00 00 00 00       	call   c01 <__static_initialization_and_destruction_0(int, int)+0xd6>	bfd: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<1u> >::actor()-0x4
/*! \p thrust::placeholders::_3 is the placeholder for the third function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<2>::type _3;
#else
static const thrust::detail::functional::placeholder<2>::type _3;
 c01:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c08 <__static_initialization_and_destruction_0(int, int)+0xdd>	c04: R_X86_64_PC32	.bss+0x14
 c08:	e8 00 00 00 00       	call   c0d <__static_initialization_and_destruction_0(int, int)+0xe2>	c09: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<2u> >::actor()-0x4
/*! \p thrust::placeholders::_4 is the placeholder for the fourth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<3>::type _4;
#else
static const thrust::detail::functional::placeholder<3>::type _4;
 c0d:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c14 <__static_initialization_and_destruction_0(int, int)+0xe9>	c10: R_X86_64_PC32	.bss+0x15
 c14:	e8 00 00 00 00       	call   c19 <__static_initialization_and_destruction_0(int, int)+0xee>	c15: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<3u> >::actor()-0x4
/*! \p thrust::placeholders::_5 is the placeholder for the fifth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<4>::type _5;
#else
static const thrust::detail::functional::placeholder<4>::type _5;
 c19:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c20 <__static_initialization_and_destruction_0(int, int)+0xf5>	c1c: R_X86_64_PC32	.bss+0x16
 c20:	e8 00 00 00 00       	call   c25 <__static_initialization_and_destruction_0(int, int)+0xfa>	c21: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<4u> >::actor()-0x4
/*! \p thrust::placeholders::_6 is the placeholder for the sixth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<5>::type _6;
#else
static const thrust::detail::functional::placeholder<5>::type _6;
 c25:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c2c <__static_initialization_and_destruction_0(int, int)+0x101>	c28: R_X86_64_PC32	.bss+0x17
 c2c:	e8 00 00 00 00       	call   c31 <__static_initialization_and_destruction_0(int, int)+0x106>	c2d: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<5u> >::actor()-0x4
/*! \p thrust::placeholders::_7 is the placeholder for the seventh function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<6>::type _7;
#else
static const thrust::detail::functional::placeholder<6>::type _7;
 c31:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c38 <__static_initialization_and_destruction_0(int, int)+0x10d>	c34: R_X86_64_PC32	.bss+0x18
 c38:	e8 00 00 00 00       	call   c3d <__static_initialization_and_destruction_0(int, int)+0x112>	c39: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<6u> >::actor()-0x4
/*! \p thrust::placeholders::_8 is the placeholder for the eighth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<7>::type _8;
#else
static const thrust::detail::functional::placeholder<7>::type _8;
 c3d:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c44 <__static_initialization_and_destruction_0(int, int)+0x119>	c40: R_X86_64_PC32	.bss+0x19
 c44:	e8 00 00 00 00       	call   c49 <__static_initialization_and_destruction_0(int, int)+0x11e>	c45: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<7u> >::actor()-0x4
/*! \p thrust::placeholders::_9 is the placeholder for the ninth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<8>::type _9;
#else
static const thrust::detail::functional::placeholder<8>::type _9;
 c49:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c50 <__static_initialization_and_destruction_0(int, int)+0x125>	c4c: R_X86_64_PC32	.bss+0x1a
 c50:	e8 00 00 00 00       	call   c55 <__static_initialization_and_destruction_0(int, int)+0x12a>	c51: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<8u> >::actor()-0x4
/*! \p thrust::placeholders::_10 is the placeholder for the tenth function parameter.
 */
#ifdef __CUDA_ARCH__
static const __device__ thrust::detail::functional::placeholder<9>::type _10;
#else
static const thrust::detail::functional::placeholder<9>::type _10;
 c55:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c5c <__static_initialization_and_destruction_0(int, int)+0x131>	c58: R_X86_64_PC32	.bss+0x1b
 c5c:	e8 00 00 00 00       	call   c61 <__static_initialization_and_destruction_0(int, int)+0x136>	c5d: R_X86_64_PLT32	thrust::detail::functional::actor<thrust::detail::functional::argument<9u> >::actor()-0x4


#ifdef __CUDA_ARCH__
static const __device__ detail::seq_t seq;
#else
static const detail::seq_t seq;
 c61:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c68 <__static_initialization_and_destruction_0(int, int)+0x13d>	c64: R_X86_64_PC32	.bss+0x1c
 c68:	e8 00 00 00 00       	call   c6d <__static_initialization_and_destruction_0(int, int)+0x142>	c69: R_X86_64_PLT32	thrust::detail::seq_t::seq_t()-0x4
};

#ifdef __CUDA_ARCH__
static const __device__ par_t par;
#else
static const par_t par;
 c6d:	48 8d 3d 00 00 00 00 	lea    rdi,[rip+0x0]        # c74 <__static_initialization_and_destruction_0(int, int)+0x149>	c70: R_X86_64_PC32	.bss+0x1d
 c74:	e8 00 00 00 00       	call   c79 <__static_initialization_and_destruction_0(int, int)+0x14e>	c75: R_X86_64_PLT32	thrust::cuda_cub::par_t::par_t()-0x4
 c79:	90                   	nop
 c7a:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
 c7e:	c9                   	leave  
 c7f:	c3                   	ret    

0000000000000c80 <_GLOBAL__sub_I_tmpxft_00001958_00000000_5_PulseChiSqSNNLS.cudafe1.cpp>:
 c80:	55                   	push   rbp
 c81:	48 89 e5             	mov    rbp,rsp
 c84:	be ff ff 00 00       	mov    esi,0xffff
 c89:	bf 01 00 00 00       	mov    edi,0x1
 c8e:	e8 98 fe ff ff       	call   b2b <__static_initialization_and_destruction_0(int, int)>
 c93:	5d                   	pop    rbp
 c94:	c3                   	ret    

Disassembly of section .text._ZN4dim3C2Ejjj:

0000000000000000 <dim3::dim3(unsigned int, unsigned int, unsigned int)>:
//#define PulseChiSqSNNLS_cxx
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
   b:	89 55 f0             	mov    DWORD PTR [rbp-0x10],edx
   e:	89 4d ec             	mov    DWORD PTR [rbp-0x14],ecx
  11:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  15:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
{
  18:	89 10                	mov    DWORD PTR [rax],edx
  1a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1e:	8b 55 f0             	mov    edx,DWORD PTR [rbp-0x10]
  21:	89 50 04             	mov    DWORD PTR [rax+0x4],edx
  24:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    memcpy(&x, &f, sizeof(f));
  28:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
  2b:	89 50 08             	mov    DWORD PTR [rax+0x8],edx
    u = (x & 0x7fffffffU);
  2e:	90                   	nop
  2f:	5d                   	pop    rbp
  30:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal5all_tC2Ev:

0000000000000000 <Eigen::internal::all_t::all_t()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail21execution_policy_baseINS_6system6detail10sequential3tagEEC2Ev:

0000000000000000 <thrust::detail::execution_policy_base<thrust::system::detail::sequential::tag>::execution_policy_base()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust16execution_policyINS_6system6detail10sequential3tagEEC2Ev:

0000000000000000 <thrust::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()+0x18>	14: R_X86_64_PLT32	thrust::detail::execution_policy_base<thrust::system::detail::sequential::tag>::execution_policy_base()-0x4
{
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail10sequential16execution_policyINS2_3tagEEC2Ev:

0000000000000000 <thrust::system::detail::sequential::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::sequential::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()+0x18>	14: R_X86_64_PLT32	thrust::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail10sequential3tagC2Ev:

0000000000000000 <thrust::system::detail::sequential::tag::tag()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::sequential::tag::tag()+0x18>	14: R_X86_64_PLT32	thrust::system::detail::sequential::execution_policy<thrust::system::detail::sequential::tag>::execution_policy()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system14error_categoryD2Ev:

0000000000000000 <thrust::system::error_category::~error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # f <thrust::system::error_category::~error_category()+0xf>	b: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::error_category-0x4
   f:	48 8d 50 10          	lea    rdx,[rax+0x10]
  13:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  17:	48 89 10             	mov    QWORD PTR [rax],rdx
  1a:	90                   	nop
  1b:	5d                   	pop    rbp
  1c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system14error_categoryD0Ev:

0000000000000000 <thrust::system::error_category::~error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::error_category::~error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::error_category::~error_category()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	be 08 00 00 00       	mov    esi,0x8
  21:	48 89 c7             	mov    rdi,rax
  24:	e8 00 00 00 00       	call   29 <thrust::system::error_category::~error_category()+0x29>	25: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
    memcpy(&x, &f, sizeof(f));
  29:	c9                   	leave  
  2a:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system14error_category23default_error_conditionEi:

0000000000000000 <thrust::system::error_category::default_error_condition(int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 28          	sub    rsp,0x28
   9:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
   d:	89 75 d4             	mov    DWORD PTR [rbp-0x2c],esi
  10:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  14:	8b 4d d4             	mov    ecx,DWORD PTR [rbp-0x2c]
{
  17:	48 8d 45 e0          	lea    rax,[rbp-0x20]
  1b:	89 ce                	mov    esi,ecx
  1d:	48 89 c7             	mov    rdi,rax
  20:	e8 00 00 00 00       	call   25 <thrust::system::error_category::default_error_condition(int) const+0x25>	21: R_X86_64_PLT32	thrust::system::error_condition::error_condition(int, thrust::system::error_category const&)-0x4
  25:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    memcpy(&x, &f, sizeof(f));
  29:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
    u = (x & 0x7fffffffU);
  2d:	48 89 c1             	mov    rcx,rax
  30:	48 89 d3             	mov    rbx,rdx
  33:	89 c8                	mov    eax,ecx
  35:	48 83 c4 28          	add    rsp,0x28
    sign = ((x >> 16) & 0x8000U);
  39:	5b                   	pop    rbx
  3a:	5d                   	pop    rbp
  3b:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system14error_category10equivalentEiRKNS0_15error_conditionE:

0000000000000000 <thrust::system::error_category::equivalent(int, thrust::system::error_condition const&) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 30          	sub    rsp,0x30
   8:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
   c:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
   f:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  13:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
{
  17:	48 8b 00             	mov    rax,QWORD PTR [rax]
  1a:	48 83 c0 18          	add    rax,0x18
  1e:	48 8b 00             	mov    rax,QWORD PTR [rax]
  21:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  24:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
    memcpy(&x, &f, sizeof(f));
  28:	89 ce                	mov    esi,ecx
  2a:	48 89 d7             	mov    rdi,rdx
    u = (x & 0x7fffffffU);
  2d:	ff d0                	call   rax
  2f:	89 c1                	mov    ecx,eax
  31:	48 89 d0             	mov    rax,rdx
  34:	89 4d f0             	mov    DWORD PTR [rbp-0x10],ecx
  37:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    sign = ((x >> 16) & 0x8000U);
  3b:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
  3f:	48 8d 45 f0          	lea    rax,[rbp-0x10]
  43:	48 89 d6             	mov    rsi,rdx
  46:	48 89 c7             	mov    rdi,rax
  49:	e8 00 00 00 00       	call   4e <thrust::system::error_category::equivalent(int, thrust::system::error_condition const&) const+0x4e>	4a: R_X86_64_PLT32	thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)-0x4
    if (u >= 0x7f800000U) {
  4e:	c9                   	leave  
  4f:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system14error_category10equivalentERKNS0_10error_codeEi:

0000000000000000 <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 30          	sub    rsp,0x30
   8:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
   c:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  10:	89 55 dc             	mov    DWORD PTR [rbp-0x24],edx
  13:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
{
  17:	48 89 c7             	mov    rdi,rax
  1a:	e8 00 00 00 00       	call   1f <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x1f>	1b: R_X86_64_PLT32	thrust::system::error_code::category() const-0x4
  1f:	48 89 c2             	mov    rdx,rax
  22:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  26:	48 89 d6             	mov    rsi,rdx
    memcpy(&x, &f, sizeof(f));
  29:	48 89 c7             	mov    rdi,rax
  2c:	e8 00 00 00 00       	call   31 <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x31>	2d: R_X86_64_PLT32	thrust::system::error_category::operator==(thrust::system::error_category const&) const-0x4
    u = (x & 0x7fffffffU);
  31:	84 c0                	test   al,al
  33:	74 18                	je     4d <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x4d>
  35:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    sign = ((x >> 16) & 0x8000U);
  39:	48 89 c7             	mov    rdi,rax
  3c:	e8 00 00 00 00       	call   41 <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x41>	3d: R_X86_64_PLT32	thrust::system::error_code::value() const-0x4
  41:	3b 45 dc             	cmp    eax,DWORD PTR [rbp-0x24]
  44:	75 07                	jne    4d <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x4d>
  46:	b8 01 00 00 00       	mov    eax,0x1
    if (u >= 0x7f800000U) {
  4b:	eb 05                	jmp    52 <thrust::system::error_category::equivalent(thrust::system::error_code const&, int) const+0x52>
  4d:	b8 00 00 00 00       	mov    eax,0x0
  52:	88 45 ff             	mov    BYTE PTR [rbp-0x1],al
        remainder = 0;
  55:	0f b6 45 ff          	movzx  eax,BYTE PTR [rbp-0x1]
  59:	c9                   	leave  
  5a:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system14error_categoryeqERKS1_:

0000000000000000 <thrust::system::error_category::operator==(thrust::system::error_category const&) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 3b 45 f0          	cmp    rax,QWORD PTR [rbp-0x10]
  14:	0f 94 c0             	sete   al
{
  17:	5d                   	pop    rbp
  18:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system14error_categoryC2Ev:

0000000000000000 <thrust::system::error_category::error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # f <thrust::system::error_category::error_category()+0xf>	b: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::error_category-0x4
   f:	48 8d 50 10          	lea    rdx,[rax+0x10]
  13:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  17:	48 89 10             	mov    QWORD PTR [rax],rdx
  1a:	90                   	nop
  1b:	5d                   	pop    rbp
  1c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail22generic_error_categoryC2Ev:

0000000000000000 <thrust::system::detail::generic_error_category::generic_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::generic_error_category::generic_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::error_category::error_category()-0x4
  18:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1f <thrust::system::detail::generic_error_category::generic_error_category()+0x1f>	1b: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::detail::generic_error_category-0x4
  1f:	48 8d 50 10          	lea    rdx,[rax+0x10]
  23:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    memcpy(&x, &f, sizeof(f));
  27:	48 89 10             	mov    QWORD PTR [rax],rdx
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system6detail22generic_error_category4nameEv:

0000000000000000 <thrust::system::detail::generic_error_category::name() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8d 05 00 00 00 00 	lea    rax,[rip+0x0]        # f <thrust::system::detail::generic_error_category::name() const+0xf>	b: R_X86_64_PC32	.rodata+0x1a0
   f:	5d                   	pop    rbp
  10:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system6detail22generic_error_category7messageB5cxx11Ei:

0000000000000000 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	41 54                	push   r12
   6:	53                   	push   rbx
   7:	48 83 ec 30          	sub    rsp,0x30
   b:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
   f:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
  13:	89 55 cc             	mov    DWORD PTR [rbp-0x34],edx
{
  16:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1d <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x1d>	19: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  1d:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  20:	84 c0                	test   al,al
  22:	0f 94 c0             	sete   al
  25:	84 c0                	test   al,al
    memcpy(&x, &f, sizeof(f));
  27:	0f 84 81 00 00 00    	je     ae <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xae>
    u = (x & 0x7fffffffU);
  2d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 34 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x34>	30: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  34:	48 89 c7             	mov    rdi,rax
  37:	e8 00 00 00 00       	call   3c <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x3c>	38: R_X86_64_PLT32	__cxa_guard_acquire-0x4
    sign = ((x >> 16) & 0x8000U);
  3c:	85 c0                	test   eax,eax
  3e:	0f 95 c0             	setne  al
  41:	84 c0                	test   al,al
  43:	74 69                	je     ae <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xae>
  45:	bb 00 00 00 00       	mov    ebx,0x0
  4a:	48 8d 45 ee          	lea    rax,[rbp-0x12]
    if (u >= 0x7f800000U) {
  4e:	48 89 c7             	mov    rdi,rax
  51:	e8 00 00 00 00       	call   56 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x56>	52: R_X86_64_PLT32	std::allocator<char>::allocator()-0x4
        remainder = 0;
  56:	48 8d 45 ee          	lea    rax,[rbp-0x12]
  5a:	48 89 c2             	mov    rdx,rax
  5d:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 64 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x64>	60: R_X86_64_PC32	.rodata+0x1a8
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  64:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 6b <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x6b>	67: R_X86_64_REX_GOTPCRELX	thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  6b:	48 89 c7             	mov    rdi,rax
  6e:	e8 00 00 00 00       	call   73 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x73>	6f: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)-0x4
  73:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 7a <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x7a>	76: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  7a:	48 89 c7             	mov    rdi,rax
  7d:	e8 00 00 00 00       	call   82 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x82>	7e: R_X86_64_PLT32	__cxa_guard_release-0x4
    if (u > 0x477fefffU) {
  82:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 89 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x89>	85: R_X86_64_PC32	__dso_handle-0x4
        remainder = 0x80000000U;
  89:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 90 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x90>	8c: R_X86_64_REX_GOTPCRELX	thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  90:	48 89 c6             	mov    rsi,rax
        return static_cast<unsigned short>(sign | 0x7bffU);
  93:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 9a <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x9a>	96: R_X86_64_REX_GOTPCRELX	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string()-0x4
  9a:	48 89 c7             	mov    rdi,rax
  9d:	e8 00 00 00 00       	call   a2 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xa2>	9e: R_X86_64_PLT32	__cxa_atexit-0x4
    if (u >= 0x38800000U) {
  a2:	48 8d 45 ee          	lea    rax,[rbp-0x12]
  a6:	48 89 c7             	mov    rdi,rax
  a9:	e8 00 00 00 00       	call   ae <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xae>	aa: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
        remainder = u << 19;
  ae:	8b 45 cc             	mov    eax,DWORD PTR [rbp-0x34]
  b1:	89 c7                	mov    edi,eax
  b3:	e8 00 00 00 00       	call   b8 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xb8>	b4: R_X86_64_PLT32	strerror-0x4
        u -= 0x38000000U;
  b8:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  bc:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
        return static_cast<unsigned short>(sign | (u >> 13));
  c0:	bb 00 00 00 00       	mov    ebx,0x0
  c5:	48 85 c0             	test   rax,rax
  c8:	74 2a                	je     f4 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xf4>
  ca:	48 8d 45 ef          	lea    rax,[rbp-0x11]
  ce:	48 89 c7             	mov    rdi,rax
    if (u < 0x33000001U) {
  d1:	e8 00 00 00 00       	call   d6 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xd6>	d2: R_X86_64_PLT32	std::allocator<char>::allocator()-0x4
  d6:	bb 01 00 00 00       	mov    ebx,0x1
        remainder = u;
  db:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  df:	48 8d 55 ef          	lea    rdx,[rbp-0x11]
        return static_cast<unsigned short>(sign);
  e3:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  e7:	48 89 ce             	mov    rsi,rcx
  ea:	48 89 c7             	mov    rdi,rax
    exponent = u >> 23;
  ed:	e8 00 00 00 00       	call   f2 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xf2>	ee: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)-0x4
  f2:	eb 16                	jmp    10a <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x10a>
    mantissa = (u & 0x7fffffU);
  f4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  f8:	48 8b 15 00 00 00 00 	mov    rdx,QWORD PTR [rip+0x0]        # ff <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0xff>	fb: R_X86_64_REX_GOTPCRELX	thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
    shift = 0x7eU - exponent;
  ff:	48 89 d6             	mov    rsi,rdx
 102:	48 89 c7             	mov    rdi,rax
 105:	e8 00 00 00 00       	call   10a <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x10a>	106: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)-0x4
    mantissa |= 0x800000U;
 10a:	84 db                	test   bl,bl
 10c:	74 59                	je     167 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x167>
 10e:	48 8d 45 ef          	lea    rax,[rbp-0x11]
    remainder = mantissa << (32 - shift);
 112:	48 89 c7             	mov    rdi,rax
 115:	e8 00 00 00 00       	call   11a <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x11a>	116: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 11a:	eb 4b                	jmp    167 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x167>
 11c:	49 89 c4             	mov    r12,rax
 11f:	48 8d 45 ee          	lea    rax,[rbp-0x12]
 123:	48 89 c7             	mov    rdi,rax
    return static_cast<unsigned short>(sign | (mantissa >> shift));
 126:	e8 00 00 00 00       	call   12b <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x12b>	127: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 12b:	84 db                	test   bl,bl
 12d:	75 0f                	jne    13e <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x13e>
 12f:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 136 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x136>	132: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::detail::generic_error_category::message[abi:cxx11](int) const::unknown_err-0x4
 136:	48 89 c7             	mov    rdi,rax
 139:	e8 00 00 00 00       	call   13e <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x13e>	13a: R_X86_64_PLT32	__cxa_guard_abort-0x4
{
 13e:	4c 89 e0             	mov    rax,r12
 141:	48 89 c7             	mov    rdi,rax
 144:	e8 00 00 00 00       	call   149 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x149>	145: R_X86_64_PLT32	_Unwind_Resume-0x4
    unsigned int sign = ((h >> 15) & 1);
 149:	49 89 c4             	mov    r12,rax
 14c:	84 db                	test   bl,bl
 14e:	74 0c                	je     15c <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x15c>
 150:	48 8d 45 ef          	lea    rax,[rbp-0x11]
 154:	48 89 c7             	mov    rdi,rax
    unsigned int exponent = ((h >> 10) & 0x1f);
 157:	e8 00 00 00 00       	call   15c <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x15c>	158: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 15c:	4c 89 e0             	mov    rax,r12
 15f:	48 89 c7             	mov    rdi,rax
 162:	e8 00 00 00 00       	call   167 <thrust::system::detail::generic_error_category::message[abi:cxx11](int) const+0x167>	163: R_X86_64_PLT32	_Unwind_Resume-0x4
    unsigned int mantissa = ((h & 0x3ff) << 13);
 167:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
 16b:	48 83 c4 30          	add    rsp,0x30
 16f:	5b                   	pop    rbx
 170:	41 5c                	pop    r12
    if (exponent == 0x1fU) { /* NaN or Inf */
 172:	5d                   	pop    rbp
 173:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail21system_error_categoryC2Ev:

0000000000000000 <thrust::system::detail::system_error_category::system_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::system_error_category::system_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::error_category::error_category()-0x4
{
  18:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1f <thrust::system::detail::system_error_category::system_error_category()+0x1f>	1b: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::detail::system_error_category-0x4
  1f:	48 8d 50 10          	lea    rdx,[rax+0x10]
  23:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    memcpy(&x, &f, sizeof(f));
  27:	48 89 10             	mov    QWORD PTR [rax],rdx
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system6detail21system_error_category4nameEv:

0000000000000000 <thrust::system::detail::system_error_category::name() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8d 05 00 00 00 00 	lea    rax,[rip+0x0]        # f <thrust::system::detail::system_error_category::name() const+0xf>	b: R_X86_64_PC32	.rodata+0x1b6
   f:	5d                   	pop    rbp
  10:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system6detail21system_error_category7messageB5cxx11Ei:

0000000000000000 <thrust::system::detail::system_error_category::message[abi:cxx11](int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 20          	sub    rsp,0x20
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
  10:	89 55 ec             	mov    DWORD PTR [rbp-0x14],edx
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::system_error_category::message[abi:cxx11](int) const+0x18>	14: R_X86_64_PLT32	thrust::system::generic_category()-0x4
{
  18:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  1b:	48 83 c2 30          	add    rdx,0x30
  1f:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
  22:	48 8b 7d f8          	mov    rdi,QWORD PTR [rbp-0x8]
  26:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
    memcpy(&x, &f, sizeof(f));
  29:	48 89 c6             	mov    rsi,rax
  2c:	ff d1                	call   rcx
    u = (x & 0x7fffffffU);
  2e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  32:	c9                   	leave  
  33:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system6detail21system_error_category23default_error_conditionEi:

0000000000000000 <thrust::system::detail::system_error_category::default_error_condition(int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 28          	sub    rsp,0x28
   9:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
   d:	89 75 d4             	mov    DWORD PTR [rbp-0x2c],esi
  10:	8b 45 d4             	mov    eax,DWORD PTR [rbp-0x2c]
  13:	2d ad 26 00 00       	sub    eax,0x26ad
{
  18:	83 f8 4e             	cmp    eax,0x4e
  1b:	0f 87 77 06 00 00    	ja     698 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x698>
  21:	89 c0                	mov    eax,eax
  23:	48 8d 14 85 00 00 00 00 	lea    rdx,[rax*4+0x0]
    memcpy(&x, &f, sizeof(f));
  2b:	48 8d 05 00 00 00 00 	lea    rax,[rip+0x0]        # 32 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x32>	2e: R_X86_64_PC32	.rodata._ZNK6thrust6system6detail21system_error_category23default_error_conditionEi-0x4
    u = (x & 0x7fffffffU);
  32:	8b 04 02             	mov    eax,DWORD PTR [rdx+rax*1]
  35:	48 63 d0             	movsxd rdx,eax
    sign = ((x >> 16) & 0x8000U);
  38:	48 8d 05 00 00 00 00 	lea    rax,[rip+0x0]        # 3f <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3f>	3b: R_X86_64_PC32	.rodata._ZNK6thrust6system6detail21system_error_category23default_error_conditionEi-0x4
  3f:	48 01 d0             	add    rax,rdx
  42:	ff e0                	jmp    rax
  44:	bf ad 26 00 00       	mov    edi,0x26ad
  49:	e8 00 00 00 00       	call   4e <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4e>	4a: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    if (u >= 0x7f800000U) {
  4e:	48 89 d1             	mov    rcx,rdx
  51:	48 89 ca             	mov    rdx,rcx
        remainder = 0;
  54:	e9 60 06 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
  59:	bf ae 26 00 00       	mov    edi,0x26ae
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	e8 00 00 00 00       	call   63 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x63>	5f: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  63:	48 89 d1             	mov    rcx,rdx
  66:	48 89 ca             	mov    rdx,rcx
  69:	e9 4b 06 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
  6e:	bf af 26 00 00       	mov    edi,0x26af
  73:	e8 00 00 00 00       	call   78 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x78>	74: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  78:	48 89 d1             	mov    rcx,rdx
  7b:	48 89 ca             	mov    rdx,rcx
  7e:	e9 36 06 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
    if (u > 0x477fefffU) {
  83:	bf b0 26 00 00       	mov    edi,0x26b0
        remainder = 0x80000000U;
  88:	e8 00 00 00 00       	call   8d <thrust::system::detail::system_error_category::default_error_condition(int) const+0x8d>	89: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  8d:	48 89 d1             	mov    rcx,rdx
  90:	48 89 ca             	mov    rdx,rcx
        return static_cast<unsigned short>(sign | 0x7bffU);
  93:	e9 21 06 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
  98:	bf da 26 00 00       	mov    edi,0x26da
  9d:	e8 00 00 00 00       	call   a2 <thrust::system::detail::system_error_category::default_error_condition(int) const+0xa2>	9e: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    if (u >= 0x38800000U) {
  a2:	48 89 d1             	mov    rcx,rdx
  a5:	48 89 ca             	mov    rdx,rcx
  a8:	e9 0c 06 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
        remainder = u << 19;
  ad:	bf db 26 00 00       	mov    edi,0x26db
  b2:	e8 00 00 00 00       	call   b7 <thrust::system::detail::system_error_category::default_error_condition(int) const+0xb7>	b3: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  b7:	48 89 d1             	mov    rcx,rdx
        u -= 0x38000000U;
  ba:	48 89 ca             	mov    rdx,rcx
  bd:	e9 f7 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
        return static_cast<unsigned short>(sign | (u >> 13));
  c2:	bf dc 26 00 00       	mov    edi,0x26dc
  c7:	e8 00 00 00 00       	call   cc <thrust::system::detail::system_error_category::default_error_condition(int) const+0xcc>	c8: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  cc:	48 89 d1             	mov    rcx,rdx
  cf:	48 89 ca             	mov    rdx,rcx
    if (u < 0x33000001U) {
  d2:	e9 e2 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
  d7:	bf dd 26 00 00       	mov    edi,0x26dd
        remainder = u;
  dc:	e8 00 00 00 00       	call   e1 <thrust::system::detail::system_error_category::default_error_condition(int) const+0xe1>	dd: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  e1:	48 89 d1             	mov    rcx,rdx
        return static_cast<unsigned short>(sign);
  e4:	48 89 ca             	mov    rdx,rcx
  e7:	e9 cd 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
    exponent = u >> 23;
  ec:	bf b1 26 00 00       	mov    edi,0x26b1
  f1:	e8 00 00 00 00       	call   f6 <thrust::system::detail::system_error_category::default_error_condition(int) const+0xf6>	f2: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    mantissa = (u & 0x7fffffU);
  f6:	48 89 d1             	mov    rcx,rdx
  f9:	48 89 ca             	mov    rdx,rcx
  fc:	e9 b8 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
    shift = 0x7eU - exponent;
 101:	bf de 26 00 00       	mov    edi,0x26de
 106:	e8 00 00 00 00       	call   10b <thrust::system::detail::system_error_category::default_error_condition(int) const+0x10b>	107: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    mantissa |= 0x800000U;
 10b:	48 89 d1             	mov    rcx,rdx
 10e:	48 89 ca             	mov    rdx,rcx
    remainder = mantissa << (32 - shift);
 111:	e9 a3 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 116:	bf b2 26 00 00       	mov    edi,0x26b2
 11b:	e8 00 00 00 00       	call   120 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x120>	11c: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 120:	48 89 d1             	mov    rcx,rdx
 123:	48 89 ca             	mov    rdx,rcx
    return static_cast<unsigned short>(sign | (mantissa >> shift));
 126:	e9 8e 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 12b:	bf b3 26 00 00       	mov    edi,0x26b3
 130:	e8 00 00 00 00       	call   135 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x135>	131: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 135:	48 89 d1             	mov    rcx,rdx
 138:	48 89 ca             	mov    rdx,rcx
 13b:	e9 79 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
{
 140:	bf b4 26 00 00       	mov    edi,0x26b4
 145:	e8 00 00 00 00       	call   14a <thrust::system::detail::system_error_category::default_error_condition(int) const+0x14a>	146: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    unsigned int sign = ((h >> 15) & 1);
 14a:	48 89 d1             	mov    rcx,rdx
 14d:	48 89 ca             	mov    rdx,rcx
 150:	e9 64 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 155:	bf b5 26 00 00       	mov    edi,0x26b5
    unsigned int exponent = ((h >> 10) & 0x1f);
 15a:	e8 00 00 00 00       	call   15f <thrust::system::detail::system_error_category::default_error_condition(int) const+0x15f>	15b: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 15f:	48 89 d1             	mov    rcx,rdx
 162:	48 89 ca             	mov    rdx,rcx
    unsigned int mantissa = ((h & 0x3ff) << 13);
 165:	e9 4f 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 16a:	bf df 26 00 00       	mov    edi,0x26df
 16f:	e8 00 00 00 00       	call   174 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x174>	170: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    if (exponent == 0x1fU) { /* NaN or Inf */
 174:	48 89 d1             	mov    rcx,rdx
 177:	48 89 ca             	mov    rdx,rcx
        mantissa = (mantissa ? (sign = 0, 0x7fffffU) : 0);
 17a:	e9 3a 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 17f:	bf b6 26 00 00       	mov    edi,0x26b6
 184:	e8 00 00 00 00       	call   189 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x189>	185: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 189:	48 89 d1             	mov    rcx,rdx
 18c:	48 89 ca             	mov    rdx,rcx
 18f:	e9 25 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 194:	bf e0 26 00 00       	mov    edi,0x26e0
        exponent = 0xffU;
 199:	e8 00 00 00 00       	call   19e <thrust::system::detail::system_error_category::default_error_condition(int) const+0x19e>	19a: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
    } else if (!exponent) { /* Denorm or Zero */
 19e:	48 89 d1             	mov    rcx,rdx
 1a1:	48 89 ca             	mov    rdx,rcx
        if (mantissa) {
 1a4:	e9 10 05 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 1a9:	bf e1 26 00 00       	mov    edi,0x26e1
            exponent = 0x71U;
 1ae:	e8 00 00 00 00       	call   1b3 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x1b3>	1af: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
                msb = (mantissa & 0x400000U);
 1b3:	48 89 d1             	mov    rcx,rdx
 1b6:	48 89 ca             	mov    rdx,rcx
 1b9:	e9 fb 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
                mantissa <<= 1; /* normalize */
 1be:	bf e2 26 00 00       	mov    edi,0x26e2
 1c3:	e8 00 00 00 00       	call   1c8 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x1c8>	1c4: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
                --exponent;
 1c8:	48 89 d1             	mov    rcx,rdx
            } while (!msb);
 1cb:	48 89 ca             	mov    rdx,rcx
 1ce:	e9 e6 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
            mantissa &= 0x7fffffU; /* 1.mantissa is implicit */
 1d3:	bf e3 26 00 00       	mov    edi,0x26e3
 1d8:	e8 00 00 00 00       	call   1dd <thrust::system::detail::system_error_category::default_error_condition(int) const+0x1dd>	1d9: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 1dd:	48 89 d1             	mov    rcx,rdx
        exponent += 0x70U;
 1e0:	48 89 ca             	mov    rdx,rcx
    unsigned int u = ((sign << 31) | (exponent << 23) | mantissa);
 1e3:	e9 d1 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 1e8:	bf e4 26 00 00       	mov    edi,0x26e4
 1ed:	e8 00 00 00 00       	call   1f2 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x1f2>	1ee: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 1f2:	48 89 d1             	mov    rcx,rdx
 1f5:	48 89 ca             	mov    rdx,rcx
 1f8:	e9 bc 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
    memcpy(&f, &u, sizeof(u));
 1fd:	bf e5 26 00 00       	mov    edi,0x26e5
    return f;
 202:	e8 00 00 00 00       	call   207 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x207>	203: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
{
 207:	48 89 d1             	mov    rcx,rdx
 20a:	48 89 ca             	mov    rdx,rcx
 20d:	e9 a7 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 212:	bf d6 26 00 00       	mov    edi,0x26d6
 217:	e8 00 00 00 00       	call   21c <thrust::system::detail::system_error_category::default_error_condition(int) const+0x21c>	218: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
  if (cudaSuccess != status)
 21c:	48 89 d1             	mov    rcx,rdx
    throw thrust::system_error(status, thrust::cuda_category(), msg);
 21f:	48 89 ca             	mov    rdx,rcx
 222:	e9 92 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 227:	bf b7 26 00 00       	mov    edi,0x26b7
 22c:	e8 00 00 00 00       	call   231 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x231>	22d: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 231:	48 89 d1             	mov    rcx,rdx
 234:	48 89 ca             	mov    rdx,rcx
 237:	e9 7d 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 23c:	bf b8 26 00 00       	mov    edi,0x26b8
 241:	e8 00 00 00 00       	call   246 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x246>	242: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 246:	48 89 d1             	mov    rcx,rdx
 249:	48 89 ca             	mov    rdx,rcx
 24c:	e9 68 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 251:	bf d9 26 00 00       	mov    edi,0x26d9
 256:	e8 00 00 00 00       	call   25b <thrust::system::detail::system_error_category::default_error_condition(int) const+0x25b>	257: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 25b:	48 89 d1             	mov    rcx,rdx
 25e:	48 89 ca             	mov    rdx,rcx
 261:	e9 53 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 266:	bf e6 26 00 00       	mov    edi,0x26e6
 26b:	e8 00 00 00 00       	call   270 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x270>	26c: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 270:	48 89 d1             	mov    rcx,rdx
 273:	48 89 ca             	mov    rdx,rcx
 276:	e9 3e 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 27b:	bf e7 26 00 00       	mov    edi,0x26e7
}
 280:	e8 00 00 00 00       	call   285 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x285>	281: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 285:	48 89 d1             	mov    rcx,rdx
                                       const FullSampleMatrix &fullpulsecov) {
 288:	48 89 ca             	mov    rdx,rcx
 28b:	e9 29 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 290:	bf d7 26 00 00       	mov    edi,0x26d7
 295:	e8 00 00 00 00       	call   29a <thrust::system::detail::system_error_category::default_error_condition(int) const+0x29a>	296: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 29a:	48 89 d1             	mov    rcx,rdx
 29d:	48 89 ca             	mov    rdx,rcx
 2a0:	e9 14 04 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 2a5:	bf e8 26 00 00       	mov    edi,0x26e8
 2aa:	e8 00 00 00 00       	call   2af <thrust::system::detail::system_error_category::default_error_condition(int) const+0x2af>	2ab: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 2af:	48 89 d1             	mov    rcx,rdx
 2b2:	48 89 ca             	mov    rdx,rcx
}
 2b5:	e9 ff 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 2ba:	bf e9 26 00 00       	mov    edi,0x26e9
                                          const FullSampleMatrix &fullpulsecov) {
 2bf:	e8 00 00 00 00       	call   2c4 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x2c4>	2c0: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 2c4:	48 89 d1             	mov    rcx,rdx
 2c7:	48 89 ca             	mov    rdx,rcx
 2ca:	e9 ea 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 2cf:	bf ea 26 00 00       	mov    edi,0x26ea
 2d4:	e8 00 00 00 00       	call   2d9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x2d9>	2d5: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 2d9:	48 89 d1             	mov    rcx,rdx
 2dc:	48 89 ca             	mov    rdx,rcx
}
 2df:	e9 d5 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 2e4:	bf b9 26 00 00       	mov    edi,0x26b9
                                           const FullSampleMatrix &fullpulsecov) {
 2e9:	e8 00 00 00 00       	call   2ee <thrust::system::detail::system_error_category::default_error_condition(int) const+0x2ee>	2ea: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 2ee:	48 89 d1             	mov    rcx,rdx
 2f1:	48 89 ca             	mov    rdx,rcx
 2f4:	e9 c0 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 2f9:	bf ba 26 00 00       	mov    edi,0x26ba
 2fe:	e8 00 00 00 00       	call   303 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x303>	2ff: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 303:	48 89 d1             	mov    rcx,rdx
 306:	48 89 ca             	mov    rdx,rcx
}
 309:	e9 ab 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 30e:	bf bb 26 00 00       	mov    edi,0x26bb
__device__ double PulseChiSqSNNLS::ComputeChiSq() {
 313:	e8 00 00 00 00       	call   318 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x318>	314: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 318:	48 89 d1             	mov    rcx,rdx
 31b:	48 89 ca             	mov    rdx,rcx
 31e:	e9 96 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 323:	bf bc 26 00 00       	mov    edi,0x26bc
}
 328:	e8 00 00 00 00       	call   32d <thrust::system::detail::system_error_category::default_error_condition(int) const+0x32d>	329: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 32d:	48 89 d1             	mov    rcx,rdx
__device__ double PulseChiSqSNNLS::ComputeApproxUncertainty(unsigned int ipulse) {
 330:	48 89 ca             	mov    rdx,rcx
 333:	e9 81 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 338:	bf bd 26 00 00       	mov    edi,0x26bd
 33d:	e8 00 00 00 00       	call   342 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x342>	33e: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 342:	48 89 d1             	mov    rcx,rdx
 345:	48 89 ca             	mov    rdx,rcx
}
 348:	e9 6c 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 34d:	bf eb 26 00 00       	mov    edi,0x26eb
__device__ bool PulseChiSqSNNLS::NNLS() {
 352:	e8 00 00 00 00       	call   357 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x357>	353: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 357:	48 89 d1             	mov    rcx,rdx
 35a:	48 89 ca             	mov    rdx,rcx
 35d:	e9 57 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 362:	bf be 26 00 00       	mov    edi,0x26be
}
 367:	e8 00 00 00 00       	call   36c <thrust::system::detail::system_error_category::default_error_condition(int) const+0x36c>	368: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 36c:	48 89 d1             	mov    rcx,rdx
__device__ __host__ PulseChiSqSNNLS::PulseChiSqSNNLS() : _chisq(0.), _computeErrors(true) {}
 36f:	48 89 ca             	mov    rdx,rcx
 372:	e9 42 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 377:	bf ec 26 00 00       	mov    edi,0x26ec
 37c:	e8 00 00 00 00       	call   381 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x381>	37d: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 381:	48 89 d1             	mov    rcx,rdx
 384:	48 89 ca             	mov    rdx,rcx
 387:	e9 2d 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 38c:	bf bf 26 00 00       	mov    edi,0x26bf
 391:	e8 00 00 00 00       	call   396 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x396>	392: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 396:	48 89 d1             	mov    rcx,rdx
 399:	48 89 ca             	mov    rdx,rcx
 39c:	e9 18 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 3a1:	bf c0 26 00 00       	mov    edi,0x26c0
 3a6:	e8 00 00 00 00       	call   3ab <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3ab>	3a7: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 3ab:	48 89 d1             	mov    rcx,rdx
 3ae:	48 89 ca             	mov    rdx,rcx
 3b1:	e9 03 03 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 3b6:	bf c1 26 00 00       	mov    edi,0x26c1
 3bb:	e8 00 00 00 00       	call   3c0 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3c0>	3bc: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 3c0:	48 89 d1             	mov    rcx,rdx
 3c3:	48 89 ca             	mov    rdx,rcx
 3c6:	e9 ee 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 3cb:	bf ed 26 00 00       	mov    edi,0x26ed
 3d0:	e8 00 00 00 00       	call   3d5 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3d5>	3d1: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 3d5:	48 89 d1             	mov    rcx,rdx
 3d8:	48 89 ca             	mov    rdx,rcx
 3db:	e9 d9 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 3e0:	bf c2 26 00 00       	mov    edi,0x26c2
 3e5:	e8 00 00 00 00       	call   3ea <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3ea>	3e6: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 3ea:	48 89 d1             	mov    rcx,rdx
 3ed:	48 89 ca             	mov    rdx,rcx
 3f0:	e9 c4 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 3f5:	bf ee 26 00 00       	mov    edi,0x26ee
 3fa:	e8 00 00 00 00       	call   3ff <thrust::system::detail::system_error_category::default_error_condition(int) const+0x3ff>	3fb: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 3ff:	48 89 d1             	mov    rcx,rdx
 402:	48 89 ca             	mov    rdx,rcx
 405:	e9 af 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 40a:	bf ef 26 00 00       	mov    edi,0x26ef
 40f:	e8 00 00 00 00       	call   414 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x414>	410: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 414:	48 89 d1             	mov    rcx,rdx
 417:	48 89 ca             	mov    rdx,rcx
 41a:	e9 9a 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 41f:	bf f0 26 00 00       	mov    edi,0x26f0
 424:	e8 00 00 00 00       	call   429 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x429>	425: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 429:	48 89 d1             	mov    rcx,rdx
 42c:	48 89 ca             	mov    rdx,rcx
 42f:	e9 85 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 434:	bf f1 26 00 00       	mov    edi,0x26f1
 439:	e8 00 00 00 00       	call   43e <thrust::system::detail::system_error_category::default_error_condition(int) const+0x43e>	43a: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 43e:	48 89 d1             	mov    rcx,rdx
 441:	48 89 ca             	mov    rdx,rcx
 444:	e9 70 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 449:	bf f2 26 00 00       	mov    edi,0x26f2
 44e:	e8 00 00 00 00       	call   453 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x453>	44f: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 453:	48 89 d1             	mov    rcx,rdx
 456:	48 89 ca             	mov    rdx,rcx
 459:	e9 5b 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 45e:	bf c3 26 00 00       	mov    edi,0x26c3
 463:	e8 00 00 00 00       	call   468 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x468>	464: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 468:	48 89 d1             	mov    rcx,rdx
 46b:	48 89 ca             	mov    rdx,rcx
 46e:	e9 46 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 473:	bf c4 26 00 00       	mov    edi,0x26c4
 478:	e8 00 00 00 00       	call   47d <thrust::system::detail::system_error_category::default_error_condition(int) const+0x47d>	479: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 47d:	48 89 d1             	mov    rcx,rdx
 480:	48 89 ca             	mov    rdx,rcx
 483:	e9 31 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 488:	bf c5 26 00 00       	mov    edi,0x26c5
 48d:	e8 00 00 00 00       	call   492 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x492>	48e: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
static void ____nv_dummy_param_ref(void *param) __nv_dummy_param_ref(param)
 492:	48 89 d1             	mov    rcx,rdx
 495:	48 89 ca             	mov    rdx,rcx
 498:	e9 1c 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 49d:	bf f3 26 00 00       	mov    edi,0x26f3
 4a2:	e8 00 00 00 00       	call   4a7 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4a7>	4a3: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
{
 4a7:	48 89 d1             	mov    rcx,rdx
 4aa:	48 89 ca             	mov    rdx,rcx
  ____nv_dummy_param_ref((void *)&__cudaFatCubinHandle);
 4ad:	e9 07 02 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 4b2:	bf c6 26 00 00       	mov    edi,0x26c6
  __cudaUnregisterFatBinary(__cudaFatCubinHandle);
 4b7:	e8 00 00 00 00       	call   4bc <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4bc>	4b8: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 4bc:	48 89 d1             	mov    rcx,rdx
 4bf:	48 89 ca             	mov    rdx,rcx
 4c2:	e9 f2 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
}
 4c7:	bf c7 26 00 00       	mov    edi,0x26c7
{
 4cc:	e8 00 00 00 00       	call   4d1 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4d1>	4cd: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 4d1:	48 89 d1             	mov    rcx,rdx
 4d4:	48 89 ca             	mov    rdx,rcx
  return __cudaInitModule(handle);
 4d7:	e9 dd 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 4dc:	bf c8 26 00 00       	mov    edi,0x26c8
}
 4e1:	e8 00 00 00 00       	call   4e6 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4e6>	4e2: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 4e6:	48 89 d1             	mov    rcx,rdx
 4e9:	48 89 ca             	mov    rdx,rcx
 4ec:	e9 c8 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 4f1:	bf f4 26 00 00       	mov    edi,0x26f4
 4f6:	e8 00 00 00 00       	call   4fb <thrust::system::detail::system_error_category::default_error_condition(int) const+0x4fb>	4f7: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 4fb:	48 89 d1             	mov    rcx,rdx
 4fe:	48 89 ca             	mov    rdx,rcx
 501:	e9 b3 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 506:	bf c9 26 00 00       	mov    edi,0x26c9
 50b:	e8 00 00 00 00       	call   510 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x510>	50c: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 510:	48 89 d1             	mov    rcx,rdx
 513:	48 89 ca             	mov    rdx,rcx
 516:	e9 9e 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 51b:	bf ca 26 00 00       	mov    edi,0x26ca
 520:	e8 00 00 00 00       	call   525 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x525>	521: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 525:	48 89 d1             	mov    rcx,rdx
 528:	48 89 ca             	mov    rdx,rcx
 52b:	e9 89 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 530:	bf cb 26 00 00       	mov    edi,0x26cb
 535:	e8 00 00 00 00       	call   53a <thrust::system::detail::system_error_category::default_error_condition(int) const+0x53a>	536: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 53a:	48 89 d1             	mov    rcx,rdx
 53d:	48 89 ca             	mov    rdx,rcx
 540:	e9 74 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 545:	bf f5 26 00 00       	mov    edi,0x26f5
 54a:	e8 00 00 00 00       	call   54f <thrust::system::detail::system_error_category::default_error_condition(int) const+0x54f>	54b: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 54f:	48 89 d1             	mov    rcx,rdx
 552:	48 89 ca             	mov    rdx,rcx
 555:	e9 5f 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 55a:	bf cc 26 00 00       	mov    edi,0x26cc
 55f:	e8 00 00 00 00       	call   564 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x564>	560: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 564:	48 89 d1             	mov    rcx,rdx
 567:	48 89 ca             	mov    rdx,rcx
 56a:	e9 4a 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 56f:	bf cd 26 00 00       	mov    edi,0x26cd
 574:	e8 00 00 00 00       	call   579 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x579>	575: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 579:	48 89 d1             	mov    rcx,rdx
 57c:	48 89 ca             	mov    rdx,rcx
 57f:	e9 35 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 584:	bf f6 26 00 00       	mov    edi,0x26f6
 589:	e8 00 00 00 00       	call   58e <thrust::system::detail::system_error_category::default_error_condition(int) const+0x58e>	58a: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 58e:	48 89 d1             	mov    rcx,rdx
 591:	48 89 ca             	mov    rdx,rcx
 594:	e9 20 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 599:	bf f7 26 00 00       	mov    edi,0x26f7
 59e:	e8 00 00 00 00       	call   5a3 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x5a3>	59f: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 5a3:	48 89 d1             	mov    rcx,rdx
 5a6:	48 89 ca             	mov    rdx,rcx
 5a9:	e9 0b 01 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 5ae:	bf f8 26 00 00       	mov    edi,0x26f8
 5b3:	e8 00 00 00 00       	call   5b8 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x5b8>	5b4: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 5b8:	48 89 d1             	mov    rcx,rdx
 5bb:	48 89 ca             	mov    rdx,rcx
 5be:	e9 f6 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 5c3:	bf d8 26 00 00       	mov    edi,0x26d8
 5c8:	e8 00 00 00 00       	call   5cd <thrust::system::detail::system_error_category::default_error_condition(int) const+0x5cd>	5c9: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 5cd:	48 89 d1             	mov    rcx,rdx
 5d0:	48 89 ca             	mov    rdx,rcx
 5d3:	e9 e1 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 5d8:	bf ce 26 00 00       	mov    edi,0x26ce
 5dd:	e8 00 00 00 00       	call   5e2 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x5e2>	5de: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 5e2:	48 89 d1             	mov    rcx,rdx
 5e5:	48 89 ca             	mov    rdx,rcx
 5e8:	e9 cc 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 5ed:	bf cf 26 00 00       	mov    edi,0x26cf
 5f2:	e8 00 00 00 00       	call   5f7 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x5f7>	5f3: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 5f7:	48 89 d1             	mov    rcx,rdx
 5fa:	48 89 ca             	mov    rdx,rcx
 5fd:	e9 b7 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 602:	bf d0 26 00 00       	mov    edi,0x26d0
 607:	e8 00 00 00 00       	call   60c <thrust::system::detail::system_error_category::default_error_condition(int) const+0x60c>	608: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 60c:	48 89 d1             	mov    rcx,rdx
 60f:	48 89 ca             	mov    rdx,rcx
 612:	e9 a2 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
__global__ void DoFitGPU(DoFitArgs* parameters, double* result){
 617:	bf d2 26 00 00       	mov    edi,0x26d2
 61c:	e8 00 00 00 00       	call   621 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x621>	61d: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 621:	48 89 d1             	mov    rcx,rdx
 624:	48 89 ca             	mov    rdx,rcx
 627:	e9 8d 00 00 00       	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 62c:	bf f9 26 00 00       	mov    edi,0x26f9
 631:	e8 00 00 00 00       	call   636 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x636>	632: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
}
 636:	48 89 d1             	mov    rcx,rdx
 639:	48 89 ca             	mov    rdx,rcx
 63c:	eb 7b                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 63e:	bf fa 26 00 00       	mov    edi,0x26fa
 643:	e8 00 00 00 00       	call   648 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x648>	644: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 648:	48 89 d1             	mov    rcx,rdx
 64b:	48 89 ca             	mov    rdx,rcx
 64e:	eb 69                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 650:	bf fb 26 00 00       	mov    edi,0x26fb
 655:	e8 00 00 00 00       	call   65a <thrust::system::detail::system_error_category::default_error_condition(int) const+0x65a>	656: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 65a:	48 89 d1             	mov    rcx,rdx
 65d:	48 89 ca             	mov    rdx,rcx
 660:	eb 57                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 662:	bf d3 26 00 00       	mov    edi,0x26d3
 667:	e8 00 00 00 00       	call   66c <thrust::system::detail::system_error_category::default_error_condition(int) const+0x66c>	668: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 66c:	48 89 d1             	mov    rcx,rdx
 66f:	48 89 ca             	mov    rdx,rcx
 672:	eb 45                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 674:	bf d4 26 00 00       	mov    edi,0x26d4
 679:	e8 00 00 00 00       	call   67e <thrust::system::detail::system_error_category::default_error_condition(int) const+0x67e>	67a: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 67e:	48 89 d1             	mov    rcx,rdx
 681:	48 89 ca             	mov    rdx,rcx
 684:	eb 33                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 686:	bf d5 26 00 00       	mov    edi,0x26d5
 68b:	e8 00 00 00 00       	call   690 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x690>	68c: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::errc::errc_t)-0x4
 690:	48 89 d1             	mov    rcx,rdx
 693:	48 89 ca             	mov    rdx,rcx
 696:	eb 21                	jmp    6b9 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b9>
 698:	e8 00 00 00 00       	call   69d <thrust::system::detail::system_error_category::default_error_condition(int) const+0x69d>	699: R_X86_64_PLT32	thrust::system::system_category()-0x4
 69d:	48 89 c2             	mov    rdx,rax
 6a0:	8b 4d d4             	mov    ecx,DWORD PTR [rbp-0x2c]
 6a3:	48 8d 45 e0          	lea    rax,[rbp-0x20]
 6a7:	89 ce                	mov    esi,ecx
 6a9:	48 89 c7             	mov    rdi,rax
 6ac:	e8 00 00 00 00       	call   6b1 <thrust::system::detail::system_error_category::default_error_condition(int) const+0x6b1>	6ad: R_X86_64_PLT32	thrust::system::error_condition::error_condition(int, thrust::system::error_category const&)-0x4
 6b1:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
 6b5:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
 6b9:	48 89 c1             	mov    rcx,rax
 6bc:	48 89 d3             	mov    rbx,rdx
 6bf:	89 c8                	mov    eax,ecx
 6c1:	48 83 c4 28          	add    rsp,0x28
 6c5:	5b                   	pop    rbx
 6c6:	5d                   	pop    rbp
 6c7:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system16generic_categoryEv:

0000000000000000 <thrust::system::generic_category()>:
//#define PulseChiSqSNNLS_cxx
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b <thrust::system::generic_category()+0xb>	7: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::generic_category()::result-0x4
   b:	0f b6 00             	movzx  eax,BYTE PTR [rax]
   e:	84 c0                	test   al,al
  10:	0f 94 c0             	sete   al
  13:	84 c0                	test   al,al
  15:	74 56                	je     6d <thrust::system::generic_category()+0x6d>
{
  17:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1e <thrust::system::generic_category()+0x1e>	1a: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::generic_category()::result-0x4
  1e:	48 89 c7             	mov    rdi,rax
  21:	e8 00 00 00 00       	call   26 <thrust::system::generic_category()+0x26>	22: R_X86_64_PLT32	__cxa_guard_acquire-0x4
  26:	85 c0                	test   eax,eax
    memcpy(&x, &f, sizeof(f));
  28:	0f 95 c0             	setne  al
  2b:	84 c0                	test   al,al
    u = (x & 0x7fffffffU);
  2d:	74 3e                	je     6d <thrust::system::generic_category()+0x6d>
  2f:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 36 <thrust::system::generic_category()+0x36>	32: R_X86_64_REX_GOTPCRELX	thrust::system::generic_category()::result-0x4
  36:	48 89 c7             	mov    rdi,rax
    sign = ((x >> 16) & 0x8000U);
  39:	e8 00 00 00 00       	call   3e <thrust::system::generic_category()+0x3e>	3a: R_X86_64_PLT32	thrust::system::detail::generic_error_category::generic_error_category()-0x4
  3e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 45 <thrust::system::generic_category()+0x45>	41: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::generic_category()::result-0x4
  45:	48 89 c7             	mov    rdi,rax
  48:	e8 00 00 00 00       	call   4d <thrust::system::generic_category()+0x4d>	49: R_X86_64_PLT32	__cxa_guard_release-0x4
    if (u >= 0x7f800000U) {
  4d:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 54 <thrust::system::generic_category()+0x54>	50: R_X86_64_PC32	__dso_handle-0x4
        remainder = 0;
  54:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 5b <thrust::system::generic_category()+0x5b>	57: R_X86_64_REX_GOTPCRELX	thrust::system::generic_category()::result-0x4
  5b:	48 89 c6             	mov    rsi,rax
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 65 <thrust::system::generic_category()+0x65>	61: R_X86_64_REX_GOTPCRELX	thrust::system::detail::generic_error_category::~generic_error_category()-0x4
  65:	48 89 c7             	mov    rdi,rax
  68:	e8 00 00 00 00       	call   6d <thrust::system::generic_category()+0x6d>	69: R_X86_64_PLT32	__cxa_atexit-0x4
  6d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 74 <thrust::system::generic_category()+0x74>	70: R_X86_64_REX_GOTPCRELX	thrust::system::generic_category()::result-0x4
  74:	5d                   	pop    rbp
  75:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system15system_categoryEv:

0000000000000000 <thrust::system::system_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b <thrust::system::system_category()+0xb>	7: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::system_category()::result-0x4
   b:	0f b6 00             	movzx  eax,BYTE PTR [rax]
   e:	84 c0                	test   al,al
  10:	0f 94 c0             	sete   al
  13:	84 c0                	test   al,al
  15:	74 56                	je     6d <thrust::system::system_category()+0x6d>
{
  17:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1e <thrust::system::system_category()+0x1e>	1a: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::system_category()::result-0x4
  1e:	48 89 c7             	mov    rdi,rax
  21:	e8 00 00 00 00       	call   26 <thrust::system::system_category()+0x26>	22: R_X86_64_PLT32	__cxa_guard_acquire-0x4
  26:	85 c0                	test   eax,eax
    memcpy(&x, &f, sizeof(f));
  28:	0f 95 c0             	setne  al
  2b:	84 c0                	test   al,al
    u = (x & 0x7fffffffU);
  2d:	74 3e                	je     6d <thrust::system::system_category()+0x6d>
  2f:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 36 <thrust::system::system_category()+0x36>	32: R_X86_64_REX_GOTPCRELX	thrust::system::system_category()::result-0x4
  36:	48 89 c7             	mov    rdi,rax
    sign = ((x >> 16) & 0x8000U);
  39:	e8 00 00 00 00       	call   3e <thrust::system::system_category()+0x3e>	3a: R_X86_64_PLT32	thrust::system::detail::system_error_category::system_error_category()-0x4
  3e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 45 <thrust::system::system_category()+0x45>	41: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::system_category()::result-0x4
  45:	48 89 c7             	mov    rdi,rax
  48:	e8 00 00 00 00       	call   4d <thrust::system::system_category()+0x4d>	49: R_X86_64_PLT32	__cxa_guard_release-0x4
    if (u >= 0x7f800000U) {
  4d:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 54 <thrust::system::system_category()+0x54>	50: R_X86_64_PC32	__dso_handle-0x4
        remainder = 0;
  54:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 5b <thrust::system::system_category()+0x5b>	57: R_X86_64_REX_GOTPCRELX	thrust::system::system_category()::result-0x4
  5b:	48 89 c6             	mov    rsi,rax
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 65 <thrust::system::system_category()+0x65>	61: R_X86_64_REX_GOTPCRELX	thrust::system::detail::system_error_category::~system_error_category()-0x4
  65:	48 89 c7             	mov    rdi,rax
  68:	e8 00 00 00 00       	call   6d <thrust::system::system_category()+0x6d>	69: R_X86_64_PLT32	__cxa_atexit-0x4
  6d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 74 <thrust::system::system_category()+0x74>	70: R_X86_64_REX_GOTPCRELX	thrust::system::system_category()::result-0x4
  74:	5d                   	pop    rbp
  75:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system10error_codeC2EiRKNS0_14error_categoryE:

0000000000000000 <thrust::system::error_code::error_code(int, thrust::system::error_category const&)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
   b:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
   f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  13:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
{
  16:	89 10                	mov    DWORD PTR [rax],edx
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  20:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  24:	90                   	nop
  25:	5d                   	pop    rbp
  26:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system10error_code5valueEv:

0000000000000000 <thrust::system::error_code::value() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	8b 00                	mov    eax,DWORD PTR [rax]
   e:	5d                   	pop    rbp
   f:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system10error_code8categoryEv:

0000000000000000 <thrust::system::error_code::category() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  10:	5d                   	pop    rbp
  11:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system10error_code7messageB5cxx11Ev:

0000000000000000 <thrust::system::error_code::message[abi:cxx11]() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	41 54                	push   r12
   6:	53                   	push   rbx
   7:	48 83 ec 10          	sub    rsp,0x10
   b:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
   f:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  13:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  17:	48 89 c7             	mov    rdi,rax
  1a:	e8 00 00 00 00       	call   1f <thrust::system::error_code::message[abi:cxx11]() const+0x1f>	1b: R_X86_64_PLT32	thrust::system::error_code::category() const-0x4
  1f:	48 89 c3             	mov    rbx,rax
  22:	48 8b 03             	mov    rax,QWORD PTR [rbx]
  25:	48 83 c0 30          	add    rax,0x30
    memcpy(&x, &f, sizeof(f));
  29:	4c 8b 20             	mov    r12,QWORD PTR [rax]
  2c:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    u = (x & 0x7fffffffU);
  30:	48 89 c7             	mov    rdi,rax
  33:	e8 00 00 00 00       	call   38 <thrust::system::error_code::message[abi:cxx11]() const+0x38>	34: R_X86_64_PLT32	thrust::system::error_code::value() const-0x4
    sign = ((x >> 16) & 0x8000U);
  38:	89 c2                	mov    edx,eax
  3a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  3e:	48 89 de             	mov    rsi,rbx
  41:	48 89 c7             	mov    rdi,rax
  44:	41 ff d4             	call   r12
  47:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    if (u >= 0x7f800000U) {
  4b:	48 83 c4 10          	add    rsp,0x10
  4f:	5b                   	pop    rbx
  50:	41 5c                	pop    r12
  52:	5d                   	pop    rbp
  53:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system10error_codecvbEv:

0000000000000000 <thrust::system::error_code::operator bool() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::error_code::operator bool() const+0x18>	14: R_X86_64_PLT32	thrust::system::error_code::value() const-0x4
{
  18:	85 c0                	test   eax,eax
  1a:	0f 95 c0             	setne  al
  1d:	c9                   	leave  
  1e:	c3                   	ret    

Disassembly of section .text._ZN6thrust6systemeqERKNS0_15error_conditionES3_:

0000000000000000 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 18          	sub    rsp,0x18
   9:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
   d:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  11:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  15:	48 89 c7             	mov    rdi,rax
  18:	e8 00 00 00 00       	call   1d <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x1d>	19: R_X86_64_PLT32	thrust::system::error_condition::category() const-0x4
  1d:	48 89 c3             	mov    rbx,rax
  20:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  24:	48 89 c7             	mov    rdi,rax
    memcpy(&x, &f, sizeof(f));
  27:	e8 00 00 00 00       	call   2c <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x2c>	28: R_X86_64_PLT32	thrust::system::error_condition::category() const-0x4
  2c:	48 89 de             	mov    rsi,rbx
    u = (x & 0x7fffffffU);
  2f:	48 89 c7             	mov    rdi,rax
  32:	e8 00 00 00 00       	call   37 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x37>	33: R_X86_64_PLT32	thrust::system::error_category::operator==(thrust::system::error_category const&) const-0x4
  37:	84 c0                	test   al,al
    sign = ((x >> 16) & 0x8000U);
  39:	74 25                	je     60 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x60>
  3b:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  3f:	48 89 c7             	mov    rdi,rax
  42:	e8 00 00 00 00       	call   47 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x47>	43: R_X86_64_PLT32	thrust::system::error_condition::value() const-0x4
  47:	89 c3                	mov    ebx,eax
  49:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    if (u >= 0x7f800000U) {
  4d:	48 89 c7             	mov    rdi,rax
  50:	e8 00 00 00 00       	call   55 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x55>	51: R_X86_64_PLT32	thrust::system::error_condition::value() const-0x4
        remainder = 0;
  55:	39 c3                	cmp    ebx,eax
  57:	75 07                	jne    60 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x60>
  59:	b8 01 00 00 00       	mov    eax,0x1
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	eb 05                	jmp    65 <thrust::system::operator==(thrust::system::error_condition const&, thrust::system::error_condition const&)+0x65>
  60:	b8 00 00 00 00       	mov    eax,0x0
  65:	48 83 c4 18          	add    rsp,0x18
  69:	5b                   	pop    rbx
  6a:	5d                   	pop    rbp
  6b:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system15error_conditionC2EiRKNS0_14error_categoryE:

0000000000000000 <thrust::system::error_condition::error_condition(int, thrust::system::error_category const&)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
   b:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
   f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  13:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
{
  16:	89 10                	mov    DWORD PTR [rax],edx
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  20:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
  24:	90                   	nop
  25:	5d                   	pop    rbp
  26:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system15error_condition5valueEv:

0000000000000000 <thrust::system::error_condition::value() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	8b 00                	mov    eax,DWORD PTR [rax]
   e:	5d                   	pop    rbp
   f:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system15error_condition8categoryEv:

0000000000000000 <thrust::system::error_condition::category() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
  10:	5d                   	pop    rbp
  11:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system20make_error_conditionENS0_4errc6errc_tE:

0000000000000000 <thrust::system::make_error_condition(thrust::system::errc::errc_t)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 28          	sub    rsp,0x28
   9:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
   c:	e8 00 00 00 00       	call   11 <thrust::system::make_error_condition(thrust::system::errc::errc_t)+0x11>	d: R_X86_64_PLT32	thrust::system::generic_category()-0x4
  11:	48 89 c2             	mov    rdx,rax
  14:	8b 4d dc             	mov    ecx,DWORD PTR [rbp-0x24]
  17:	48 8d 45 e0          	lea    rax,[rbp-0x20]
  1b:	89 ce                	mov    esi,ecx
  1d:	48 89 c7             	mov    rdi,rax
  20:	e8 00 00 00 00       	call   25 <thrust::system::make_error_condition(thrust::system::errc::errc_t)+0x25>	21: R_X86_64_PLT32	thrust::system::error_condition::error_condition(int, thrust::system::error_category const&)-0x4
  25:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    memcpy(&x, &f, sizeof(f));
  29:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
    u = (x & 0x7fffffffU);
  2d:	48 89 c1             	mov    rcx,rax
  30:	48 89 d3             	mov    rbx,rdx
  33:	89 c8                	mov    eax,ecx
  35:	48 83 c4 28          	add    rsp,0x28
    sign = ((x >> 16) & 0x8000U);
  39:	5b                   	pop    rbx
  3a:	5d                   	pop    rbp
  3b:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system12system_errorD2Ev:

0000000000000000 <thrust::system::system_error::~system_error()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 13 <thrust::system::system_error::~system_error()+0x13>	f: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::system_error-0x4
  13:	48 8d 50 10          	lea    rdx,[rax+0x10]
{
  17:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1b:	48 89 10             	mov    QWORD PTR [rax],rdx
  1e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  22:	48 83 c0 20          	add    rax,0x20
  26:	48 89 c7             	mov    rdi,rax
    memcpy(&x, &f, sizeof(f));
  29:	e8 00 00 00 00       	call   2e <thrust::system::system_error::~system_error()+0x2e>	2a: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string()-0x4
    u = (x & 0x7fffffffU);
  2e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  32:	48 89 c7             	mov    rdi,rax
  35:	e8 00 00 00 00       	call   3a <thrust::system::system_error::~system_error()+0x3a>	36: R_X86_64_PLT32	std::runtime_error::~runtime_error()-0x4
    sign = ((x >> 16) & 0x8000U);
  3a:	90                   	nop
  3b:	c9                   	leave  
  3c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system12system_errorD0Ev:

0000000000000000 <thrust::system::system_error::~system_error()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::system_error::~system_error()+0x18>	14: R_X86_64_PLT32	thrust::system::system_error::~system_error()-0x4
{
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	be 40 00 00 00       	mov    esi,0x40
  21:	48 89 c7             	mov    rdi,rax
  24:	e8 00 00 00 00       	call   29 <thrust::system::system_error::~system_error()+0x29>	25: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
    memcpy(&x, &f, sizeof(f));
  29:	c9                   	leave  
  2a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system12system_errorC2EiRKNS0_14error_categoryEPKc:

0000000000000000 <thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 20          	sub    rsp,0x20
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	89 75 f4             	mov    DWORD PTR [rbp-0xc],esi
   f:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
  13:	48 89 4d e0          	mov    QWORD PTR [rbp-0x20],rcx
{
  17:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1b:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
  1f:	48 89 d6             	mov    rsi,rdx
  22:	48 89 c7             	mov    rdi,rax
  25:	e8 00 00 00 00       	call   2a <thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)+0x2a>	26: R_X86_64_PLT32	std::runtime_error::runtime_error(char const*)-0x4
    memcpy(&x, &f, sizeof(f));
  2a:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 31 <thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)+0x31>	2d: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::system_error-0x4
    u = (x & 0x7fffffffU);
  31:	48 8d 50 10          	lea    rdx,[rax+0x10]
  35:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    sign = ((x >> 16) & 0x8000U);
  39:	48 89 10             	mov    QWORD PTR [rax],rdx
  3c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  40:	48 8d 48 10          	lea    rcx,[rax+0x10]
  44:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  48:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
    if (u >= 0x7f800000U) {
  4b:	89 c6                	mov    esi,eax
  4d:	48 89 cf             	mov    rdi,rcx
  50:	e8 00 00 00 00       	call   55 <thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)+0x55>	51: R_X86_64_PLT32	thrust::system::error_code::error_code(int, thrust::system::error_category const&)-0x4
        remainder = 0;
  55:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  59:	48 83 c0 20          	add    rax,0x20
  5d:	48 89 c7             	mov    rdi,rax
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  60:	e8 00 00 00 00       	call   65 <thrust::system::system_error::system_error(int, thrust::system::error_category const&, char const*)+0x65>	61: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string()-0x4
  65:	90                   	nop
  66:	c9                   	leave  
  67:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system12system_error4whatEv:

0000000000000000 <thrust::system::system_error::what() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 38          	sub    rsp,0x38
   9:	48 89 7d c8          	mov    QWORD PTR [rbp-0x38],rdi
   d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  11:	48 83 c0 20          	add    rax,0x20
  15:	48 89 c7             	mov    rdi,rax
{
  18:	e8 00 00 00 00       	call   1d <thrust::system::system_error::what() const+0x1d>	19: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::empty() const-0x4
  1d:	84 c0                	test   al,al
  1f:	0f 84 9e 00 00 00    	je     c3 <thrust::system::system_error::what() const+0xc3>
  25:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    memcpy(&x, &f, sizeof(f));
  29:	48 89 c7             	mov    rdi,rax
  2c:	e8 00 00 00 00       	call   31 <thrust::system::system_error::what() const+0x31>	2d: R_X86_64_PLT32	std::runtime_error::what() const-0x4
    u = (x & 0x7fffffffU);
  31:	48 89 c2             	mov    rdx,rax
  34:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    sign = ((x >> 16) & 0x8000U);
  38:	48 83 c0 20          	add    rax,0x20
  3c:	48 89 d6             	mov    rsi,rdx
  3f:	48 89 c7             	mov    rdi,rax
  42:	e8 00 00 00 00       	call   47 <thrust::system::system_error::what() const+0x47>	43: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator=(char const*)-0x4
  47:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    if (u >= 0x7f800000U) {
  4b:	48 83 c0 10          	add    rax,0x10
  4f:	48 89 c7             	mov    rdi,rax
  52:	e8 00 00 00 00       	call   57 <thrust::system::system_error::what() const+0x57>	53: R_X86_64_PLT32	thrust::system::error_code::operator bool() const-0x4
        remainder = 0;
  57:	84 c0                	test   al,al
  59:	74 68                	je     c3 <thrust::system::system_error::what() const+0xc3>
  5b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5f:	48 83 c0 20          	add    rax,0x20
  63:	48 89 c7             	mov    rdi,rax
  66:	e8 00 00 00 00       	call   6b <thrust::system::system_error::what() const+0x6b>	67: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::empty() const-0x4
  6b:	83 f0 01             	xor    eax,0x1
  6e:	84 c0                	test   al,al
  70:	74 17                	je     89 <thrust::system::system_error::what() const+0x89>
  72:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  76:	48 83 c0 20          	add    rax,0x20
  7a:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 81 <thrust::system::system_error::what() const+0x81>	7d: R_X86_64_PC32	.rodata+0x1bd
    if (u > 0x477fefffU) {
  81:	48 89 c7             	mov    rdi,rax
  84:	e8 00 00 00 00       	call   89 <thrust::system::system_error::what() const+0x89>	85: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator+=(char const*)-0x4
        remainder = 0x80000000U;
  89:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  8d:	48 8d 50 10          	lea    rdx,[rax+0x10]
  91:	48 8d 45 d0          	lea    rax,[rbp-0x30]
        return static_cast<unsigned short>(sign | 0x7bffU);
  95:	48 89 d6             	mov    rsi,rdx
  98:	48 89 c7             	mov    rdi,rax
  9b:	e8 00 00 00 00       	call   a0 <thrust::system::system_error::what() const+0xa0>	9c: R_X86_64_PLT32	thrust::system::error_code::message[abi:cxx11]() const-0x4
  a0:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
    if (u >= 0x38800000U) {
  a4:	48 8d 50 20          	lea    rdx,[rax+0x20]
  a8:	48 8d 45 d0          	lea    rax,[rbp-0x30]
        remainder = u << 19;
  ac:	48 89 c6             	mov    rsi,rax
  af:	48 89 d7             	mov    rdi,rdx
  b2:	e8 00 00 00 00       	call   b7 <thrust::system::system_error::what() const+0xb7>	b3: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator+=(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)-0x4
  b7:	48 8d 45 d0          	lea    rax,[rbp-0x30]
        u -= 0x38000000U;
  bb:	48 89 c7             	mov    rdi,rax
  be:	e8 00 00 00 00       	call   c3 <thrust::system::system_error::what() const+0xc3>	bf: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string()-0x4
        return static_cast<unsigned short>(sign | (u >> 13));
  c3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  c7:	48 83 c0 20          	add    rax,0x20
  cb:	48 89 c7             	mov    rdi,rax
  ce:	e8 00 00 00 00       	call   d3 <thrust::system::system_error::what() const+0xd3>	cf: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::c_str() const-0x4
    if (u < 0x33000001U) {
  d3:	48 89 c3             	mov    rbx,rax
  d6:	48 89 d8             	mov    rax,rbx
  d9:	eb 48                	jmp    123 <thrust::system::system_error::what() const+0x123>
        remainder = u;
  db:	48 89 c3             	mov    rbx,rax
  de:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  e2:	48 89 c7             	mov    rdi,rax
        return static_cast<unsigned short>(sign);
  e5:	e8 00 00 00 00       	call   ea <thrust::system::system_error::what() const+0xea>	e6: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string()-0x4
  ea:	48 89 d8             	mov    rax,rbx
    exponent = u >> 23;
  ed:	eb 00                	jmp    ef <thrust::system::system_error::what() const+0xef>
  ef:	48 89 c7             	mov    rdi,rax
  f2:	e8 00 00 00 00       	call   f7 <thrust::system::system_error::what() const+0xf7>	f3: R_X86_64_PLT32	__cxa_begin_catch-0x4
    mantissa = (u & 0x7fffffU);
  f7:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
  fb:	48 89 c7             	mov    rdi,rax
  fe:	e8 00 00 00 00       	call   103 <thrust::system::system_error::what() const+0x103>	ff: R_X86_64_PLT32	std::runtime_error::what() const-0x4
    shift = 0x7eU - exponent;
 103:	48 89 c3             	mov    rbx,rax
 106:	e8 00 00 00 00       	call   10b <thrust::system::system_error::what() const+0x10b>	107: R_X86_64_PLT32	__cxa_end_catch-0x4
    mantissa |= 0x800000U;
 10b:	eb c9                	jmp    d6 <thrust::system::system_error::what() const+0xd6>
 10d:	48 83 fa ff          	cmp    rdx,0xffffffffffffffff
    remainder = mantissa << (32 - shift);
 111:	74 08                	je     11b <thrust::system::system_error::what() const+0x11b>
 113:	48 89 c7             	mov    rdi,rax
 116:	e8 00 00 00 00       	call   11b <thrust::system::system_error::what() const+0x11b>	117: R_X86_64_PLT32	_Unwind_Resume-0x4
 11b:	48 89 c7             	mov    rdi,rax
 11e:	e8 00 00 00 00       	call   123 <thrust::system::system_error::what() const+0x123>	11f: R_X86_64_PLT32	__cxa_call_unexpected-0x4
 123:	48 83 c4 38          	add    rsp,0x38
    return static_cast<unsigned short>(sign | (mantissa >> shift));
 127:	5b                   	pop    rbx
 128:	5d                   	pop    rbp
 129:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system20make_error_conditionENS0_8cuda_cub4errc6errc_tE:

0000000000000000 <thrust::system::make_error_condition(thrust::system::cuda_cub::errc::errc_t)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 28          	sub    rsp,0x28
   9:	89 7d dc             	mov    DWORD PTR [rbp-0x24],edi
   c:	e8 00 00 00 00       	call   11 <thrust::system::make_error_condition(thrust::system::cuda_cub::errc::errc_t)+0x11>	d: R_X86_64_PLT32	thrust::system::cuda_category()-0x4
  11:	48 89 c2             	mov    rdx,rax
  14:	8b 4d dc             	mov    ecx,DWORD PTR [rbp-0x24]
{
  17:	48 8d 45 e0          	lea    rax,[rbp-0x20]
  1b:	89 ce                	mov    esi,ecx
  1d:	48 89 c7             	mov    rdi,rax
  20:	e8 00 00 00 00       	call   25 <thrust::system::make_error_condition(thrust::system::cuda_cub::errc::errc_t)+0x25>	21: R_X86_64_PLT32	thrust::system::error_condition::error_condition(int, thrust::system::error_category const&)-0x4
  25:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
    memcpy(&x, &f, sizeof(f));
  29:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
    u = (x & 0x7fffffffU);
  2d:	48 89 c1             	mov    rcx,rax
  30:	48 89 d3             	mov    rbx,rdx
  33:	89 c8                	mov    eax,ecx
  35:	48 83 c4 28          	add    rsp,0x28
    sign = ((x >> 16) & 0x8000U);
  39:	5b                   	pop    rbx
  3a:	5d                   	pop    rbp
  3b:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system8cuda_cub6detail19cuda_error_categoryC2Ev:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::cuda_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::cuda_cub::detail::cuda_error_category::cuda_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::error_category::error_category()-0x4
{
  18:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1f <thrust::system::cuda_cub::detail::cuda_error_category::cuda_error_category()+0x1f>	1b: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::cuda_cub::detail::cuda_error_category-0x4
  1f:	48 8d 50 10          	lea    rdx,[rax+0x10]
  23:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    memcpy(&x, &f, sizeof(f));
  27:	48 89 10             	mov    QWORD PTR [rax],rdx
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system8cuda_cub6detail19cuda_error_category4nameEv:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::name() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8d 05 00 00 00 00 	lea    rax,[rip+0x0]        # f <thrust::system::cuda_cub::detail::cuda_error_category::name() const+0xf>	b: R_X86_64_PC32	.rodata+0x1c0
   f:	5d                   	pop    rbp
  10:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system8cuda_cub6detail19cuda_error_category7messageB5cxx11Ei:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	41 54                	push   r12
   6:	53                   	push   rbx
   7:	48 83 ec 30          	sub    rsp,0x30
   b:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
   f:	48 89 75 d0          	mov    QWORD PTR [rbp-0x30],rsi
  13:	89 55 cc             	mov    DWORD PTR [rbp-0x34],edx
{
  16:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1d <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x1d>	19: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  1d:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  20:	84 c0                	test   al,al
  22:	0f 94 c0             	sete   al
  25:	84 c0                	test   al,al
    memcpy(&x, &f, sizeof(f));
  27:	0f 84 81 00 00 00    	je     ae <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xae>
    u = (x & 0x7fffffffU);
  2d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 34 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x34>	30: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  34:	48 89 c7             	mov    rdi,rax
  37:	e8 00 00 00 00       	call   3c <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x3c>	38: R_X86_64_PLT32	__cxa_guard_acquire-0x4
    sign = ((x >> 16) & 0x8000U);
  3c:	85 c0                	test   eax,eax
  3e:	0f 95 c0             	setne  al
  41:	84 c0                	test   al,al
  43:	74 69                	je     ae <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xae>
  45:	bb 00 00 00 00       	mov    ebx,0x0
  4a:	48 8d 45 ee          	lea    rax,[rbp-0x12]
    if (u >= 0x7f800000U) {
  4e:	48 89 c7             	mov    rdi,rax
  51:	e8 00 00 00 00       	call   56 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x56>	52: R_X86_64_PLT32	std::allocator<char>::allocator()-0x4
        remainder = 0;
  56:	48 8d 45 ee          	lea    rax,[rbp-0x12]
  5a:	48 89 c2             	mov    rdx,rax
  5d:	48 8d 35 00 00 00 00 	lea    rsi,[rip+0x0]        # 64 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x64>	60: R_X86_64_PC32	.rodata+0x1a8
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  64:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 6b <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x6b>	67: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  6b:	48 89 c7             	mov    rdi,rax
  6e:	e8 00 00 00 00       	call   73 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x73>	6f: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)-0x4
  73:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 7a <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x7a>	76: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  7a:	48 89 c7             	mov    rdi,rax
  7d:	e8 00 00 00 00       	call   82 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x82>	7e: R_X86_64_PLT32	__cxa_guard_release-0x4
    if (u > 0x477fefffU) {
  82:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 89 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x89>	85: R_X86_64_PC32	__dso_handle-0x4
        remainder = 0x80000000U;
  89:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 90 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x90>	8c: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
  90:	48 89 c6             	mov    rsi,rax
        return static_cast<unsigned short>(sign | 0x7bffU);
  93:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 9a <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x9a>	96: R_X86_64_REX_GOTPCRELX	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string()-0x4
  9a:	48 89 c7             	mov    rdi,rax
  9d:	e8 00 00 00 00       	call   a2 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xa2>	9e: R_X86_64_PLT32	__cxa_atexit-0x4
    if (u >= 0x38800000U) {
  a2:	48 8d 45 ee          	lea    rax,[rbp-0x12]
  a6:	48 89 c7             	mov    rdi,rax
  a9:	e8 00 00 00 00       	call   ae <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xae>	aa: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
        remainder = u << 19;
  ae:	8b 45 cc             	mov    eax,DWORD PTR [rbp-0x34]
  b1:	89 c7                	mov    edi,eax
  b3:	e8 00 00 00 00       	call   b8 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xb8>	b4: R_X86_64_PLT32	cudaGetErrorString-0x4
        u -= 0x38000000U;
  b8:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
  bc:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
        return static_cast<unsigned short>(sign | (u >> 13));
  c0:	bb 00 00 00 00       	mov    ebx,0x0
  c5:	48 85 c0             	test   rax,rax
  c8:	74 2a                	je     f4 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xf4>
  ca:	48 8d 45 ef          	lea    rax,[rbp-0x11]
  ce:	48 89 c7             	mov    rdi,rax
    if (u < 0x33000001U) {
  d1:	e8 00 00 00 00       	call   d6 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xd6>	d2: R_X86_64_PLT32	std::allocator<char>::allocator()-0x4
  d6:	bb 01 00 00 00       	mov    ebx,0x1
        remainder = u;
  db:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  df:	48 8d 55 ef          	lea    rdx,[rbp-0x11]
        return static_cast<unsigned short>(sign);
  e3:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  e7:	48 89 ce             	mov    rsi,rcx
  ea:	48 89 c7             	mov    rdi,rax
    exponent = u >> 23;
  ed:	e8 00 00 00 00       	call   f2 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xf2>	ee: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)-0x4
  f2:	eb 16                	jmp    10a <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x10a>
    mantissa = (u & 0x7fffffU);
  f4:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  f8:	48 8b 15 00 00 00 00 	mov    rdx,QWORD PTR [rip+0x0]        # ff <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0xff>	fb: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
    shift = 0x7eU - exponent;
  ff:	48 89 d6             	mov    rsi,rdx
 102:	48 89 c7             	mov    rdi,rax
 105:	e8 00 00 00 00       	call   10a <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x10a>	106: R_X86_64_PLT32	std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)-0x4
    mantissa |= 0x800000U;
 10a:	84 db                	test   bl,bl
 10c:	74 59                	je     167 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x167>
 10e:	48 8d 45 ef          	lea    rax,[rbp-0x11]
    remainder = mantissa << (32 - shift);
 112:	48 89 c7             	mov    rdi,rax
 115:	e8 00 00 00 00       	call   11a <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x11a>	116: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 11a:	eb 4b                	jmp    167 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x167>
 11c:	49 89 c4             	mov    r12,rax
 11f:	48 8d 45 ee          	lea    rax,[rbp-0x12]
 123:	48 89 c7             	mov    rdi,rax
    return static_cast<unsigned short>(sign | (mantissa >> shift));
 126:	e8 00 00 00 00       	call   12b <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x12b>	127: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 12b:	84 db                	test   bl,bl
 12d:	75 0f                	jne    13e <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x13e>
 12f:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 136 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x136>	132: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const::unknown_err-0x4
 136:	48 89 c7             	mov    rdi,rax
 139:	e8 00 00 00 00       	call   13e <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x13e>	13a: R_X86_64_PLT32	__cxa_guard_abort-0x4
{
 13e:	4c 89 e0             	mov    rax,r12
 141:	48 89 c7             	mov    rdi,rax
 144:	e8 00 00 00 00       	call   149 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x149>	145: R_X86_64_PLT32	_Unwind_Resume-0x4
    unsigned int sign = ((h >> 15) & 1);
 149:	49 89 c4             	mov    r12,rax
 14c:	84 db                	test   bl,bl
 14e:	74 0c                	je     15c <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x15c>
 150:	48 8d 45 ef          	lea    rax,[rbp-0x11]
 154:	48 89 c7             	mov    rdi,rax
    unsigned int exponent = ((h >> 10) & 0x1f);
 157:	e8 00 00 00 00       	call   15c <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x15c>	158: R_X86_64_PLT32	std::allocator<char>::~allocator()-0x4
 15c:	4c 89 e0             	mov    rax,r12
 15f:	48 89 c7             	mov    rdi,rax
 162:	e8 00 00 00 00       	call   167 <thrust::system::cuda_cub::detail::cuda_error_category::message[abi:cxx11](int) const+0x167>	163: R_X86_64_PLT32	_Unwind_Resume-0x4
    unsigned int mantissa = ((h & 0x3ff) << 13);
 167:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
 16b:	48 83 c4 30          	add    rsp,0x30
 16f:	5b                   	pop    rbx
 170:	41 5c                	pop    r12
    if (exponent == 0x1fU) { /* NaN or Inf */
 172:	5d                   	pop    rbp
 173:	c3                   	ret    

Disassembly of section .text._ZNK6thrust6system8cuda_cub6detail19cuda_error_category23default_error_conditionEi:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::default_error_condition(int) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 18          	sub    rsp,0x18
   9:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
   d:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  10:	81 7d e4 0f 27 00 00 	cmp    DWORD PTR [rbp-0x1c],0x270f
{
  17:	7f 12                	jg     2b <thrust::system::cuda_cub::detail::cuda_error_category::default_error_condition(int) const+0x2b>
  19:	8b 45 e4             	mov    eax,DWORD PTR [rbp-0x1c]
  1c:	89 c7                	mov    edi,eax
  1e:	e8 00 00 00 00       	call   23 <thrust::system::cuda_cub::detail::cuda_error_category::default_error_condition(int) const+0x23>	1f: R_X86_64_PLT32	thrust::system::make_error_condition(thrust::system::cuda_cub::errc::errc_t)-0x4
  23:	48 89 d1             	mov    rcx,rdx
  26:	48 89 ca             	mov    rdx,rcx
    memcpy(&x, &f, sizeof(f));
  29:	eb 1f                	jmp    4a <thrust::system::cuda_cub::detail::cuda_error_category::default_error_condition(int) const+0x4a>
  2b:	e8 00 00 00 00       	call   30 <thrust::system::cuda_cub::detail::cuda_error_category::default_error_condition(int) const+0x30>	2c: R_X86_64_PLT32	thrust::system::system_category()-0x4
    u = (x & 0x7fffffffU);
  30:	48 8b 10             	mov    rdx,QWORD PTR [rax]
  33:	48 83 c2 18          	add    rdx,0x18
  37:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
    sign = ((x >> 16) & 0x8000U);
  3a:	8b 4d e4             	mov    ecx,DWORD PTR [rbp-0x1c]
  3d:	89 ce                	mov    esi,ecx
  3f:	48 89 c7             	mov    rdi,rax
  42:	ff d2                	call   rdx
  44:	48 89 d1             	mov    rcx,rdx
  47:	48 89 ca             	mov    rdx,rcx
  4a:	48 89 c1             	mov    rcx,rax
    if (u >= 0x7f800000U) {
  4d:	48 89 d3             	mov    rbx,rdx
  50:	89 c8                	mov    eax,ecx
  52:	48 83 c4 18          	add    rsp,0x18
        remainder = 0;
  56:	5b                   	pop    rbx
  57:	5d                   	pop    rbp
  58:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system13cuda_categoryEv:

0000000000000000 <thrust::system::cuda_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # b <thrust::system::cuda_category()+0xb>	7: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_category()::result-0x4
   b:	0f b6 00             	movzx  eax,BYTE PTR [rax]
   e:	84 c0                	test   al,al
  10:	0f 94 c0             	sete   al
  13:	84 c0                	test   al,al
  15:	74 56                	je     6d <thrust::system::cuda_category()+0x6d>
{
  17:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 1e <thrust::system::cuda_category()+0x1e>	1a: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_category()::result-0x4
  1e:	48 89 c7             	mov    rdi,rax
  21:	e8 00 00 00 00       	call   26 <thrust::system::cuda_category()+0x26>	22: R_X86_64_PLT32	__cxa_guard_acquire-0x4
  26:	85 c0                	test   eax,eax
    memcpy(&x, &f, sizeof(f));
  28:	0f 95 c0             	setne  al
  2b:	84 c0                	test   al,al
    u = (x & 0x7fffffffU);
  2d:	74 3e                	je     6d <thrust::system::cuda_category()+0x6d>
  2f:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 36 <thrust::system::cuda_category()+0x36>	32: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_category()::result-0x4
  36:	48 89 c7             	mov    rdi,rax
    sign = ((x >> 16) & 0x8000U);
  39:	e8 00 00 00 00       	call   3e <thrust::system::cuda_category()+0x3e>	3a: R_X86_64_PLT32	thrust::system::cuda_cub::detail::cuda_error_category::cuda_error_category()-0x4
  3e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 45 <thrust::system::cuda_category()+0x45>	41: R_X86_64_REX_GOTPCRELX	guard variable for thrust::system::cuda_category()::result-0x4
  45:	48 89 c7             	mov    rdi,rax
  48:	e8 00 00 00 00       	call   4d <thrust::system::cuda_category()+0x4d>	49: R_X86_64_PLT32	__cxa_guard_release-0x4
    if (u >= 0x7f800000U) {
  4d:	48 8d 15 00 00 00 00 	lea    rdx,[rip+0x0]        # 54 <thrust::system::cuda_category()+0x54>	50: R_X86_64_PC32	__dso_handle-0x4
        remainder = 0;
  54:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 5b <thrust::system::cuda_category()+0x5b>	57: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_category()::result-0x4
  5b:	48 89 c6             	mov    rsi,rax
        return static_cast<unsigned short>((u == 0x7f800000U) ? (sign | 0x7c00U) : 0x7fffU);
  5e:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 65 <thrust::system::cuda_category()+0x65>	61: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()-0x4
  65:	48 89 c7             	mov    rdi,rax
  68:	e8 00 00 00 00       	call   6d <thrust::system::cuda_category()+0x6d>	69: R_X86_64_PLT32	__cxa_atexit-0x4
  6d:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 74 <thrust::system::cuda_category()+0x74>	70: R_X86_64_REX_GOTPCRELX	thrust::system::cuda_category()::result-0x4
  74:	5d                   	pop    rbp
  75:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail5seq_tC2Ev:

0000000000000000 <thrust::detail::seq_t::seq_t()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust8cuda_cub5par_tC2Ev:

0000000000000000 <thrust::cuda_cub::par_t::par_t()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8Symbolic8BaseExprINS0_10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEEEC2Ev:

0000000000000000 <Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::BaseExpr()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8Symbolic10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEC2Ev:

0000000000000000 <Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>::SymbolExpr()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>::SymbolExpr()+0x18>	14: R_X86_64_PLT32	Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::BaseExpr()-0x4
{
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal8FixedIntILi1EEC2Ev:

0000000000000000 <Eigen::internal::FixedInt<1>::FixedInt()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZNK5Eigen8internal8FixedIntILi1EEclEv:

0000000000000000 <Eigen::internal::FixedInt<1>::operator()() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	5d                   	pop    rbp
   9:	c3                   	ret    

Disassembly of section .text._ZNK5Eigen8Symbolic8BaseExprINS0_10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEEEplILi1EEENS0_7AddExprIS6_NS0_9ValueExprINS_8internal8FixedIntIXT_EEEEEEESD_:

0000000000000000 <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::operator+<1>(Eigen::internal::FixedInt<1>) const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	53                   	push   rbx
   5:	48 83 ec 28          	sub    rsp,0x28
   9:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
   d:	48 8d 45 ef          	lea    rax,[rbp-0x11]
  11:	48 89 c7             	mov    rdi,rax
  14:	e8 00 00 00 00       	call   19 <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::operator+<1>(Eigen::internal::FixedInt<1>) const+0x19>	15: R_X86_64_PLT32	Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> >::ValueExpr()-0x4
  19:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  1d:	48 89 c7             	mov    rdi,rax
  20:	e8 00 00 00 00       	call   25 <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::operator+<1>(Eigen::internal::FixedInt<1>) const+0x25>	21: R_X86_64_PLT32	Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::derived() const-0x4
  25:	48 89 c1             	mov    rcx,rax
    memcpy(&x, &f, sizeof(f));
  28:	48 8d 55 ef          	lea    rdx,[rbp-0x11]
  2c:	48 8d 45 e0          	lea    rax,[rbp-0x20]
    u = (x & 0x7fffffffU);
  30:	48 89 ce             	mov    rsi,rcx
  33:	48 89 c7             	mov    rdi,rax
  36:	e8 00 00 00 00       	call   3b <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::operator+<1>(Eigen::internal::FixedInt<1>) const+0x3b>	37: R_X86_64_PLT32	Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > >::AddExpr(Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> const&, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > const&)-0x4
    sign = ((x >> 16) & 0x8000U);
  3b:	89 d8                	mov    eax,ebx
  3d:	48 83 c4 28          	add    rsp,0x28
  41:	5b                   	pop    rbx
  42:	5d                   	pop    rbp
  43:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj0EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<0u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<0u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<0u>::argument()-0x4
{
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj1EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<1u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<1u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<1u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj2EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<2u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<2u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<2u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj3EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<3u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<3u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<3u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj4EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<4u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<4u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<4u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj5EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<5u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<5u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<5u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj6EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<6u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<6u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<6u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj7EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<7u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<7u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<7u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj8EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<8u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<8u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<8u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional5actorINS1_8argumentILj9EEEEC2Ev:

0000000000000000 <thrust::detail::functional::actor<thrust::detail::functional::argument<9u> >::actor()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::detail::functional::actor<thrust::detail::functional::argument<9u> >::actor()+0x18>	14: R_X86_64_PLT32	thrust::detail::functional::argument<9u>::argument()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN6thrust8cuda_cub3cub11EmptyKernelIvEEvv:

0000000000000000 <void thrust::cuda_cub::cub::EmptyKernel<void>()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	e8 00 00 00 00       	call   9 <void thrust::cuda_cub::cub::EmptyKernel<void>()+0x9>	5: R_X86_64_PC32	.text+0x739
   9:	90                   	nop
   a:	5d                   	pop    rbp
   b:	c3                   	ret    

Disassembly of section .text._ZN5Eigen6MatrixIdLi10ELi1ELi0ELi10ELi1EEC2Ev:

0000000000000000 <Eigen::Matrix<double, 10, 1, 0, 10, 1>::Matrix()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Matrix<double, 10, 1, 0, 10, 1>::Matrix()+0x18>	14: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::PlainObjectBase()-0x4
  18:	e8 00 00 00 00       	call   1d <Eigen::Matrix<double, 10, 1, 0, 10, 1>::Matrix()+0x1d>	19: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::_check_template_params()-0x4
  1d:	90                   	nop
  1e:	c9                   	leave  
  1f:	c3                   	ret    

Disassembly of section .text._ZN5Eigen6MatrixIdLi10ELi10ELi0ELi10ELi10EEC2Ev:

0000000000000000 <Eigen::Matrix<double, 10, 10, 0, 10, 10>::Matrix()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Matrix<double, 10, 10, 0, 10, 10>::Matrix()+0x18>	14: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::PlainObjectBase()-0x4
  18:	e8 00 00 00 00       	call   1d <Eigen::Matrix<double, 10, 10, 0, 10, 10>::Matrix()+0x1d>	19: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::_check_template_params()-0x4
  1d:	90                   	nop
  1e:	c9                   	leave  
  1f:	c3                   	ret    

Disassembly of section .text._ZN5Eigen6MatrixIdLi10ELin1ELi0ELi10ELi10EEC2Ev:

0000000000000000 <Eigen::Matrix<double, 10, -1, 0, 10, 10>::Matrix()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Matrix<double, 10, -1, 0, 10, 10>::Matrix()+0x18>	14: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::PlainObjectBase()-0x4
  18:	e8 00 00 00 00       	call   1d <Eigen::Matrix<double, 10, -1, 0, 10, 10>::Matrix()+0x1d>	19: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::_check_template_params()-0x4
  1d:	90                   	nop
  1e:	c9                   	leave  
  1f:	c3                   	ret    

Disassembly of section .text._ZN5Eigen6MatrixIdLin1ELi1ELi0ELi10ELi1EEC2Ev:

0000000000000000 <Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()+0x18>	14: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::PlainObjectBase()-0x4
  18:	e8 00 00 00 00       	call   1d <Eigen::Matrix<double, -1, 1, 0, 10, 1>::Matrix()+0x1d>	19: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::_check_template_params()-0x4
  1d:	90                   	nop
  1e:	c9                   	leave  
  1f:	c3                   	ret    

Disassembly of section .text._ZN5Eigen3LLTINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEELi1EEC2Ev:

0000000000000000 <Eigen::LLT<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::LLT()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::LLT<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::LLT()+0x18>	14: R_X86_64_PLT32	Eigen::Matrix<double, 10, 10, 0, 10, 10>::Matrix()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	c6 80 28 03 00 00 00 	mov    BYTE PTR [rax+0x328],0x0
  23:	90                   	nop
  24:	c9                   	leave  
  25:	c3                   	ret    

Disassembly of section .text._ZN5Eigen6MatrixIcLin1ELi1ELi0ELi10ELi1EEC2Ev:

0000000000000000 <Eigen::Matrix<char, -1, 1, 0, 10, 1>::Matrix()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::Matrix<char, -1, 1, 0, 10, 1>::Matrix()+0x18>	14: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::PlainObjectBase()-0x4
  18:	e8 00 00 00 00       	call   1d <Eigen::Matrix<char, -1, 1, 0, 10, 1>::Matrix()+0x1d>	19: R_X86_64_PLT32	Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::_check_template_params()-0x4
  1d:	90                   	nop
  1e:	c9                   	leave  
  1f:	c3                   	ret    

Disassembly of section .text._ZNK5Eigen8Symbolic8BaseExprINS0_10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEEE7derivedEv:

0000000000000000 <Eigen::Symbolic::BaseExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> >::derived() const>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   c:	5d                   	pop    rbp
   d:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8Symbolic9ValueExprINS_8internal8FixedIntILi1EEEEC2Ev:

0000000000000000 <Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> >::ValueExpr()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8Symbolic8BaseExprINS0_7AddExprINS0_10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEENS0_9ValueExprINS_8internal8FixedIntILi1EEEEEEEEC2Ev:

0000000000000000 <Eigen::Symbolic::BaseExpr<Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > >::BaseExpr()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8Symbolic7AddExprINS0_10SymbolExprINS_12placeholders8internal17symbolic_last_tagEEENS0_9ValueExprINS_8internal8FixedIntILi1EEEEEEC2ERKS6_RKSB_:

0000000000000000 <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > >::AddExpr(Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> const&, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > const&)>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 20          	sub    rsp,0x20
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
  10:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
  14:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  18:	48 89 c7             	mov    rdi,rax
  1b:	e8 00 00 00 00       	call   20 <Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > >::AddExpr(Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag> const&, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > const&)+0x20>	1c: R_X86_64_PLT32	Eigen::Symbolic::BaseExpr<Eigen::Symbolic::AddExpr<Eigen::Symbolic::SymbolExpr<Eigen::placeholders::internal::symbolic_last_tag>, Eigen::Symbolic::ValueExpr<Eigen::internal::FixedInt<1> > > >::BaseExpr()-0x4
  20:	90                   	nop
  21:	c9                   	leave  
  22:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj0EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<0u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj1EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<1u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj2EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<2u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj3EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<3u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj4EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<4u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj5EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<5u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj6EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<6u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj7EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<7u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj8EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<8u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6detail10functional8argumentILj9EEC2Ev:

0000000000000000 <thrust::detail::functional::argument<9u>::argument()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::PlainObjectBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::PlainObjectBase()+0x18>	14: R_X86_64_PLT32	Eigen::MatrixBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::MatrixBase()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 89 c7             	mov    rdi,rax
  1f:	e8 00 00 00 00       	call   24 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::PlainObjectBase()+0x24>	20: R_X86_64_PLT32	Eigen::DenseStorage<double, 10, 10, 1, 0>::DenseStorage()-0x4
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEEE22_check_template_paramsEv:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::_check_template_params()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::PlainObjectBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::PlainObjectBase()+0x18>	14: R_X86_64_PLT32	Eigen::MatrixBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::MatrixBase()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 89 c7             	mov    rdi,rax
  1f:	e8 00 00 00 00       	call   24 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::PlainObjectBase()+0x24>	20: R_X86_64_PLT32	Eigen::DenseStorage<double, 100, 10, 10, 0>::DenseStorage()-0x4
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEEE22_check_template_paramsEv:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::_check_template_params()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::PlainObjectBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::PlainObjectBase()+0x18>	14: R_X86_64_PLT32	Eigen::MatrixBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::MatrixBase()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 89 c7             	mov    rdi,rax
  1f:	e8 00 00 00 00       	call   24 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::PlainObjectBase()+0x24>	20: R_X86_64_PLT32	Eigen::DenseStorage<double, 100, 10, -1, 0>::DenseStorage()-0x4
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEEE22_check_template_paramsEv:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::_check_template_params()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::PlainObjectBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::PlainObjectBase()+0x18>	14: R_X86_64_PLT32	Eigen::MatrixBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::MatrixBase()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 89 c7             	mov    rdi,rax
  1f:	e8 00 00 00 00       	call   24 <Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::PlainObjectBase()+0x24>	20: R_X86_64_PLT32	Eigen::DenseStorage<double, 10, -1, 1, 0>::DenseStorage()-0x4
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEEE22_check_template_paramsEv:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::_check_template_params()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::PlainObjectBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::PlainObjectBase()+0x18>	14: R_X86_64_PLT32	Eigen::MatrixBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::MatrixBase()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 89 c7             	mov    rdi,rax
  1f:	e8 00 00 00 00       	call   24 <Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::PlainObjectBase()+0x24>	20: R_X86_64_PLT32	Eigen::DenseStorage<char, 10, -1, 1, 0>::DenseStorage()-0x4
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15PlainObjectBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEEE22_check_template_paramsEv:

0000000000000000 <Eigen::PlainObjectBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::_check_template_params()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen10MatrixBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::MatrixBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::MatrixBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::MatrixBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::MatrixBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::DenseBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen12DenseStorageIdLi10ELi10ELi1ELi0EEC2Ev:

0000000000000000 <Eigen::DenseStorage<double, 10, 10, 1, 0>::DenseStorage()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseStorage<double, 10, 10, 1, 0>::DenseStorage()+0x18>	14: R_X86_64_PLT32	Eigen::internal::plain_array<double, 10, 0, 0>::plain_array()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen10MatrixBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::MatrixBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::MatrixBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::MatrixBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::MatrixBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::DenseBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen12DenseStorageIdLi100ELi10ELi10ELi0EEC2Ev:

0000000000000000 <Eigen::DenseStorage<double, 100, 10, 10, 0>::DenseStorage()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseStorage<double, 100, 10, 10, 0>::DenseStorage()+0x18>	14: R_X86_64_PLT32	Eigen::internal::plain_array<double, 100, 0, 0>::plain_array()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen10MatrixBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::MatrixBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::MatrixBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::MatrixBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::MatrixBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::DenseBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen12DenseStorageIdLi100ELi10ELin1ELi0EEC2Ev:

0000000000000000 <Eigen::DenseStorage<double, 100, 10, -1, 0>::DenseStorage()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseStorage<double, 100, 10, -1, 0>::DenseStorage()+0x18>	14: R_X86_64_PLT32	Eigen::internal::plain_array<double, 100, 0, 0>::plain_array()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 c7 80 20 03 00 00 00 00 00 00 	mov    QWORD PTR [rax+0x320],0x0
    memcpy(&x, &f, sizeof(f));
  27:	90                   	nop
  28:	c9                   	leave  
  29:	c3                   	ret    

Disassembly of section .text._ZN5Eigen10MatrixBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::MatrixBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::MatrixBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::MatrixBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::MatrixBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::DenseBase()-0x4
{
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen12DenseStorageIdLi10ELin1ELi1ELi0EEC2Ev:

0000000000000000 <Eigen::DenseStorage<double, 10, -1, 1, 0>::DenseStorage()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseStorage<double, 10, -1, 1, 0>::DenseStorage()+0x18>	14: R_X86_64_PLT32	Eigen::internal::plain_array<double, 10, 0, 0>::plain_array()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 c7 40 50 00 00 00 00 	mov    QWORD PTR [rax+0x50],0x0
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen10MatrixBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::MatrixBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::MatrixBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::MatrixBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::MatrixBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::DenseBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen12DenseStorageIcLi10ELin1ELi1ELi0EEC2Ev:

0000000000000000 <Eigen::DenseStorage<char, 10, -1, 1, 0>::DenseStorage()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseStorage<char, 10, -1, 1, 0>::DenseStorage()+0x18>	14: R_X86_64_PLT32	Eigen::internal::plain_array<char, 10, 0, 0>::plain_array()-0x4
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	48 c7 40 10 00 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
  24:	90                   	nop
  25:	c9                   	leave  
  26:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9EigenBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::EigenBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::EigenBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEELi0EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 0>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 0>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::EigenBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::EigenBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEELi1EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 1>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 1>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 0>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEELi3EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 3>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 3>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 1>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9DenseBaseINS_6MatrixIdLi10ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::DenseBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::DenseBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseBase<Eigen::Matrix<double, 10, 1, 0, 10, 1> >::DenseBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 1, 0, 10, 1>, 3>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal11plain_arrayIdLi10ELi0ELi0EEC2Ev:

0000000000000000 <Eigen::internal::plain_array<double, 10, 0, 0>::plain_array()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	e8 00 00 00 00       	call   11 <Eigen::internal::plain_array<double, 10, 0, 0>::plain_array()+0x11>	d: R_X86_64_PLT32	void Eigen::internal::check_static_allocation_size<double, 10>()-0x4
  11:	90                   	nop
  12:	c9                   	leave  
  13:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9EigenBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::EigenBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::EigenBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEELi0EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 0>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 0>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::EigenBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::EigenBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEELi1EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 0>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEELi3EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 3>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 3>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 1>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9DenseBaseINS_6MatrixIdLi10ELi10ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::DenseBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::DenseBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseBase<Eigen::Matrix<double, 10, 10, 0, 10, 10> >::DenseBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, 10, 0, 10, 10>, 3>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal11plain_arrayIdLi100ELi0ELi0EEC2Ev:

0000000000000000 <Eigen::internal::plain_array<double, 100, 0, 0>::plain_array()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	e8 00 00 00 00       	call   11 <Eigen::internal::plain_array<double, 100, 0, 0>::plain_array()+0x11>	d: R_X86_64_PLT32	void Eigen::internal::check_static_allocation_size<double, 100>()-0x4
  11:	90                   	nop
  12:	c9                   	leave  
  13:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9EigenBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::EigenBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::EigenBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEELi0EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 0>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 0>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::EigenBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::EigenBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEELi1EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 1>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 1>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 0>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEELi3EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 3>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 3>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 1>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9DenseBaseINS_6MatrixIdLi10ELin1ELi0ELi10ELi10EEEEC2Ev:

0000000000000000 <Eigen::DenseBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::DenseBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseBase<Eigen::Matrix<double, 10, -1, 0, 10, 10> >::DenseBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, 10, -1, 0, 10, 10>, 3>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9EigenBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::EigenBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::EigenBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEELi0EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::EigenBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::EigenBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEELi1EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEELi3EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9DenseBaseINS_6MatrixIdLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::DenseBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::DenseBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseBase<Eigen::Matrix<double, -1, 1, 0, 10, 1> >::DenseBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<double, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9EigenBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::EigenBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::EigenBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   8:	90                   	nop
   9:	5d                   	pop    rbp
   a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEELi0EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::EigenBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::EigenBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEELi1EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 0>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen15DenseCoeffsBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEELi3EEC2Ev:

0000000000000000 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 1>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen9DenseBaseINS_6MatrixIcLin1ELi1ELi0ELi10ELi1EEEEC2Ev:

0000000000000000 <Eigen::DenseBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::DenseBase()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <Eigen::DenseBase<Eigen::Matrix<char, -1, 1, 0, 10, 1> >::DenseBase()+0x18>	14: R_X86_64_PLT32	Eigen::DenseCoeffsBase<Eigen::Matrix<char, -1, 1, 0, 10, 1>, 3>::DenseCoeffsBase()-0x4
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal11plain_arrayIcLi10ELi0ELi0EEC2Ev:

0000000000000000 <Eigen::internal::plain_array<char, 10, 0, 0>::plain_array()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	e8 00 00 00 00       	call   11 <Eigen::internal::plain_array<char, 10, 0, 0>::plain_array()+0x11>	d: R_X86_64_PLT32	void Eigen::internal::check_static_allocation_size<char, 10>()-0x4
  11:	90                   	nop
  12:	c9                   	leave  
  13:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal28check_static_allocation_sizeIdLi10EEEvv:

0000000000000000 <void Eigen::internal::check_static_allocation_size<double, 10>()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal28check_static_allocation_sizeIdLi100EEEvv:

0000000000000000 <void Eigen::internal::check_static_allocation_size<double, 100>()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN5Eigen8internal28check_static_allocation_sizeIcLi10EEEvv:

0000000000000000 <void Eigen::internal::check_static_allocation_size<char, 10>()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	90                   	nop
   5:	5d                   	pop    rbp
   6:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system8cuda_cub6detail19cuda_error_categoryD2Ev:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 13 <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()+0x13>	f: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::cuda_cub::detail::cuda_error_category-0x4
  13:	48 8d 50 10          	lea    rdx,[rax+0x10]
  17:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1b:	48 89 10             	mov    QWORD PTR [rax],rdx
  1e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  22:	48 89 c7             	mov    rdi,rax
  25:	e8 00 00 00 00       	call   2a <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()+0x2a>	26: R_X86_64_PLT32	thrust::system::error_category::~error_category()-0x4
    memcpy(&x, &f, sizeof(f));
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system8cuda_cub6detail19cuda_error_categoryD0Ev:

0000000000000000 <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()-0x4
{
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	be 08 00 00 00       	mov    esi,0x8
  21:	48 89 c7             	mov    rdi,rax
  24:	e8 00 00 00 00       	call   29 <thrust::system::cuda_cub::detail::cuda_error_category::~cuda_error_category()+0x29>	25: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
    memcpy(&x, &f, sizeof(f));
  29:	c9                   	leave  
  2a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail21system_error_categoryD2Ev:

0000000000000000 <thrust::system::detail::system_error_category::~system_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 13 <thrust::system::detail::system_error_category::~system_error_category()+0x13>	f: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::detail::system_error_category-0x4
  13:	48 8d 50 10          	lea    rdx,[rax+0x10]
{
  17:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1b:	48 89 10             	mov    QWORD PTR [rax],rdx
  1e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  22:	48 89 c7             	mov    rdi,rax
  25:	e8 00 00 00 00       	call   2a <thrust::system::detail::system_error_category::~system_error_category()+0x2a>	26: R_X86_64_PLT32	thrust::system::error_category::~error_category()-0x4
    memcpy(&x, &f, sizeof(f));
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail21system_error_categoryD0Ev:

0000000000000000 <thrust::system::detail::system_error_category::~system_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::system_error_category::~system_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::detail::system_error_category::~system_error_category()-0x4
{
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	be 08 00 00 00       	mov    esi,0x8
  21:	48 89 c7             	mov    rdi,rax
  24:	e8 00 00 00 00       	call   29 <thrust::system::detail::system_error_category::~system_error_category()+0x29>	25: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
    memcpy(&x, &f, sizeof(f));
  29:	c9                   	leave  
  2a:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail22generic_error_categoryD2Ev:

0000000000000000 <thrust::system::detail::generic_error_category::~generic_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 05 00 00 00 00 	mov    rax,QWORD PTR [rip+0x0]        # 13 <thrust::system::detail::generic_error_category::~generic_error_category()+0x13>	f: R_X86_64_REX_GOTPCRELX	vtable for thrust::system::detail::generic_error_category-0x4
  13:	48 8d 50 10          	lea    rdx,[rax+0x10]
{
  17:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1b:	48 89 10             	mov    QWORD PTR [rax],rdx
  1e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  22:	48 89 c7             	mov    rdi,rax
  25:	e8 00 00 00 00       	call   2a <thrust::system::detail::generic_error_category::~generic_error_category()+0x2a>	26: R_X86_64_PLT32	thrust::system::error_category::~error_category()-0x4
    memcpy(&x, &f, sizeof(f));
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

Disassembly of section .text._ZN6thrust6system6detail22generic_error_categoryD0Ev:

0000000000000000 <thrust::system::detail::generic_error_category::~generic_error_category()>:
   0:	55                   	push   rbp
   1:	48 89 e5             	mov    rbp,rsp
   4:	48 83 ec 10          	sub    rsp,0x10
   8:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi
   c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  10:	48 89 c7             	mov    rdi,rax
  13:	e8 00 00 00 00       	call   18 <thrust::system::detail::generic_error_category::~generic_error_category()+0x18>	14: R_X86_64_PLT32	thrust::system::detail::generic_error_category::~generic_error_category()-0x4
{
  18:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1c:	be 08 00 00 00       	mov    esi,0x8
  21:	48 89 c7             	mov    rdi,rax
  24:	e8 00 00 00 00       	call   29 <thrust::system::detail::generic_error_category::~generic_error_category()+0x29>	25: R_X86_64_PLT32	operator delete(void*, unsigned long)-0x4
    memcpy(&x, &f, sizeof(f));
  29:	c9                   	leave  
  2a:	c3                   	ret    
