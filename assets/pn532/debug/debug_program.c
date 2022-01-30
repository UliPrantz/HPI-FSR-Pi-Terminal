#include <stdio.h>
#include <stdint.h>

#include "../src/pn532.h"
#include "../src/rfid_reader.h"

int main() {
    PN532 pn532;
    uint8_t data[MIFARE_UID_MAX_LENGTH];

    initPN532(&pn532);

    while (1) {
        int32_t uid_len = getUid(&pn532, data);

        if (uid_len > 0) {
            printf("\n0x");
            for (uint8_t i = 0; i < uid_len; i++)
                printf("%02x ", data[i]);
            printf("\n");
        }
    }
}