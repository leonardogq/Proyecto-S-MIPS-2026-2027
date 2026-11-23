# Cobertura: lw con desplazamiento positivo y negativo; lb y lbu sobre bytes
# con bit 7 = 1 en dos carriles distintos (d[1:0] = 2 y 3); little-endian.
# Salida: palabras y bytes extendidos en hexadecimal.

        .data
        .align 2
palabras:
        .word 0x80FF7F01
        .word 0xA5B6C7D8
        .word 0x12345678

        .text
main:
        la   $s0, palabras
        lw   $s1, 4($s0)           # offset positivo: 0xA5B6C7D8
        addi $s2, $s0, 8
        lw   $s3, -4($s2)          # offset negativo: misma segunda palabra

        lb   $s4, 2($s0)           # byte FF -> FFFFFFFF
        lbu  $s5, 2($s0)           # byte FF -> 000000FF
        lb   $s6, 3($s0)           # byte 80 -> FFFFFF80
        lbu  $s7, 3($s0)           # byte 80 -> 00000080

        move $a0, $s1
        jal  imprimir_hex
        move $a0, $s3
        jal  imprimir_hex
        move $a0, $s4
        jal  imprimir_hex
        move $a0, $s5
        jal  imprimir_hex
        jal  nueva_linea
        move $a0, $s6
        jal  imprimir_hex
        move $a0, $s7
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
