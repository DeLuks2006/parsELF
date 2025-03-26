; EP TABLE MAGIC NUMBERS -----------------------------------------

%define UNKNOWN_ENDIAN  0x00
%define BIG_ENDIAN      0x01
%define LITTLE_ENDIAN   0x02

%define EM_NONE	        	0	  ; No machine 
%define EM_M32	        	1	  ; AT&T WE 32100 
%define EM_SPARC        	2	  ; SUN SPARC 
%define EM_386	        	3	  ; Intel 80386 
%define EM_68K	        	4	  ; Motorola m68k family 
%define EM_88K	        	5	  ; Motorola m88k family 
%define EM_IAMCU        	6	  ; Intel MCU 
%define EM_860		        7   ; Intel 80860 
%define EM_MIPS		        8	  ; MIPS R3000 big-endian 
%define EM_S370		        9	  ; IBM System/370 
%define EM_MIPS_RS3_LE	  10	; MIPS R3000 little-endian 
%define EM_PARISC	        15	; HPPA 
%define EM_VPP500	        17	; Fujitsu VPP500 
%define EM_SPARC32PLUS  	18	; Sun's "v8plus" 
%define EM_960	        	19	; Intel 80960 
%define EM_PPC	        	20	; PowerPC 
%define EM_PPC64        	21	; PowerPC 64-bit 
%define EM_S390	        	22	; IBM S390 
%define EM_SPU	        	23	; IBM SPU/SPC 
%define EM_V800	        	36	; NEC V800 series 
%define EM_FR20	        	37	; Fujitsu FR20 
%define EM_RH32	        	38	; TRW RH-32 
%define EM_RCE	        	39	; Motorola RCE 
%define EM_ARM	        	40	; ARM 
%define EM_FAKE_ALPHA   	41	; Digital Alpha 
%define EM_SH	          	42	; Hitachi SH 
%define EM_SPARCV9      	43	; SPARC v9 64-bit 
%define EM_TRICORE      	44	; Siemens Tricore 
%define EM_ARC	        	45	; Argonaut RISC Core 
%define EM_H8_300       	46	; Hitachi H8/300 
%define EM_H8_300H      	47	; Hitachi H8/300H 
%define EM_H8S	        	48	; Hitachi H8S 
%define EM_H8_500       	49	; Hitachi H8/500 
%define EM_IA_64        	50	; Intel Merced 
%define EM_MIPS_X       	51	; Stanford MIPS-X 
%define EM_COLDFIRE     	52	; Motorola Coldfire 
%define EM_68HC12       	53	; Motorola M68HC12 
%define EM_MMA	        	54	; Fujitsu MMA Multimedia Accelerator 
%define EM_PCP	        	55	; Siemens PCP 
%define EM_NCPU	        	56	; Sony nCPU embeeded RISC 
%define EM_NDR1	        	57	; Denso NDR1 microprocessor 
%define EM_STARCORE     	58	; Motorola Startore processor */
%define EM_ME16	        	59	; Toyota ME16 processor 
%define EM_ST100      	  60	; STMicroelectronic ST100 processor 
%define EM_TINYJ      	  61	; Advanced Logic Corp. Tinyj emb.fam 
%define EM_X86_64     	  62	; AMD x86-64 architecture 
%define EM_PDSP		        63	; Sony DSP Processor 
%define EM_PDP10	        64	; Digital PDP-10 
%define EM_PDP11	        65	; Digital PDP-11 
%define EM_FX66		        66	; Siemens FX66 microcontroller 
%define EM_ST9PLUS	      67	; STMicroelectronics ST9+ 8/16 mc 
%define EM_ST7		        68	; STmicroelectronics ST7 8 bit mc 
%define EM_68HC16	        69	; Motorola MC68HC16 microcontroller 
%define EM_68HC11	        70	; Motorola MC68HC11 microcontroller 
%define EM_68HC08	        71	; Motorola MC68HC08 microcontroller 
%define EM_68HC05	        72	; Motorola MC68HC05 microcontroller 
%define EM_SVX		        73	; Silicon Graphics SVx 
%define EM_ST19		        74	; STMicroelectronics ST19 8 bit mc 
%define EM_VAX		        75	; Digital VAX 
%define EM_CRIS		        76	; Axis Communications 32-bit emb.proc 
%define EM_JAVELIN	      77	; Infineon Technologies 32-bit emb.proc 
%define EM_FIREPATH     	78	; Element 14 64-bit DSP Processor 
%define EM_ZSP	    	    79	; LSI Logic 16-bit DSP Processor 
%define EM_MMIX	    	    80	; Donald Knuth's educational 64-bit proc 
%define EM_HUANY    	    81	; Harvard University machine-independent object files 
%define EM_PRISM    	    82	; SiTera Prism 
%define EM_AVR	    	    83	; Atmel AVR 8-bit microcontroller 
%define EM_FR30	      	  84	; Fujitsu FR30 
%define EM_D10V	       	  85	; Mitsubishi D10V 
%define EM_D30V	      	  86	; Mitsubishi D30V 
%define EM_V850		        87	; NEC v850 
%define EM_M32R		        88	; Mitsubishi M32R 
%define EM_MN10300	      89	; Matsushita MN10300 
%define EM_MN10200	      90	; Matsushita MN10200 
%define EM_PJ		          91	; picoJava 
%define EM_OPENRISC	      92	; OpenRISC 32-bit embedded processor 
%define EM_ARC_COMPACT	  93	; ARC International ARCompact 
%define EM_XTENSA	        94	; Tensilica Xtensa Architecture 
%define EM_VIDEOCORE	    95	; Alphamosaic VideoCore 
%define EM_TMM_GPP	      96	; Thompson Multimedia General Purpose Proc 
%define EM_NS32K	        97	; National Semi. 32000 
%define EM_TPC		        98	; Tenor Network TPC 
%define EM_SNP1K	        99	; Trebia SNP 1000 
%define EM_ST200	        100	; STMicroelectronics ST200 
%define EM_IP2K		        101	; Ubicom IP2xxx 
%define EM_MAX		        102	; MAX processor 
%define EM_CR		          103	; National Semi. CompactRISC 
%define EM_F2MC16	        104	; Fujitsu F2MC16 
%define EM_MSP430	        105	; Texas Instruments msp430 
%define EM_BLACKFIN	      106	; Analog Devices Blackfin DSP 
%define EM_SE_C33	        107	; Seiko Epson S1C33 family 
%define EM_SEP		        108	; Sharp embedded microprocessor 
%define EM_ARCA		        109	; Arca RISC 
%define EM_UNICORE	      110	; PKU-Unity & MPRC Peking Uni. mc series 
%define EM_EXCESS	        111	; eXcess configurable cpu 
%define EM_DXP		        112	; Icera Semi. Deep Execution Processor 
%define EM_ALTERA_NIOS2   113	; Altera Nios II 
%define EM_CRX		        114	; National Semi. CompactRISC CRX 
%define EM_XGATE	        115	; Motorola XGATE 
%define EM_C166		        116	; Infineon C16x/XC16x 
%define EM_M16C		        117	; Renesas M16C 
%define EM_DSPIC30F	      118	; Microchip Technology dsPIC30F 
%define EM_CE		          119	; Freescale Communication Engine RISC 
%define EM_M32C		        120	; Renesas M32C 
%define EM_TSK3000	      131	; Altium TSK3000 
%define EM_RS08		        132	; Freescale RS08 
%define EM_SHARC	        133	; Analog Devices SHARC family 
%define EM_ECOG2	        134	; Cyan Technology eCOG2 
%define EM_SCORE7	        135	; Sunplus S+core7 RISC 
%define EM_DSP24	        136	; New Japan Radio (NJR) 24-bit DSP 
%define EM_VIDEOCORE3	    137	; Broadcom VideoCore III 
%define EM_LATTICEMICO32  138	; RISC for Lattice FPGA 
%define EM_SE_C17	        139	; Seiko Epson C17 
%define EM_TI_C6000	      140	; Texas Instruments TMS320C6000 DSP 
%define EM_TI_C2000	      141	; Texas Instruments TMS320C2000 DSP 
%define EM_TI_C5500	      142	; Texas Instruments TMS320C55x DSP 
%define EM_TI_ARP32	      143	; Texas Instruments App. Specific RISC 
%define EM_TI_PRU	        144	; Texas Instruments Prog. Realtime Unit 
%define EM_MMDSP_PLUS	    160	; STMicroelectronics 64bit VLIW DSP 
%define EM_CYPRESS_M8C  	161	; Cypress M8C 
%define EM_R32C		        162	; Renesas R32C 
%define EM_TRIMEDIA	      163	; NXP Semi. TriMedia 
%define EM_QDSP6	        164	; QUALCOMM DSP6 
%define EM_8051		        165	; Intel 8051 and variants 
%define EM_STXP7X	        166	; STMicroelectronics STxP7x 
%define EM_NDS32	        167	; Andes Tech. compact code emb. RISC 
%define EM_ECOG1X        	168	; Cyan Technology eCOG1X 
%define EM_MAXQ30	        169	; Dallas Semi. MAXQ30 mc 
%define EM_XIMO16      	  170	; New Japan Radio (NJR) 16-bit DSP 
%define EM_MANIK	        171	; M2000 Reconfigurable RISC 
%define EM_CRAYNV2	      172	; Cray NV2 vector architecture 
%define EM_RX		          173	; Renesas RX 
%define EM_METAG	        174	; Imagination Tech. META 
%define EM_MCST_ELBRUS	  175	; MCST Elbrus 
%define EM_ECOG16	        176	; Cyan Technology eCOG16 
%define EM_CR16		        177	; National Semi. CompactRISC CR16 
%define EM_ETPU		        178	; Freescale Extended Time Processing Unit 
%define EM_SLE9X	        179	; Infineon Tech. SLE9X 
%define EM_L10M	          180	; Intel L10M 
%define EM_K10M		        181	; Intel K10M 
%define EM_AARCH64	      183	; ARM AARCH64 
%define EM_AVR32	        185	; Amtel 32-bit microprocessor 
%define EM_STM8		        186	; STMicroelectronics STM8 
%define EM_TILE64	        187	; Tileta TILE64 
%define EM_TILEPRO	      188	; Tilera TILEPro 
%define EM_MICROBLAZE	    189	; Xilinx MicroBlaze 
%define EM_CUDA		        190	; NVIDIA CUDA 
%define EM_TILEGX	        191	; Tilera TILE-Gx 
%define EM_CLOUDSHIELD	  192	; CloudShield 
%define EM_COREA_1ST	    193	; KIPO-KAIST Core-A 1st gen. 
%define EM_COREA_2ND	    194	; KIPO-KAIST Core-A 2nd gen. 
%define EM_ARC_COMPACT2	  195	; Synopsys ARCompact V2 
%define EM_OPEN8	        196	; Open8 RISC 
%define EM_RL78	      	  197	; Renesas RL78 
%define EM_VIDEOCORE5	    198	; Broadcom VideoCore V 
%define EM_78KOR	        199	; Renesas 78KOR 
%define EM_56800EX	      200	; Freescale 56800EX DSC 
%define EM_BA1		        201	; Beyond BA1 
%define EM_BA2		        202	; Beyond BA2 
%define EM_XCORE	        203	; XMOS xCORE 
%define EM_MCHP_PIC	      204	; Microchip 8-bit PIC(r) 
%define EM_KM32		        210	; KM211 KM32 
%define EM_KMX32	        211	; KM211 KMX32 
%define EM_EMX16	        212	; KM211 KMX16 
%define EM_EMX8		        213	; KM211 KMX8 
%define EM_KVARC	        214	; KM211 KVARC 
%define EM_CDP		        215	; Paneve CDP 
%define EM_COGE		        216	; Cognitive Smart Memory Processor 
%define EM_COOL		        217	; Bluechip CoolEngine 
%define EM_NORC		        218	; Nanoradio Optimized RISC 
%define EM_CSR_KALIMBA	  219	; CSR Kalimba 
%define EM_Z80		        220	; Zilog Z80 
%define EM_VISIUM	        221	; Controls and Data Services VISIUMcore 
%define EM_FT32		        222	; FTDI Chip FT32 
%define EM_MOXIE	        223	; Moxie processor 
%define EM_AMDGPU	        224	; AMD GPU 
%define EM_RISCV	        243	; RISC-V 
%define EM_BPF		        247	; Linux BPF -- in-kernel virtual machine 
%define EM_CSKY		        252 ; C-SKY 
%define EM_NUM		        253

;  Old spellings/synonyms.
%define EM_ARC_A5	EM_ARC_COMPACT
  

; ...
