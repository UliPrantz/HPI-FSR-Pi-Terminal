#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>

typedef struct _PN532 {
    int (*reset)(void);
    int (*read_data)(uint8_t* data, uint16_t count);
    int (*write_data)(uint8_t *data, uint16_t count);
    bool (*wait_ready)(uint32_t timeout);
    int (*wakeup)(void);
    void (*log)(const char* log);
} PN532;

int8_t initPN532(PN532 *pn532) {
    return 0;
}

// the function returns the length of data written into the data array
// the data array is defined as follow
// uint8_t data[MIFARE_UID_MAX_LENGTH]; with MIFARE_UID_MAX_LENGTH = (int) 10
//
// @ return -1 for failure or the length of data
int32_t getUid(PN532 *pn532, uint8_t data[10]) {
    for (int i=0; i < 10; i++) {
        data[i] = 0x4c;
    }

    sleep(15);

    return 10;
}


int main() {
    initPN532(NULL); //
    uint8_t data[10];
    getUid(NULL, data);

    for (int i=0; i < 10; i++) {
        printf("%d, ", data[i]);
    }
}