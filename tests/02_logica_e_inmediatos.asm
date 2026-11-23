# Cobertura: and y or con unos en los 16 bits altos de ambos operandos;
# andi y ori con inmediato bit 15 = 1 (extension con ceros); lui con bit 15 = 1.
# Salida: resultados en hexadecimal, calculados por la CPU.

        .text
main:
        lui  $s0, 0xA5A5
        ori  $s0, $s0, 0x5A5A      # 0xA5A55A5A
        lui  $s1, 0x0F0F
        ori  $s1, $s1, 0xF0F0      # 0x0F0FF0F0
        and  $s2, $s0, $s1         # 0x05055050
        or   $s3, $s0, $s1         # 0xAFAFFAFA
        li   $s4, -1
        andi $s5, $s4, 0x8001      # 0x00008001, no sign-extend
        ori  $s6, $zero, 0x8001    # 0x00008001, no sign-extend
        lui  $s7, 0x9234           # 0x92340000

        move $a0, $s2
        jal  imprimir_hex
        move $a0, $s3
        jal  imprimir_hex
        move $a0, $s5
        jal  imprimir_hex
        move $a0, $s6
        jal  imprimir_hex
        jal  nueva_linea
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
