CPP  = g++.exe
CC   = gcc.exe
OBJ  = Main.o 
LINKOBJ  = Main.o 
BIN  = KopinSW.exe
RM = rm -f

all: clean $(BIN)

clean:
	${RM} $(OBJ) $(BIN)

Main.o: Main.c Main.h
	$(CC) -c Main.c -o Main.o
$(BIN): $(OBJ)
	$(CC) $(LINKOBJ) -o "KopinSW.exe" $(LIBS)

