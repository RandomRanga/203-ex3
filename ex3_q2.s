.global  main 
.text 
main: 
    add $9, $0, $0          # init register 9 to store input. 



readserialport:
    lw $11, 0x70003($0)     # Get the first serial port status
    andi $11, $11, 0x1      # Check if the RDR bit is set
    beqz $11, check         # If not, loop and try again
    lw $9, 0x70001($0)      # Puts the serial port into $9

checkinput
