# Cobertura: slt y slti con resultado 1 y 0; caso negativo donde la comparacion
# con signo difiere de la comparacion sin signo; inmediato negativo en slti.
# Salida: resultados booleanos extendidos a 32 bits, en hexadecimal.

        .text
main:
        addi $s0, $zero, -7
        addi $s1, $zero, 3
        slt  $s2, $s0, $s1         # 1: -7 < 3 con signo
        slt  $s3, $s1, $s0         # 0: 3 no es menor que -7
        slti $s4, $s0, -6          # 1: -7 < -6
        slti $s5, $s1, -1          # 0: 3 no es menor que -1

        move $a0, $s2
        jal  imprimir_hex
        move $a0, $s3
        jal  imprimir_hex
        move $a0, $s4
        jal  imprimir_hex
        move $a0, $s5
        jal  imprimir_hex
        jal  nueva_linea

        addi $v0, $zero, 10
        syscall

imprimir_hex:
        add  $t0, $a0, $zero
        addi $t1, $zero, 8
ih_bucle:
        srl  $t2, $t0, 28
        slti $t3, $t2, 10
        beq  $t3, $zero, ih_letra
        addi $a0, $t2, 48
        j    ih_emitir
ih_letra:
        addi $a0, $t2, 87
ih_emitir:
        addi $v0, $zero, 11
        syscall
        sll  $t0, $t0, 4
        addi $t1, $t1, -1
        bne  $t1, $zero, ih_bucle
        addi $a0, $zero, 32
        addi $v0, $zero, 11
        syscall
        jr   $ra

nueva_linea:
        addi $a0, $zero, 10
        addi $v0, $zero, 11
        syscall
        jr   $ra
