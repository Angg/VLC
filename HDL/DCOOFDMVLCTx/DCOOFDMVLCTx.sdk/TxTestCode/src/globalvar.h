/*
 * globalvar.h
 *
 *  Created on: Jan 10, 2018
 *      Author: AnggaPP
 */

#ifndef SRC_GLOBALVAR_H_
#define SRC_GLOBALVAR_H_

#define PACKET_LENGTH 400
#define PORT_NUM		7

unsigned int *TcpPacket;

struct pbuf *p_pbuf;
struct tcp_pcb *pcb;

#endif /* SRC_GLOBALVAR_H_ */
