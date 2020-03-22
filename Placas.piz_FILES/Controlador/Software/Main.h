#ifndef __KOPINSOFTWARE__
#define __KOPINSOFTWARE__


/* the device's vendor and product id */
#define MY_VID 0x03EB
#define MY_PID 0x4568

/* the device's endpoints */
#define EP_OUT1 0x01
#define EP_OUT2 0x02

#define EP0_SIZE 8  //no debería ser necesario
#define EP1_SIZE 8
#define EP2_SIZE 64


// COMANDOS CPU_PC (verificar General.h en el firmware
#define APAGAR                  4
#define SETEAR_IMAGEN_0			5
#define SETEAR_IMAGEN_1			6
#define SETEAR_IMAGEN_2			7
#define SETEAR_IMAGEN_3			8
#define SETEAR_MODO_INV_FRAME	9
#define SETEAR_MODO_INV_PIXEL	10
#define SETEAR_MODO_INV_COLUMN	11
#define SETEAR_MODO_INV_ROW		12
#define CARGAR_IMAGEN			13
#define COMPROBAR_IMAGEN		14
#define MOSTRAR_IMAGEN			15

#define MAX_ROW          240
#define MAX_COLUMN       328

#define MAX_LONG_VECTOR  (MAX_ROW * MAX_COLUMN)

void MostrarAyuda(void);
usb_dev_handle* open_dev(void);
void EnviarComando(usb_dev_handle* dev, char* ComandoUSB);
void SetearImagen(usb_dev_handle* dev, char NImagen);
void BorrarBuffer(unsigned char* buffer);
void EnviarDatos(usb_dev_handle* dev, unsigned char Buffer[MAX_LONG_VECTOR], long int c);


#endif
