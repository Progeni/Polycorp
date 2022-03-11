/*
	MEMORY.H
	--------
*/
#pragma once

enum {UNKNOWN = 0, ASSEMBLY = 0x01, DESTINATION = 0x02, ROUTINE = 0x04, INTERRUPT = 0x08, INTERRUPT_VECTOR = 0x10};

/*
	class ASPT_MEMORY
	-----------------
*/
class ASPT_memory
{
private:
	long *memory_type;
	unsigned char *memory;
	long memory_size;

public:
	ASPT_memory(long size);
	virtual ~ASPT_memory();

	long load(long address, long size, unsigned char *buffer);
	unsigned char get(long address) { return memory[address]; }
	void set_type(long address, long type);
	long get_type(long address) { return memory_type[address]; }

	long next_destination(long after);
	long destinations(long after);
	void render_types(void);
} ;

