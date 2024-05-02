.global main
.text
main:  
    add $9, $0, $0          # init register 9 to store input.

readserialport:
    lw $11, 0x70003($0)     # Get the first serial port status
    andi $11, $11, 0x1      # Check if the RDR bit is set
    beqz $11, readserialport         # If not, loop and try again
    lw $9, 0x70001($0)      # Puts the serial port into $9

checkinput:
    slti $3, $9, 'a'        # Check if the character is less than 'a'
    sgti $4, $9, 'z'        # Check if the character is more than 'z'
    or $3, $3, $4           # Or the 2 outputs to see if it is outof the range
    bnez $3, replaceletter  # If not in the range, replace the character

    sw $9, 0x70000($0)      # Write character to serial port 1
    j readserialport        # Jump back to wait and read next character


replaceletter:
    addi $10, $0, '*'       # Load ascii value of '*'
    sw $10, 0x70000($0)     # Write '*' to serial port 1
    j readserialport        # Jump back to wait and read next character