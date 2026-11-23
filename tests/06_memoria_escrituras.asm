# Cobertura: sw con desplazamiento positivo (palabra 1) y con desplazamiento negativo
# (palabra 0, con otro valor, comprobada con lw de desplazamiento cero); sb en los
# cuatro carriles de una misma palabra; comprobacion posterior con lw de que los
# otros bytes no cambian; sb guarda solamente R[rt][7:0].
# Salida: palabras leidas despues de cada escritura, en hexadecimal.

        .data
        .align 2
area:
        .word 0x00000000
        .word 0x00000000
        .word 0x11223344
        .word 0x00000000

        .text
main:
        la   $s0, area
        lui  $s1, 0x5566
        ori  $s1, $s1, 0x7788
        sw   $s1, 4($s0)           # desplazamiento positivo: palabra 1
        addi $s2, $s0, 8
        lui  $t0, 0x99AA
        ori  $t0, $t0, 0xBBCC
        sw   $t0, -8($s2)          # desplazamiento negativo: palabra 0 (otro valor)
        lw   $s3, 4($s0)           # 0x55667788
        lw   $s4, 0($s0)           # 0x99AABBCC: solo si el sw negativo fue a su sitio

        # Las cuatro escrituras siguientes modifican la misma palabra.
        addi $t0, $zero, 0x00AA
        sb   $t0, 8($s0)           # carril 0
        lw   $s5, 8($s0)           # 0x112233AA
        addi $t0, $zero, 0x00BB
        sb   $t0, 9($s0)           # carril 1
        lw   $s6, 8($s0)           # 0x1122BBAA
        addi $t0, $zero, 0x00CC
        sb   $t0, 10($s0)          # carril 2
        lw   $s7, 8($s0)           # 0x11CCBBAA
        addi $t0, $zero, 0x00DD
        sb   $t0, 11($s0)          # carril 3
        lw   $t5, 8($s0)           # 0xDDCCBBAA

        addi $t0, $zero, 0x1234
        sb   $t0, 8($s0)           # solo debe almacenarse 0x34
        lw   $t6, 8($s0)           # 0xDDCCBB34

        move $a0, $s3
        jal  imprimir_hex
        move $a0, $s4
        jal  imprimir_hex
        move $a0, $s5
        jal  imprimir_hex
        move $a0, $s6
        jal  imprimir_hex
        jal  nueva_linea
        move $a0, $s7
        jal  imprimir_hex
        move $a0, $t5
        jal  imprimir_hex
        move $a0, $t6
        jal  imprimir_hex
        jal  nueva_linea

        addi $v0, $zero, 10
        syscall

imprimir_hex:
        add  $t1, $a0, $zero
        addi $t2, $zero, 8
ih_bucle:
        srl  $t3, $t1, 28
        slti $t4, $t3, 10
        beq  $t4, $zero, ih_letra
        addi $a0, $t3, 48
        j    ih_emitir
ih_letra:
        addi $a0, $t3, 87
ih_emitir:
        addi $v0, $zero, 11
        syscall
        sll  $t1, $t1, 4
        addi $t2, $t2, -1
        bne  $t2, $zero, ih_bucle
        addi $a0, $zero, 32
        addi $v0, $zero, 11
        syscall
        jr   $ra

nueva_linea:
        addi $a0, $zero, 10
        addi $v0, $zero, 11
        syscall
        jr   $ra
