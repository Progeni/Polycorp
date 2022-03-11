/*
	DECODE.C
	--------
*/
#include <strstream>
#include <iomanip>

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include "str.h"
#include "decode.h"
#include "opcode.h"
#include "memory.h"

using namespace std;

ASPT_opcode ASPT_decode::opcode_none = {0x01, XX,    NONE,    INHERENT};

/*
	ASPT_DECODE::ASPT_DECODE()
	--------------------------
*/
ASPT_decode::ASPT_decode(ASPT_memory *memory)
{
cpu_memory = memory;
pc = 0;

qsort(page0_opcode,  page0_opcode_size,  sizeof(*page0_opcode),  opcode_cmp);
qsort(page10_opcode, page10_opcode_size, sizeof(*page10_opcode), opcode_cmp);
qsort(page11_opcode, page11_opcode_size, sizeof(*page11_opcode), opcode_cmp);
}

/*
	ASPT_DECODE::~ASPT_DECODE()
	---------------------------
*/
ASPT_decode::~ASPT_decode()
{
}

/*
	CHAR ASPT_DECODE::MEMORY()
	--------------------------
*/
unsigned char ASPT_decode::memory(long address, long type)
{
cpu_memory->set_type(address, type);
return cpu_memory->get(address);
}

/*
	CHAR ASPT_DECODE::SET_TYPE()
	----------------------------
*/
void ASPT_decode::set_type(long address, long type)
{
cpu_memory->set_type(address, type);
}

/*
	ASPT_DECODE::GET_OPCODE()
	-------------------------
*/
ASPT_opcode *ASPT_decode::get_opcode(unsigned char val, long page)
{
ASPT_opcode key;
void *got;

key.val = val;

if (page == 0)
	got = bsearch(&key, page0_opcode, page0_opcode_size, sizeof(*page0_opcode), opcode_cmp);
else if (page == 10)
	got = bsearch(&key, page10_opcode, page10_opcode_size, sizeof(*page10_opcode), opcode_cmp);
else if (page == 11)
	got = bsearch(&key, page11_opcode, page11_opcode_size, sizeof(*page11_opcode), opcode_cmp);
else
	return &opcode_none;

return got == NULL ? &opcode_none : (ASPT_opcode *)got;
}

/*
	ASPT_DECODE::OPCODE_CMP()
	-------------------------
*/
int ASPT_decode::opcode_cmp(const void *a, const void *b)
{
ASPT_opcode *one, *two;
one = (ASPT_opcode *)a;
two = (ASPT_opcode *)b;

return one->val > two->val ? 1 : one->val == two->val ? 0 : -1;
}

/*
	ASPT_DECODE::DUMP()
	-------------------
*/
void ASPT_decode::dump(void)
{
long column;
unsigned char byte;

printf("%04X ", (unsigned int)pc);
for (column = 0; column <= 0x0F; column++)
	printf("%02X ", memory(pc + column));

for (column = 0; column <= 0x0F; column++)
	{
	byte = memory(pc + column);
	if (!isprint(byte))
		byte = '.';
	printf("%c", byte);
	}
printf("\n");

pc += 0x10;
}

/*
	ASPT_DECODE::DUMP()
	-------------------
	up to but not including end
*/
void ASPT_decode::dump(long end)
{
long column, done;
unsigned char byte;

done = 0x10;
while (pc < end)
	{
	printf("%04X ", (unsigned int)pc);
	for (column = 0; column <= 0x0F; column++)
		{
		if (pc + column >= end)
			printf("   ");
		else
			printf("%02X ", memory(pc + column, UNKNOWN));
		}

	for (column = 0; column <= 0x0F; column++)
		{
		byte = memory(pc + column, UNKNOWN);
		if (!isprint(byte))
			byte = '.';
		if (pc + column == end)
			done = column;
		if (pc + column >= end)
			printf(" ");
		else
			printf("%c", byte);
		}
	printf("   ;\n");

	pc += done;
	}
}


/*
	ASPT_DECODE::DECODE_REGISTER_NYBBLE()
	-------------------------------------
*/
const char *ASPT_decode::decode_register_nybble(unsigned char nybble)
{
switch (nybble)
	{
	case 0x00:
		return "D";
	case 0x01:
		return "X";
	case 0x02:
		return "Y";
	case 0x03:
		return "U";
	case 0x04:
		return "S";
	case 0x05:
		return "PC";
	case 0x08:
		return "A";
	case 0x09:
		return "B";
	case 0x0A:
		return "CC";
	case 0x0B:
		return "DP";
	}
return "-";	// ERROR
}


/*
	ASPT_DECODE::DECODE_REGISTER_STACK()
	------------------------------------
*/
char *ASPT_decode::decode_register_stack(ASPT_opcode *opcode, unsigned char byte)
{
ostrstream regs;

if (byte == 0)
	regs << "; None,";
else
	{
	if (byte & 0x80)
		regs << "PC,";
	if (byte & 0x40)
		{
		if (opcode->val == 0x34 || opcode->val == 0x35)
			regs << "U,";
		else // if (opcode->val == 0x36 || opcode->val == 0x37)
			regs << "S,";
		}
	if (byte & 0x20)
		regs << "Y,";
	if (byte & 0x10)
		regs << "X,";
	if (byte & 0x08)
		regs << "DP,";
	if ((byte & 0x06) == 0x06)
		regs << "D,";
	else
		{
		if (byte & 0x04)
			regs << "B,";
		else if (byte & 0x02)
			regs << "A,";
		}
	if (byte & 0x01)
		regs << "CC,";
	}

regs.seekp(regs.pcount() - 1);
regs << ends;
return regs.str();
}

/*
	ASPT_DECODE::HEX_WIDTH()
	------------------------
*/
char *ASPT_decode::hex_width(long val, long width)
{
if (val >= 0)
	sprintf(temp_buffer, "$%0*lX", (int)width, val);
else
	sprintf(temp_buffer, "$-%0*lX", (int)width, -val);

return temp_buffer;
}

/*
	ASPT_DECODE::DECODE_POST_BYTE()
	-------------------------------
*/
char *ASPT_decode::decode_post_byte(ASPT_opcode *opcode, unsigned char byte)
{
static const char *reg[] = {"X", "Y", "U", "S"};
ostrstream string;
long offset, indirect, mode, which_register;
unsigned char offset_byte, offset_byte2;
long word;

which_register = (byte >> 5) & 0x03;

if ((byte & 0x80) == 0)
	{
	offset = byte & 0x1F;
	if (offset & 0x10)		// high bit set so negative
		offset = -(0x10 - (offset & 0x0F));
	string << hex_width(offset, 2) << "," << reg[which_register];
	}
else
	{
	indirect = byte & 0x10;
	mode = byte & 0x0F;

	if (indirect)
		string << "[";

	switch (mode)
		{
		case 0x00:
			string << "," << reg[which_register] << "+";
			break;
		case 0x01:
			string << "," << reg[which_register] << "++";
			break;
		case 0x02:
			string << ",-" << reg[which_register];
			break;
		case 0x03:
			string << ",--" << reg[which_register];
			break;
		case 0x04:
			string << "," << reg[which_register];
			break;
		case 0x05:
			string << "B," << reg[which_register];
			break;
		case 0x06:
			string << "A," << reg[which_register];
			break;
		case 07:
			string << "-";			// ERROR
			break;
		case 0x08:
			offset_byte = memory(pc++);
			string << hex_width((int)((char)offset_byte), 2) << "," << reg[which_register];
	   		break;
		case 0x09:
			offset_byte = memory(pc++);
			offset_byte2 = memory(pc++);
			word = offset_byte << 8 | offset_byte2;
			string << hex_width(word, 4) << "," << reg[which_register];
	   		break;
		case 0x0A:
			string << "-";			// ERROR
			break;
		case 0x0B:
			string << "D," << reg[which_register];
			break;
		case 0x0C:
			offset_byte = memory(pc++);
			string << setw(2) << hex_width((int)((char)offset_byte), 2) << ",PC";
			break;
		case 0x0D:
			offset_byte = memory(pc++);
			offset_byte2 = memory(pc++);
			word = offset_byte << 8 | offset_byte2;
			string << hex_width((int)word, 4) << ",PC";
	   		break;
		case 0x0E:
			string << "-";			// ERROR
			break;
		case 0x0F:
			if (!indirect)
				string << "-";
			else
				{
				offset_byte = memory(pc++);
				offset_byte2 = memory(pc++);
				word = offset_byte << 8 | offset_byte2;
				string << hex_width((int)word, 4);
				}
	   		break;
		}

	if (indirect)
		string << "]";
	}

string << ends;
return string.str();
}

/*
	ASPT_DECODE::DECODE()
	---------------------
*/
char *ASPT_decode::decode(long *location, ASPT_opcode **operation)
{
char machine_code[80];
ostrstream instruction;
ASPT_opcode *opcode;
unsigned char byte, byte2;
unsigned long word;
char *registers, *operand, *here;
long pc_start, cell;

pc_start = pc;
byte = memory(pc++);

opcode = get_opcode(byte);
if (opcode->mode == SPECIAL)
	{
	if (byte == 0x10)
		opcode = get_opcode(memory(pc++), 10);
	else // byte == 0x11
		opcode = get_opcode(memory(pc++), 11);
	}

instruction << setw(8) << setiosflags(ios::left) << opcode->name;

if (opcode->mode == IMMEDIATE)
	instruction << "#";

switch (opcode->parameter)
	{
	case XX:
		break;
	case MM:	// 8 bit relative address
		byte = memory(pc++);
		instruction << hex_width(pc + (char)byte, 4);
		set_type(pc + (char)byte, DESTINATION);
		if (opcode->val == 0x8D)				/* BSR */
			set_type(pc + (char)byte, DESTINATION | ROUTINE);
		break;
	case QQ:	// 8 bit address
	case DD:	// 8 bit data
		byte = memory(pc++);
		if (opcode->mode == BASE_PAGE_DIRECT)
			instruction << hex_width(byte, 2) << "    ;(DP" << hex_width(byte, 2) << ")";
		else if (opcode->mode == REGISTER)
			instruction << decode_register_nybble(byte >> 4) << "," << decode_register_nybble(byte & 0x0F);
		else if (opcode->mode == REGISTER_STACK)
			{
			registers = decode_register_stack(opcode, byte);
			instruction << registers;
			delete [] registers;
			}
		else
			instruction << hex_width(byte, 2);
		break;
	case PP:
		byte = memory(pc++);
		operand = decode_post_byte(opcode, byte);
		instruction << operand;
		delete [] operand;
		break;
	case MM_NN:	// 16 bit relative address
		byte = memory(pc++);
		byte2 = memory(pc++);
		word = (signed short)(byte << 8 | byte2);
		instruction << hex_width(pc + (int)word, 4);
		set_type(pc + (int)word, DESTINATION);
		if (opcode->val == 0x17)				/* LBSR */
			set_type(pc + (int)word, DESTINATION | ROUTINE);
		break;
	case SS_QQ:	// 16 bit address
	case DD_DD:	// 16 bit data
		byte = memory(pc++);
		byte2 = memory(pc++);
		word = byte << 8 | byte2;
		instruction << hex_width(word, 4);
		if (opcode->val == 0x7E)				/* JMP */
			set_type(word, DESTINATION);
		if (opcode->val == 0xBD)				/* JSR */
			set_type(word, DESTINATION | ROUTINE);
		break;
	}

here = machine_code;
here += sprintf(here, "%04X ", (unsigned int)pc_start);

for (cell = pc_start; cell < pc; cell++)
	*here++ = isprint(memory(cell)) ? memory(cell) : ' ';

here += sprintf(here, "%*.*s", (int)(5 - (pc - pc_start)), (int)(5 - (pc - pc_start)), "");

for (cell = pc_start; cell < pc; cell++)
	here += sprintf(here, "%02X ", memory(cell));
here += sprintf(here, "%*.*s", (int)(5 - (pc - pc_start)) * 3, (int)(5 - (pc - pc_start)) * 3, "");

while (instruction.pcount() < 15)
	instruction << " ";

instruction << ends;

char *str = instruction.str();
here += sprintf(here, "%s;", str);
delete [] str;

*location = pc;

*here = '\0';

if (operation != NULL)
	*operation = opcode;

return strnew(machine_code);
}

