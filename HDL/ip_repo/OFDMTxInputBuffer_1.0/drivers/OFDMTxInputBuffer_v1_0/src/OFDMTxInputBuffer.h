
#ifndef OFDMTXINPUTBUFFER_H
#define OFDMTXINPUTBUFFER_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"


/**************************** Type Definitions *****************************/
/**
 *
 * Write/Read 32 bit value to/from OFDMTXINPUTBUFFER user logic memory (BRAM).
 *
 * @param   Address is the memory address of the OFDMTXINPUTBUFFER device.
 * @param   Data is the value written to user logic memory.
 *
 * @return  The data from the user logic memory.
 *
 * @note
 * C-style signature:
 * 	void OFDMTXINPUTBUFFER_mWriteMemory(u32 Address, u32 Data)
 * 	u32 OFDMTXINPUTBUFFER_mReadMemory(u32 Address)
 *
 */
#define OFDMTXINPUTBUFFER_mWriteMemory(Address, Data) \
    Xil_Out32(Address, (u32)(Data))
#define OFDMTXINPUTBUFFER_mReadMemory(Address) \
    Xil_In32(Address)

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the OFDMTXINPUTBUFFERinstance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus OFDMTXINPUTBUFFER_Mem_SelfTest(void * baseaddr_p);

#endif // OFDMTXINPUTBUFFER_H
