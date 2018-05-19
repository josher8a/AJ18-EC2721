# lab3.asm
# Mayo 2018
# Basado en el código de uso académico:
# https://gustavus.edu/mcs/max/courses/F2012/MCS-284/labs/lab2/rectangle.asm
# Programa de demostración de las capacidades gráficas del Mars
# Default display
# Width 512
# Height 256
# 4 Bytes
# Default base address: 0x10010000 (static data)
.eqv x $a0
.eqv w $a1
.eqv y $a2
.eqv h $a3
.eqv color $t0
.eqv wp $t1
.eqv eol $t2
.eqv pp $t3
.eqv ww $t4
.data

    FB: .space 0x80000  # Video Frame Buffer 512*256*4 = 524288 (se reserva el espacio del framebuffer)

.text

 
# Rutina rectangle
# Representación de un rectángulo

# Parámetros de para la rutina del rectángulo (raster graphic)
# El origen está en el vértice superior izquierdo (1,1)

  main:
    li x,106             # Posicionamiento X del cursor [1:512] (left)
    li w,300             # Recorrido horizontal [>0 && < 512] (width)
    li y,53              # Posicionamiento Y del cursor [1:256] (top edge)
    li h,170             # Recorrido vertical [>0 && <256] (height)
    jal rectangle	   # Se comienza a pintar el rectangulo

# Gracefull exit

  exit:
    li $v0,10	# Se termina el programa
    syscall

  rectangle:

    # Colores RGB (255,255,255)
    # Violeta 0x006004FF
    # Verde 0x0022CC22
    # Rojo 0x00FF0B0B
    li color,-1 # Color Blanco
    la wp,FB	# Se carga la direcci�n de donde empieza el framebuffer
    add w,w,x	# Se calcula el ultimo pixel en el eje x
    add h,h,y	# Se calcula el ultimo pixel en el eje y
    sll x,x,2	# Se obtien el valor en bytes (pixel*4) del eje x
    sll w,w,2
    sll y,y,11 	# Se obtiene el valor en bytes (512*) del eje y (salto de linea)
    sll h,h,11
    addu eol,y,wp	# Se ubica donde se empieza a dibujar en el eje y
    addu h,h,wp	# Se ubica la ultima linea que se dibuja
    addu y,eol,x	# Se traslada en el eje x para saber donde se empieza a dibujar
    addu h,h,x	# Se guarda la posicion del ultimo pixel de la figura
    addu eol,eol,w	# Se guarda la posicion del ultimo pixel de una fila
    li ww,0x800	# Bytes de una fila completa del display

  rectangleYloop:
    move pp,y	# Se guarda la posicion en la que se empieza a dibujar la fila

  rectangleXloop:
    sw color,(pp)	# Se pinta de blanco en la posicion de pp
    addiu pp,pp,4	# Se mueve un pixel
    bne pp,eol,rectangleXloop	# Se sigue pintando la fila, hasta llegar al ultimo pixel de esta

    addu y,y,ww	# Se guarda la posicion inical de la siguiente fila
    addu eol,eol,ww	# Se guarda la posicion final de la siguiente fila
    bne y,h,rectangleYloop	# Se baja de linea hasta llegar a la ultima

  rectangleReturn:
    jr $ra		# Salida del programa
