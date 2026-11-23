# Cobertura: jal y jr mediante procedimiento no hoja; el procedimiento guarda $ra
# en la pila antes de llamar a otro procedimiento y lo restaura para retornar;
# syscall 11 imprime un caracter y syscall 10 termina.
# Salida calculada: resultado del procedimiento y caracter 'A'.

        .text
main:
        addi $a0, $zero, 5
        jal  externo
        move $s0, $v0             # el resultado esperado es 10
        move $a0, $s0
        jal  imprimir_hex
        jal  nueva_linea

        addi $a0, $zero, 65       # 'A'
        addi $v0, $zero, 11
        syscall
        jal  nueva_linea

        addi $v0, $zero, 10
        syscall

# Procedimiento no hoja: llama a interno y, por ello, salva su propio $ra.
externo:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)
        jal  interno
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra

# Procedimiento hoja: devuelve 2 * argumento en $v0.
interno:
        add  $v0, $a0, $a0
        jr   $ra

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
