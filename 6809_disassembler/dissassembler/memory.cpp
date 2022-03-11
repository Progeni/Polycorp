/*
	MEMORY.C
	--------
*/
#include <stdio.h>
#include <string.h>
#include "memory.h"

/*
	ASPT_MEMORY::ASPT_MEMORY()
	--------------------------
*/
ASPT_memory::ASPT_memory(long size)
{
memory_size = size;

memory = new unsigned char [memory_size];
memset(memory, 0, size);

memory_type = new long [memory_size];
memset(memory_type, UNKNOWN, size * sizeof(*memory_type));
}

/*
	ASPT_MEMORY::~ASPT_MEMORY()
	---------------------------
*/
ASPT_memory::~ASPT_memory()
{
delete [] memory;
delete [] memory_type;
}

/*
	ASPT_MEMORY::LOAD()
	-------------------
*/
long ASPT_memory::load(long address, long size, unsigned char *buffer)
{
if (address + size <= memory_size && address >= 0)
	{
	memcpy(memory + address, buffer, size);
	return size;
	}
return 0;
}

/*
	ASPT_MEMORY::SET_TYPE()
	-----------------------
*/
void ASPT_memory::set_type(long address, long type)
{
if (address < 0 || address > 0xFFFF)
	address = ((unsigned long)address) & 0xFFFF;		// just use the low 16 bits

memory_type[address] |= type;
}

/*
	ASPT_MEMORY::NEXT_DESTINATION()
	-------------------------------
*/
long ASPT_memory::next_destination(long after)
{
long where;

for (where = after; where < memory_size; where++)
	if ((memory_type[where] & (DESTINATION | ASSEMBLY)) == DESTINATION)
		return where;

return -1;
}

/*
	ASPT_MEMORY::DESTINATIONS()
	---------------------------
*/
long ASPT_memory::destinations(long after)
{
long where, answer = 0;

for (where = after; where < memory_size; where++)
	if (memory_type[where] & DESTINATION)
		answer++;

return answer;
}

/*
	ASPT_MEMORY::RENDER_TYPES()
	---------------------------
*/
void ASPT_memory::render_types(void)
{
long where;

for (where = 0; where < memory_size; where++)
	if ((memory_type[where] & DESTINATION) && !(memory_type[where] & ASSEMBLY))
		printf("More at:%04X\n", (unsigned int)where);
}
