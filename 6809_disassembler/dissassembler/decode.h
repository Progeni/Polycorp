/*
	DECODE.H
	--------
*/
#pragma once

#include "memory.h"

class ASPT_memory;
class ASPT_opcode;

/*
	class ASPT_DECODE
	-----------------
*/
class ASPT_decode
{
private:
	char temp_buffer[1024];
	static ASPT_opcode opcode_none;
	ASPT_memory *cpu_memory;
	long pc;

private:
	static int opcode_cmp(const void *a, const void *b);
	ASPT_opcode *get_opcode(unsigned char val, long page = 0);
	const char *decode_register_nybble(unsigned char nybble);
	char *decode_register_stack(ASPT_opcode *opcode, unsigned char byte);
	char *decode_post_byte(ASPT_opcode *opcode, unsigned char byte);
	char *hex_width(long val, long width);
	unsigned char memory(long address, long type = ASSEMBLY);
	void set_type(long address, long type);

public:
	ASPT_decode(ASPT_memory *memory);
	virtual ~ASPT_decode();

	void dump(void);
	void dump(long end);
	char *decode(long *location, ASPT_opcode **operation = NULL);
	void jump(long location) { pc = location; }

} ;


