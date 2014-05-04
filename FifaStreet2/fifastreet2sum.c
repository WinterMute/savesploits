#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>


uint16_t checksum(unsigned char *buffer, int length) {

	uint16_t sum = 13;
	
	do {

		if (length<4) {

			sum += (*(buffer++) * length);
			length--;

		} else {

			sum += (*(buffer++) * length);
			sum += (*(buffer++) * length);
			sum += (*(buffer++) * length);
			sum += (*(buffer++) * length);
			
			length -= 4;
		}		
	} while (length > 0 );
	return sum;
}

unsigned char *loadFile(char *name, int *bufferSize) {
	FILE * f;
	long size;
	unsigned char * buffer;

	f=fopen(name , "rb" );
	if(!f)return NULL;

	fseek (f , 0 , SEEK_END);
	size = ftell (f);
	rewind (f);
	if(bufferSize)*bufferSize=size;

	buffer=(unsigned char*)malloc(sizeof(char)*size);
	fread(buffer,1,size,f);
	fclose(f);
	return buffer;
}

void saveFile(const char filename[], unsigned char* buffer, long size)
{
	FILE * f;

	f=fopen(filename , "wb+" );
	if(!f)return;

	fwrite(buffer,1,size,f);

	fclose(f);
}

int main(int argc, char* argv[]) {

	if (argc < 2) {
		printf("Usage: %s savefile",argv[0]);
		exit(1);
	}

	int size;
	
	unsigned char *buffer = loadFile(argv[1],&size);

	if (buffer == NULL) {
		printf ("failed to load %s.\n",argv[1]);
		exit(1);
	}
	
	
	int oldsum = (buffer[11] << 8) + buffer[10];
	int newsum = checksum(&buffer[0x34],0xfa0);
	
	printf("current checksum = %04x\ncalculated checksum = %04x\n", oldsum,newsum);

	buffer[10] = newsum & 0xff;
	buffer[11] = (newsum >> 8 ) & 0xff;

	saveFile(argv[1],buffer,size);
	
	free(buffer); 
	return 0;
}

