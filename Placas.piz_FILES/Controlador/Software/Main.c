#include <usb.h>
#include <stdio.h>
//#include <string.h>

#include "Main.h"


int main(int argc, char* argv[])
{
    usb_dev_handle *dev = NULL; /* the device handle */
    int   New_Buses, New_Devices;
    char   Comando;
//    char*  ComandoUSB=&Comando;
    unsigned char Buffer[MAX_LONG_VECTOR];
    
    usb_init(); // initialize the library

    New_Buses = usb_find_busses(); // find all busses
 
    New_Devices = usb_find_devices(); // find all connected devices
 
    if(!(dev = open_dev()))
    {
        printf("Error: Disposito VID = 0x%04X  PID = 0x%04X  No Encontrado\n",MY_VID,MY_PID);
        return 0;
    }
    printf("Dispositivo Encontrado\n");

    if(usb_set_configuration(dev, 1) < 0)
    {
        printf("Error: No se pudo setear la Configuracion 1\n");
        usb_close(dev);
        return 0;
    }

    if(usb_claim_interface(dev, 0) < 0)
    {
        printf("Error: Interfase 0 no pudo ser abierta\n");
        usb_close(dev);
        return 0;
    }

    if ( argc == 1) MostrarAyuda();
    else if ( (argc == 2) && (strcmp(argv[1],"-Shutdown") == 0 ) )
    {
        Comando = APAGAR;
        EnviarComando(dev, &Comando);
    }
    else if ( (argc == 3) && (strcmp(argv[1],"-SeleccionarImagen") == 0 ) )
    {
        if ( ( (*argv[2]) > '0' ) && ( (*argv[2]) < '5' ) ) SetearImagen(dev, *argv[2]);
        else MostrarAyuda();
    }
    else if ( (argc == 3) && (strcmp(argv[1],"-SetearModo") == 0 ) )
    {
        if (strcmp(argv[2],"Cuadro") == 0)
        {
            Comando = SETEAR_MODO_INV_FRAME;
            EnviarComando(dev, &Comando);
        }
        else if ( (strcmp(argv[2],"Pixel") == 0) )
        {
            Comando = SETEAR_MODO_INV_PIXEL;
            EnviarComando(dev, &Comando);
       }
        else if ( (strcmp(argv[2],"Columna") == 0) )
        {
            Comando = SETEAR_MODO_INV_COLUMN;
            EnviarComando(dev, &Comando);
        }
        else if ( (strcmp(argv[2],"Fila") == 0) )
        {
            Comando = SETEAR_MODO_INV_ROW;
            EnviarComando(dev, &Comando);
       }
        else MostrarAyuda();
    }
    else if ( (argc == 4) && (strcmp(argv[1],"-CargarImagen") == 0 ) )
    {
        if ( ( *(argv[2]) > '0') && ( *(argv[2]) < '5' ) )  //chear que imagen este entre 1 y 4
        {
            FILE* Archivo;
            if ( (Archivo = fopen(argv[3],"rb")) == NULL)
            {
                printf("Imagen NO Encontrada\n");
            }
            else
            {
                BorrarBuffer(Buffer);
                long int c;
                c = fread(Buffer,sizeof(unsigned char),MAX_LONG_VECTOR,Archivo);
                fclose(Archivo);
                int i=0;
                if ( c > MAX_LONG_VECTOR ) c = MAX_LONG_VECTOR;//chequear longitud de matriz

               
                SetearImagen(dev, *argv[2]);//Seleccionar imagen
                
                Comando = CARGAR_IMAGEN;// Comando empezar a grabar
                EnviarComando(dev, &Comando);
                
                EnviarDatos(dev, Buffer,c);// Grabar
                
                // Comando empezar a verificar
                Comando = COMPROBAR_IMAGEN;// Comando empezar a grabar
                EnviarComando(dev, &Comando);

                // Verficar ( = Grabar)
                EnviarDatos(dev, Buffer,c);// Grabar
 
                // Comando Mostrar la imagen recien cargada
                Comando = MOSTRAR_IMAGEN;// Comando empezar a grabar
                EnviarComando(dev, &Comando);
                       
               // imprimir verificacion completa, compruebe led verde...
                printf(" Verificacion Finalizada. Si el Led Rojo esta encendido hubo al menos 1 error.\n");
            }
        }
        else MostrarAyuda();
    }
    else
    {
        MostrarAyuda();
        int j;
        printf("argc = %d\n", argc);
        for (j=0 ; j<argc ; j++)
        {
            printf("%s\n", argv[j]);
        }
    }
    return 0;
}



usb_dev_handle* open_dev(void)
{
    struct usb_bus *bus;
    struct usb_device *dev;

    for(bus = usb_get_busses(); bus; bus = bus->next) 
    {
        for(dev = bus->devices; dev; dev = dev->next) 
        {
            if( (dev->descriptor.idVendor == MY_VID) && (dev->descriptor.idProduct == MY_PID) )
            {
                return usb_open(dev);
            }
        }
    }
    return NULL;
}

void EnviarComando(usb_dev_handle* dev, char* ComandoUSB)
{
//    if( usb_bulk_write(dev, EP_OUT1, ComandoUSB, sizeof(ComandoUSB), 5000) != sizeof(ComandoUSB) )
    if( usb_bulk_write(dev, EP_OUT1, ComandoUSB, 1, 5000) != 1 )
    {
        printf("Error: Falla de escritura en Endpoint 1\n");
    }
    return;
}

void EnviarDatos(usb_dev_handle* dev, unsigned char Buffer[MAX_LONG_VECTOR], long int c)
{
//    if( usb_bulk_write(dev, EP_OUT2, Buffer, sizeof(Buffer), 5000) != sizeof(Buffer) )
    if( usb_bulk_write(dev, EP_OUT2, Buffer, c, 5000) != c )
    {
        printf("Error: Falla de escritura en Endpoint 2\n");
    }
    return;
}
void SetearImagen(usb_dev_handle* dev, char NImagen)
{
    char Comando;
    if (NImagen == '1')
    {
        printf("Imagen 1\n");
        Comando = SETEAR_IMAGEN_0;
        EnviarComando(dev, &Comando);
    }
    else if (NImagen == '2')
    {
        printf("Imagen 2\n");
        Comando = SETEAR_IMAGEN_1;
        EnviarComando(dev, &Comando);
    }
    else if (NImagen == '3')
    {
        printf("Imagen 3\n");
        Comando = SETEAR_IMAGEN_2;
        EnviarComando(dev, &Comando);
    }
    else if (NImagen == '4')
    {
        printf("Imagen 4\n");
        Comando = SETEAR_IMAGEN_3;
        EnviarComando(dev, &Comando);
    }
    else printf("ESTO NO DEBERIA HABER PASADO\n");
    
}

void MostrarAyuda(void)
{
     printf("\n");
     printf("Modo de uso:\n");
     printf("             KopinSW -Comando [opciones] \n");
     printf("\n");     
     printf(" -Shutdown                  Pone al Controlador en modo de Bajo Consumo \n");
     printf("\n");     
     printf(" -SeleccionarImagen [N]     Selecciona la imagen (precargada) a mostrar\n");
     printf("                            N = { 1 , 2 , 3 , 4 }   (numero de imagen)\n");
     printf("\n");     
     printf(" -SetearModo [Modo]         Selecciona el modo de inversion en el microdisplay\n");
     printf("                            Modo = { Pixel , Cuadro , Columna , Fila }\n");
     printf("\n");     
     printf(" -CargarImagen [N] [Imagen] Cargar Imagenn la posicion N\n");
     printf("                            N = { 1 , 2 , 3 , 4 } (numero de imagen a escribir)\n");
     printf("                            Imagen = Vector de (240 x 328) datos de 8 bits\n");
     printf(" ------- \n");     
     return;
}


void BorrarBuffer(unsigned char* buffer)
{
     int i;
     for (i=0 ; i < MAX_LONG_VECTOR ; i++) buffer[i] = 0;
}
