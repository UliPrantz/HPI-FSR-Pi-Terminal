#include "pn532.h"
#include "stdint.h"

int8_t initPN532(PN532 *pn532);
int32_t getUid(PN532 *pn532, uint8_t data[MIFARE_UID_MAX_LENGTH]);

