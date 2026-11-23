# Cobertura: beq y bne tomados y no tomados; bne tomado hacia atras en un bucle;
# j ejecutado; cada camino incorrecto altera el acumulador que se imprime.
# Salida: acumulador final y contador de iteraciones, en hexadecimal.

        .text
main:
        addi $s0, $zero, 0
        addi $t0, $zero, 5
        addi $t1, $zero, 5

        beq  $t0, $t1, beq_tomado
        addi $s0, $s0, 0x100       # no debe ejecutarse
beq_tomado:
        addi $s0, $s0, 1

        bne  $t0, $t1, bne_falso
        addi $s0, $s0, 2          # se ejecuta: bne no tomado
bne_falso:
        addi $t1, $zero, 6
        bne  $t0, $t1, bne_tomado
        addi $s0, $s0, 0x200      # no debe ejecutarse
bne_tomado:
        addi $s0, $s0, 4

        beq  $t0, $t1, beq_falso
        addi $s0, $s0, 8          # se ejecuta: beq no tomado
beq_falso:

        # Bucle con BNE tomado hacia atras y no tomado al terminar.
        addi $t2, $zero, 3
        add  $s1, $zero, $zero
bucle:
        addi $s1, $s1, 1
        addi $t2, $t2, -1
        bne  $t2, $zero, bucle

        # J debe saltar sobre una instruccion que alteraria el acumulador.
        j    despues_j
        addi $s0, $s0, 0x400      # no debe ejecutarse
despues_j:
        addi $s0, $s0, 16

        move $a0, $s0
        jal  imprimir_hex
        move $a0, $s1
        jal  imprimir_hex
        jal  nueva_linea

        addi $v0, $zero, 10
        syscall

imprimir_hex:
        add  $t3, $a0, $zero
        addi $t4, $zero, 8
ih_bucle:
        srl  $t5, $t3, 28
        slti $t6, $t5, 10
        beq  $t6, $zero, ih_letra
        addi $a0, $t5, 48
        j    ih_emitir
ih_letra:
        addi $a0, $t5, 87
ih_emitir:
        addi $v0, $zero, 11
        syscall
        sll  $t3, $t3, 4
        addi $t4, $t4, -1
        bne  $t4, $zero, ih_bucle
        addi $a0, $zero, 32
        addi $v0, $zero, 11
        syscall
        jr   $ra

nueva_linea:
        addi $a0, $zero, 10
        addi $v0, $zero, 11
        syscall
        jr   $ra
