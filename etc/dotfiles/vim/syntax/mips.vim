" Vim syntax file
" Language:	MIPS R[34]k
" Maintainer:	Jason Zdan <surefire@propaganda.yi.org>
"" Last change:	$Date: 1999/08/16 23:42:36 $	
" Filenames:	*.s
"" URL: http://www.datatone.com/~robb/vim/syntax/masm.vim
"" $Revision: 1.5 $


" Remove any old syntax stuff hanging around
syn clear

syn case ignore


" syn match masmType "\.word"

"syn match mipsIdentifier 	"[a-zA-A_][a-zA-Z0-9_]*"

syn match mipsDecimal           "-\?\d*"
"syn match masmBinary            "[0-1]\+b"  "put this before hex or 0bfh dies!
syn match mipsHexadecimal       "-\?0x\x\+"
"syn match masmFloat             "[0-9]\x*r"

syn match mipsComment		"#.*"
syn region mipsString            start=+"+ end=+"+

"syn keyword masmOperator        AND BYTE PTR CODEPTR DATAPTR DUP DWORD EQ FAR
"syn keyword masmOperator        FWORD GE GT HIGH LARGE LE LOW LT MOD NE NEAR
"syn keyword masmOperator        NOT OFFSET OR PROC PWORD QWORD SEG SHORT TBYTE
"syn keyword masmOperator        TYPE WORD PARA
"syn keyword masmDirective	ALIGN ARG ASSUME CODESEG COMM
"syn keyword masmDirective       CONST DATASEG DB DD DF DISPLAY DOSSEG DP
"syn keyword masmDirective       DQ DT DW ELSE ELSEIF EMUL END ENDIF ENDM ENDP
"syn keyword masmDirective       ENDS ENUM EQU PROC PUBLIC PUBLICDLL RADIX 
"syn keyword masmDirective       EXTRN FARDATA GLOBAL RECORD SEGMENT SMALLSTACK
"syn keyword masmDirective       GROUP IF IF1 IF2 IFB IFDEF IFDIF IFDIFI
"syn keyword masmDirective       IFE IFIDN IFIDNI IFNB IFNDEF INCLUDE INCLUDLIB
"syn keyword masmDirective       LABEL LARGESTACK STACK STRUC SUBTTL TITLE
"syn keyword masmDirective       MODEL NAME NOEMUL UNION USES VERSION 
"syn keyword masmDirective       ORG FLAT
"syn match   masmDirective       "\.model"
"syn match   masmDirective       "\.186"
"syn match   masmDirective       "\.286"
"syn match   masmDirective       "\.286c"
"syn match   masmDirective       "\.286p"
"syn match   masmDirective       "\.287"
"syn match   masmDirective       "\.386"
"syn match   masmDirective       "\.386c"
"syn match   masmDirective       "\.386p"
"syn match   masmDirective       "\.387"
"syn match   masmDirective       "\.486"
"syn match   masmDirective       "\.486c"
"syn match   masmDirective       "\.486p"
"syn match   masmDirective       "\.8086"
"syn match   masmDirective       "\.8087"
"syn match   masmDirective       "\.ALPHA"
"syn match   masmDirective       "\.CODE"
"syn match   masmDirective       "\.DATA"

syn match mipsDirective		"\.align"
syn match mipsDirective		"\.asciiz\?"
syn match mipsDirective		"\.byte"
syn match mipsDirective		"\.data"
syn match mipsDirective		"\.double"
syn match mipsDirective		"\.extern"
syn match mipsDirective		"\.float"
syn match mipsDirective		"\.globl"
syn match mipsDirective		"\.half"
syn match mipsDirective		"\.kdata"
syn match mipsDirective		"\.ktext"
syn match mipsDirective		"\.set"
syn match mipsDirective		"\.space"
syn match mipsDirective		"\.text"
syn match mipsDirective		"\.word"

syn match mipsRegister		"\$[kv][0-1]"
syn match mipsRegister		"\$t[0-9]"
syn match mipsRegister		"\$a[0-3]"
syn match mipsRegister		"\$s[0-7]"
syn match mipsRegister		"\$\([0-2][0-9]\|3[01]\|[0-9]\)"
syn match mipsRegister		"\$zero"
syn match mipsRegister		"\$ra"
syn match mipsRegister		"\$fp"
syn match mipsRegister		"\$sp"
syn match mipsRegister		"\$gp"
syn match mipsRegister		"\$at"

" this needs to be near the end, i don't know why :/
syn match mipsLabel             "^[a-zA-Z_.][a-zA-Z0-9_.]\+:"he=e-1

"syn keyword masmRegister        ES DS SS CS
"syn keyword masmRegister        AH BH CH DH AL BL CL DL
"syn keyword masmRegister        EAX EBX ECX EDX ESI EDI EBP ESP


" these are current as of the 486 - don't have any pentium manuals handy
"syn keyword masmOpcode          AAA AAD AAM AAS ADC ADD AND ARPL BOUND BSF
"syn keyword masmOpcode          BSR BSWAP BT BTC BTR BTS BSWAP BT BTC BTR
"syn keyword masmOpcode          BTS CALL CBW CDQ CLC CLD CLI CLTS CMC CMP
"syn keyword masmOpcode          CMPS CMPSB CMPSW CMPSD CMPXCHG CWD CWDE DAA
"syn keyword masmOpcode          DAS DEC DIV ENTER HLT IDIV IMUL IN INC INS 
"syn keyword masmOpcode          INSB INSW INSD INT INTO INVD INVLPG IRET 
"syn keyword masmOpcode          IRETD JA JAE JB JBE JC JCXZ JECXZ JE JZ JG
"syn keyword masmOpcode          JGE JL JLE JNA JNAE JNB JNBE JNC JNE JNG JNGE
"syn keyword masmOpcode          JNL JNLE JNO JNP JNS JNZ JO JP JPE JPO JS JZ
"syn keyword masmOpcode          JMP LAHF LAR LEA LEAVE LGDT LIDT LGS LSS LFS
"syn keyword masmOpcode          LODS LODSB LODSW LODSD LOOP LOOPE LOOPZ LOONE
"syn keyword masmOpcode          LOOPNE
"syn keyword masmOpcode          LDS LES LLDT LMSW LOCK LSL LTR MOV MOVS MOVSB
"syn keyword masmOpcode          MOVSW MOVSD MOVSX MOVZX MUL NEG NOP NOT OR
"syn keyword masmOpcode          OUT OUTS OUTSB OUTSW OUTSD POP POPA POPD
"syn keyword masmOpcode          POPF POPFD PUSH PUSHA PUSHAD PUSHF PUSHFD
"syn keyword masmOpcode          RCL RCR ROL ROR REP REPE REPZ REPNE REPNZ
"syn keyword masmOpcode          RET SAHF SAL SAR SHL SHR SBB SCAS SCASB
"syn keyword masmOpcode          SCASW SCASD SETA SETAE SETB SETBE SETC SETE
"syn keyword masmOpcode          SETG SETGE SETL SETLE SETNA SETNAE SETNB
"syn keyword masmOpcode          SETNBE SETNC SETNE SETNG SETNGE SETNL SETNLE
"syn keyword masmOpcode          SETNO SETNP SETNS SETNZ SETO SETP SETPE SETPO
"syn keyword masmOpcode          SETS SETZ SGDT SIDT SHLD SHRD SLDT SMSW STC
"syn keyword masmOpcode          STD STI STOS STOSB STOSW STOSD STR SUB TEST
"syn keyword masmOpcode          VERR VERW WAIT WBINVD XADD XCHG XLAT XLATB XOR

" floating point coprocessor as of 487
"syn keyword masmOpFloat         F2XM1 FABS FADD FADDP FBLD FBSTP FCHS FCLEX
"syn keyword masmOpFloat         FNCLEX FCOM FCOMP FCOMPP FCOS FDECSTP FDISI
"syn keyword masmOpFloat         FNDISI FDIV FDIVP FDIVR FDIVRP FENI FNENI
"syn keyword masmOpFloat         FFREE FIADD FICOM FICOMP FIDIV FIDIVR FILD
"syn keyword masmOpFloat         FIMUL FINCSTP FINIT FNINIT FIST FISTP FISUB
"syn keyword masmOpFloat         FISUBR FLD FLDCW FLDENV FLDLG2 FLDLN2 FLDL2E
"syn keyword masmOpFloat         FLDL2T FLDPI FLDZ FLD1 FMUL FMULP FNOP FPATAN
"syn keyword masmOpFloat         FPREM FPREM1 FPTAN FRNDINT FRSTOR FSAVE 
"syn keyword masmOpFloat         FNSAVE FSCALE FSETPM FSIN FSINCOS FSQRT FST
"syn keyword masmOpFloat         FSTCW FNSTCW FSTENV FNSTENV FSTP FSTSW FNSTSW
"syn keyword masmOpFloat         FSUB FSUBP FSUBR FSUBRP FTST FUCOM FUCOMP 
"syn keyword masmOpFloat         FUCOMPP FWAIT FXAM FXCH FXTRACT FYL2X FYL2XP1
"syn match   masmOpFloat         "FSTSW[ \t]\+AX"
"syn match   masmOpFloat         "FNSTSW[ \t]\+AX"

syn keyword mipsInstruction	abs add addu addi addiu and andi div divu mult
syn keyword mipsInstruction	multu mul mulo mulou neg negu nor not or ori
syn keyword mipsInstruction	rem remu sll sllv sra srav srl srlv rol ror sub
syn keyword mipsInstruction	subu xor xori lui li slt sltu slti sltiu seq
syn keyword mipsInstruction	sge sgeu sgt sgtu sle sleu sne b beq bgez
syn keyword mipsInstruction	bgezal bgtz blez bltzal bltz bne beqz bge bgeu
syn keyword mipsInstruction	bgt bgtu ble bleu blt bltu bnez j jal jalr jr
syn keyword mipsInstruction	la lb lbu lh lhu lw lwl lwr ld ulh ulhu ulw sb
syn keyword mipsInstruction	sh sw swl swr sd ush usw move mfhi mflo mthi
syn keyword mipsInstruction	mtlo rfe syscall break nop
syn match mipsInstruction	"bc[0-3][tf]"
syn match mipsInstruction	"[ls]wc[0-3]"
syn match mipsInstruction	"m[ft]c[0-3]"

if !exists("did_mips_syntax_inits")
  let did_mips_syntax_inits = 1

  " The default methods for highlighting.  Can be overridden later
  hi link mipsLabel	    Special
  hi link mipsComment	    Comment
  hi link mipsDirective	    Statement
  hi link mipsInstruction   Identifier
  hi link mipsString	    String

  hi link mipsHexadecimal   Number
  hi link mipsDecimal	    Number
  "hi link masmBinary    Number
  "hi link masmFloat     Number

  hi link mipsRegister	    Type

  "hi link mipsIdentifier Identifier
endif

let b:current_syntax = "mips"

