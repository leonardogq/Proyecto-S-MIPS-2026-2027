# Cobertura: sll y srl con shamt = 0 y shamt != 0; srl de un valor negativo
# para comprobar que introduce ceros por la izquierda.
# Salida: resultados en hexadecimal, calculados por la CPU.

        .text
main:
        lui  $s0, 0x8000
        ori  $s0, $s0, 0x0001      # 0x80000001 (negativo con signo)
        sll  $s1, $s0, 0           # desplazamiento cero
        sll  $s2, $s0, 1           # desplazamiento izquierdo
        srl  $s3, $s0, 0           # desplazamiento cero
        srl  $s4, $s0, 1           # logico: resultado 0x40000000

        move $a0, $s1
        jal  imprimir_hex
        move $a0, $s2
        jal  imprimir_hex
        move $a0, $s3
        jal  imprimir_hex
        move $a0, $s4
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
