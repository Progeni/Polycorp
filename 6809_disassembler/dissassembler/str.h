/*
	STR.H
	-----
*/
#pragma once

#include <string.h>

/*
	STRNEW()
	--------
*/
inline char *strnew(char *string)
{
return strcpy(new char [strlen(string) + 1], string);
}
