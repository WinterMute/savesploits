/*
	Copyright 2009 Dave Murphy (WinterMute)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
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

struct saveSlotHeader {
	uint32_t id;
	uint16_t checksum;
	uint16_t flags;
};


int main(int argc, char *argv[]) {
	int i;
	if (argc<2) {
		printf("Usage: cooksum <save file>\n");
		exit(1);
	}

	FILE *f = fopen(argv[1], "rb+");

	if (f==NULL) {
		printf("can't open file %s\n",argv[1]);
		exit(1);
	}

	uint8_t buffer[8192];
	
	fread(buffer, sizeof(buffer), 1, f);

	struct saveSlotHeader *slotHeader = (struct saveSlotHeader *)buffer;

	if ( (slotHeader->id >> 8)!= 0x56434B ) {
		printf("Not cooking coach save file!\n");
		exit(1);
	}

	int slot=0;
	unsigned short currentsum,sum,startsum;
	
	int country = slotHeader->id & 0xff;
	
	if ( country == 0x56) {
		startsum = 0xb4a9;
	} else if ( country == 0x46) {
		startsum = 0xb4b9;
	} else if ( country == 0x45) {
		startsum = 0xb4ba;
	} else if ( country == 0x53) {
		startsum = 0xb4ac;
	} else if ( country == 0x00) {
		startsum = 0xb400;
	}

	int slotOffset[] = {
		0,
		0x378,
		0xBD0,
		0xF04,
		0x1238,
		0x2000
	};

	for(slot=0;slot<5;slot++) {
		
		int offset = slotOffset[slot];
		
		slotHeader = (struct saveSlotHeader *)&buffer[offset];
		currentsum = slotHeader->checksum;
		printf("Slot %d Current checksum: %04X -- ",slot, currentsum);

		sum = startsum;
		for (i = 0; i < (slotOffset[slot+1] - (offset + 8)); i++) {
			sum -= buffer[offset + 8 + i];
		}

		if (sum != currentsum) {
			printf("Fixing checksum - %04X\n",sum);
			fseek(f, slotOffset[slot]+0x04, SEEK_SET);
			fwrite(&sum, 2, 1, f);
		} else {
			printf("SUM OK!\n");
		}
	}

	fclose(f);


	return 0;
}
