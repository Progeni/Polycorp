/*
	MAIN.C
	------
*/
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "memory.h"
#include "decode.h"
#include "opcode.h"

/*
	On the following opcodes flow is guaranteed to finish so its 
	time to restart dissassembling from a new location

	RTS(0x39) RTI(0x3B) JMP(0x0E 0x6E 0x7E) BRA(0x20) LBRA(0x16)
*/
unsigned char end_of_flow[] = {0x39, 0x3B, 0x0E, 0x6E, 0x7E, 0x20, 0x16};

/*
	6809 Interrupts Meaning		Value on Poly
	FFFE FFFF		RESET		F04B
	FFFC FFFD		NMI			FA48
	FFFA FFFB		SWI			F1D9
	FFF8 FFF9		IRQ			F8BA
	FFF6 FFF7		FIRQ		FA48
	FFF4 FFF5		SWI2		FAC2
	FFF2 FFF3		SWI3		FAC2
	FFF0 FFF1		Reserved	00E9
*/

typedef struct
{
long location;
const char *name;
} ASPT_fact;

ASPT_fact interrupts[] = {
	{0xFFFE, "Reset"},
	{0xFFFC, "NMI"},
	{0xFFFA, "SWI"},
	{0xFFF8, "IRQ"},
	{0xFFF6, "FIRQ"},
	{0xFFF4, "SWI2"},
	{0xFFF2, "SWI3"},
	{0x0000, ""}
	} ;

/*
	READ_ENTIRE_FILE()
	------------------
*/
unsigned char *read_entire_file(const char *filename, long *size = NULL)
{
FILE *fp;
struct stat ans;
unsigned char *buffer;
long got;

if (stat(filename, &ans) != 0)
	return NULL;

if ((fp = fopen(filename, "rb")) == NULL)
	return NULL;

buffer = new unsigned char [ans.st_size];

got = fread(buffer, ans.st_size, 1, fp);
fclose(fp);

if (got != 1)
	{
	delete [] buffer;
	return NULL;
	}
if (size != NULL)
	*size = ans.st_size;
return buffer;
}

/*
	LOAD_FILE()
	-----------
*/
int load_file(ASPT_memory *memory, const char *filename, long address)
{
unsigned char *buffer;
long size;

if ((buffer = read_entire_file(filename, &size)) == NULL)
	exit(printf("Can't read file:%s\n", filename));
memory->load(address, size, buffer);
delete [] buffer;

return 1;
}

/*
	MAIN()
	------
*/
int main(int argc, char *argv[])
{
ASPT_fact *known;
ASPT_memory *cpu_memory;
ASPT_decode *cpu;
ASPT_opcode *opcode;
char *assembly, *ignore;
long location, destinations, new_destinations;
long from_address, parameter;

//exit(printf("Usage:%s [<address> ... <address>]\n", argv[0]));

cpu_memory = new ASPT_memory(0x10000);

if (argc >= 4 && strcmp(argv[1], "-b") == 0)			// this is -b <filename> <HexAddress> <HexAddress>...
	{
	load_file(cpu_memory, argv[2], 0x0000);

	cpu = new ASPT_decode(cpu_memory);
	new_destinations = destinations = 0;

	for (parameter = 3; parameter < argc; parameter++)
		{
		from_address = strtol(argv[parameter], &ignore, 16);
		cpu_memory->set_type(from_address, ROUTINE | DESTINATION);
		}
	}
else if (argc >= 4 && strcmp(argv[1], "-f") == 0)			// this is -f <filename> <HexAddress(LoadAddress)> <HexAddress>...
	{
	from_address = strtol(argv[3], &ignore, 16);
	load_file(cpu_memory, argv[2], from_address);

	cpu = new ASPT_decode(cpu_memory);
	new_destinations = destinations = 0;

	for (parameter = 3; parameter < argc; parameter++)
		{
		from_address = strtol(argv[parameter], &ignore, 16);
		cpu_memory->set_type(from_address, ROUTINE | DESTINATION);
		}
	}
else if (argc >= 2 && strcmp(argv[1], "-p") == 0)		// Proteus ROM mode
	{
	printf("Proteus ROMS\n");
	load_file(cpu_memory, argv[2], 0xF000);

	cpu = new ASPT_decode(cpu_memory);
	new_destinations = destinations = 0;

	if (argc >= 4)
		{
		/*
			Mark the given addresses as the entry point
		*/
		for (parameter = 2; parameter < argc; parameter++)
			{
			from_address = strtol(argv[parameter], &ignore, 16);
			cpu_memory->set_type(from_address, ROUTINE | DESTINATION);
			}
		}
	else
		{	
		/*
			Mark the interrups and where they point as entry points into the code
		*/
		for (known = interrupts; known->location != 0; known++)
			{
			cpu_memory->set_type(known->location, INTERRUPT_VECTOR);

			location = (cpu_memory->get(known->location) << 8) + cpu_memory->get(known->location + 1);
			cpu_memory->set_type(location, DESTINATION | INTERRUPT);
			}
		}
	}
else if (argc >= 3 && strcmp(argv[1], "-B") == 0)			// BASIC mode (the given file is extended Polybasic)
	{
	load_file(cpu_memory, argv[2], 0x0000);
	load_file(cpu_memory, "../../roms/translated/diskpoly/v2bas1.bin.out", 0xA000);
	load_file(cpu_memory, "../../roms/translated/diskpoly/v2bas2.bin.out", 0xB000);
	load_file(cpu_memory, "../../roms/translated/diskpoly/v2bas3.bin.out", 0xE000);
	load_file(cpu_memory, "../../roms/translated/diskpoly/v2bas4.bin.out", 0xF000);

	cpu = new ASPT_decode(cpu_memory);
	new_destinations = destinations = 0;

	for (parameter = 3; parameter < argc; parameter++)
		{
		from_address = strtol(argv[parameter], &ignore, 16);
		cpu_memory->set_type(from_address, ROUTINE | DESTINATION);
		}
	}
else			// Poly ROM BIOS mode
	{
	puts("Poly BIOS");
	load_file(cpu_memory, argv[1], 0xF000);

	cpu = new ASPT_decode(cpu_memory);
	new_destinations = destinations = 0;

	if (argc >= 3)
		{
		/*
			Mark the given addresses as the entry point
		*/
		for (parameter = 2; parameter < argc; parameter++)
			{
			from_address = strtol(argv[parameter], &ignore, 16);
			cpu_memory->set_type(from_address, ROUTINE | DESTINATION);
			}
		}
	else
		{	
		/*
			Mark the interrups and where they point as entry points into the code
		*/
		for (known = interrupts; known->location != 0; known++)
			{
			cpu_memory->set_type(known->location, INTERRUPT_VECTOR);

			location = (cpu_memory->get(known->location) << 8) + cpu_memory->get(known->location + 1);
			cpu_memory->set_type(location, DESTINATION | INTERRUPT);
			}
		}
	}

/*
	Trace as much code a possible
*/
do
	{
	destinations = new_destinations;
	location = cpu_memory->next_destination(0x0000);
	while (location != -1)
		{
		cpu->jump(location);
		do
			{
			assembly = cpu->decode(&location, &opcode);
			delete [] assembly;
			}
		while (memchr(end_of_flow, opcode->val, sizeof(end_of_flow)) == NULL);
		location = cpu_memory->next_destination(location);
printf("%x\n", (unsigned int)location);
	  	}
	new_destinations = cpu_memory->destinations(0x0000);
printf("%x\n", (unsigned int)new_destinations);
	}
while (destinations != new_destinations);

/*
	Now print the code in a human readable format
*/
long start, end;
long type;

start = end = location = 0x0000;
cpu->jump(location);
do
	{
	start = end;
	cpu->jump(start);
	type = cpu_memory->get_type(start);
	if (type & DESTINATION)
		puts("->");
	if (type & ROUTINE)
		puts("Routine:");
	if (type & INTERRUPT)
		{
		printf("Interrupt Vector:");
		for (known = interrupts; known->location != 0; known++)
			{
			location = (cpu_memory->get(known->location) << 8) + cpu_memory->get(known->location + 1);
			if (location == start)
				printf("%s ", known->name);
			}
		printf("\n");
		}

	if (type & INTERRUPT_VECTOR)
		{
		for (known = interrupts; known->location != 0; known++)
			if (known->location == start)
				printf("->\n%04X %02X %02X ; %s\n", (unsigned int)start, cpu_memory->get(start), cpu_memory->get(start + 1), known->name);
		end = start + 2;
		}
	else if (type & ASSEMBLY)
		{
		assembly = cpu->decode(&end, &opcode);
		puts(assembly);
		delete [] assembly;
		}
	else		// must be data
		{
		puts("->");
		end = start;
		while ((cpu_memory->get_type(end) & (ASSEMBLY | INTERRUPT | INTERRUPT_VECTOR)) == 0)
			end++;
		cpu->dump(end);
		}
	while (++start < end)
		if (cpu_memory->get_type(start) & (ROUTINE | DESTINATION | INTERRUPT))
			puts("*** erronious entry point above ***");
	}
while (start <= 0xFFFF);

return 0;
}
