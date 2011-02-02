/*
	Copyright 2009 Dave Murphy (WinterMute)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

// TODO
// make endian safe, assumes little endian
// add checksums for other regions

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

struct saveSlot {
	uint32_t id;
	uint16_t checksum;
	uint16_t flags;
	uint8_t data[0xf30];
};

int main(int argc, char *argv[]) {
	int i;
	struct saveSlot buffer[2];

	if (argc<2) {
		printf("Usage: cwgsum <input save file>\n");
		exit(1);
	}


	FILE *inputsave = fopen(argv[1],"rb+");

	if (inputsave==NULL) {
		printf("can't open file %s\n",argv[2]);
		exit(1);
	}
	
	fread(buffer, sizeof(buffer), 1, inputsave);

	if ( buffer[0].id != 0x800354 && buffer[0].id != 0x400810 && buffer[0].id != 0x800355) {
		printf("Not classic word games save file!\n");
		fclose(inputsave);
		exit(1);
	}

	uint16_t startsum;
	
	if (buffer[0].id == 0x800354) startsum = 0xfcab;
	if (buffer[0].id == 0x800355) startsum = 0xfcaa;
	if (buffer[0].id == 0x400810) startsum = 0xf7ef;
	
	int slot;
	uint16_t currentsum,sum;

	for(slot=0;slot<2;slot++) {		
		currentsum = buffer[slot].checksum;

		sum=startsum;
		uint8_t *b = buffer[slot].data;

		for (i = 0; i < sizeof(buffer[0].data); i++) {
			sum -= b[i];
		}
	
		if (sum != currentsum) {
			printf("Fixing checksum - %04X\n",sum);
			buffer[slot].checksum = sum;
			fseek(inputsave,sizeof(buffer[0])*slot+4,SEEK_SET);
			fwrite(&sum,2,1,inputsave);
		} else {
			printf("SUM OK!\n");
		}
	}

	fclose(inputsave);

	return 0;
}
