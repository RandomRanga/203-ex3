.global main
.text
main:
        
        addi $3, $0, 'a' # Lowercase ascii value one before a
        addi $4, $0, 'A' # Uppercase ascii value one before A
     

lowercaseloop:
        
        sgti $13, $3, 'z'           # Checks to see if the lower case alphabet has finished. 
        bnez $13, uppercaseloop     # If we've reached the end of the lowercase alphabet, jump to uppercase
        

lowercasecheck:
        lw $12, 0x71003($0)         # Get the Serial Status Register value
        andi  $12, $12, 0x2         # Check if the Transmit Data Sent bit is set to 1
        beqz $12, lowercasecheck    # If it is not, check again until it is

        sw $3, 0x71000($0)          # Put the character into the serial transmit data register
        addi $3, $3, 0x1            # adds 1 to the lowercase acsii value 
        j lowercaseloop             # jumps back up to the start of lowercaseloop

uppercaseloop:
        sgti $5, $4, 'Z'            # checks to see if the alphabet has finsihed 
        bnez $5, endloop            # if reached the end of uppercase alphabet, finish
        
uppercasecheck: 
        lw $8, 0x71003($0)          # Get the Serial Status Register value
        andi  $8, $8, 0x2           # Check if the Transmit Data Sent bit is set to 1
        beqz $8, uppercasecheck     # If it is not, check again until it is

        sw $4, 0x71000($0)          # Put the character into the serial transmit data register
        addi $4, $4, 0x1            # adds 1 to the uppercase acsii value
        j uppercaseloop             # jumps back to uppercase loop

        

endloop:                            
        jr $ra                      #jumps and returns the back to the return address

