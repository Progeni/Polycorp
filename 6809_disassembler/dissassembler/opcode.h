/*
	OPCODE.H
	--------
*/
#pragma once

/*
	Assembly Instruction Parameters
	Parameter		Definition
		XX			No Parameters
		QQ			8 bit address
		DD			8 bit data
		MM_NN		16 bit displacement
		MM			8 bit displacement
		PP			Post byte (special for 6809)
		SS_QQ		16 bit address
		DD_DD		16 bit data
*/

enum {XX, QQ, DD, MM_NN, MM, PP, SS_QQ, DD_DD};

/*
	Addressing Modes:
	Mode				Definition
	IHERENT				no parameters
	IMMEDIATE			# data immediate supplied (8 or 16 bit)
	RELATIVE			relative address in a branch instruction
	BASE_PAGE_DIRECT	8 bit offset from the base page (DP) register
	EXTENDED_DIRECT		absolute 16 bit address
	REGISTER			destination register for TFR (transfer) and EXG (exchange)
	REGISTER_STACK		which registers to push or pull
	INDEXED_INDIRECT	Post-byte stuff
	SPECIAL				used by the dissassember to mark page 10 and page 11 extended opcodes
*/
enum {BASE_PAGE_DIRECT, INHERENT, SPECIAL, IMMEDIATE, REGISTER, REGISTER_STACK, RELATIVE, INDEXED_INDIRECT, EXTENDED_DIRECT};

extern const char *NONE;
/*
	class ASPT_OPCODE
	-----------------
*/
class ASPT_opcode
{
public:
	unsigned char val;
	long parameter;
	const char *name;
	long mode;
} ;

extern ASPT_opcode page0_opcode[];
extern ASPT_opcode page10_opcode[];
extern ASPT_opcode page11_opcode[];

extern long page0_opcode_size;
extern long page10_opcode_size;
extern long page11_opcode_size;


