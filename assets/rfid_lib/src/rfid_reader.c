#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include "pn532.h"
#include "pn532_rpi.h"


// init the pn532
//
// @ return 0 for success and -1 for failure
int8_t initPN532(PN532 *pn532) {
    uint8_t buff[255];
    PN532_I2C_Init(pn532);

    if (PN532_GetFirmwareVersion(pn532, buff) == PN532_STATUS_OK) {
        //printf("Found PN532 with firmware version: %d.%d\r\n", buff[1], buff[2]);
    } else {
        return -1;
    }
    PN532_SamConfiguration(pn532);

    return 0;
}

// the function returns the length of data written into the data array
// the data array is defined as follow
// uint8_t data[MIFARE_UID_MAX_LENGTH]; with MIFARE_UID_MAX_LENGTH = (int) 10
//
// @ return -1 for failure or the length of data
int32_t getUid(PN532 *pn532, uint8_t data[MIFARE_UID_MAX_LENGTH]) {
    return PN532_ReadPassiveTarget(pn532, data, PN532_MIFARE_ISO14443A, 1000);
}


// example main to see how these functions are called!
// int main() {
//     PN532 pn532;
//     uint8_t data[MIFARE_UID_MAX_LENGTH];

//     initPN532(&pn532);

//     while (1) {
//         int32_t uid_len = getUid(&pn532, data);

//         if (uid_len > 0) {
//             printf("\n0x");
//             for (uint8_t i = 0; i < uid_len; i++)
//                 printf("%02x ", data[i]);
//             printf("\n");
//             break;
//         }
//     }
// }