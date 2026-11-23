# Cobertura: add y sub con operandos positivos y negativos; addi con inmediato
# negativo; addu mediante move; addiu mediante li (constante signed-16); escritura
# en $zero seguida de lectura; nop (0x00000000) legal y sin efecto.
# Salida: resultados en hexadecimal, calculados por la CPU.

        .text
main:
        addi $s0, $zero, 19
        addi $s1, $zero, 7
        add  $s2, $s0, $s1          # 26
        sub  $s3, $s0, $s1          # 12
        addi $s4, $zero, -9
        add  $s5, $s0, $s4          # 10: add con operando negativo
        sub  $s6, $s4, $s1          # -16: sub con operando negativo
        li   $s7, 1234              # MARS traduce a addiu
        move $t7, $s7               # MARS traduce a addu
        add  $zero, $s0, $s1        # intento de escritura en $zero
        nop
        add  $v1, $zero, $zero      # debe seguir siendo 0

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
        move $a0, $t7
        jal  imprimir_hex
        move $a0, $v1
        jal  imprimir_hex
        jal  nueva_linea

        addi $v0, $zero, 10
        syscall

# Imprime $a0 como ocho digitos hexadecimales y un espacio.
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
