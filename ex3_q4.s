.global main
.text
main: 
    sw $ra, 0($sp)      #Store return adress in stack 
    subui $sp, $sp, 1   # decrement stack pointer

    loop: 
        jal serial_job      #Call q2 serial job
        jal parallel_job    #call q3 parallel job
        j loop              #jumps back to top of the loop to repeat
    
    exit: 
        addui $sp, $sp, 1   #increment stack pointer to find return adress 
        lw $ra, 0($sp)      #restore return address 
    
    return:
        jr $ra              #return and exit the program

    
    
    serial_job:  
        add $10, $0, $0          # init register 9 to store input. DONT THINK I NEED 
       
        readserialport:
            lw $11, 0x70003($0)     # Get the first serial port status
            andi $11, $11, 0x1      # Check if the RDR bit is set
            beqz $11, returnserial         # If not, loop out and check parallel
            lw $10, 0x70001($0)      # Puts the serial port into $9

        checkinput:
            slti $13, $10, 'a'        # Check if the character is less than 'a'
            sgti $14, $10, 'z'        # Check if the character is more than 'z'
            or $13, $13, $14           # Or the 2 outputs to see if it is outof the range
            bnez $13, replaceletter  # If not in the range, replace the character

            sw $10, 0x70000($0)      # Write character to serial port 1
            j readserialport        # Jump back to wait and read next character


        replaceletter:
            addi $12, $0, '*'       # Load ascii value of '*'
            sw $12, 0x70000($0)     # Write '*' to serial port 1
            j readserialport        # Jump back to wait and read next character

        returnserial: 
            jr $ra      #returns out of serial job



    parallel_job:         
        add $2, $0, $0      # init $2 stores which button was pressed 
        add $3, $0, $0      # init $3 used to check which button 
        add $4, $0, $0      # init $4 stores the switches 
        addi $5, $0, 4      # init $5 used to loop through SSD

        buttonpress:
            lw $2, 0x73001($0)                  # has a button been pressed stores it in $2
            beqz $2, returnparallel                     # if not keep return to check for serial job

            sw $2, 0x73001($0)                  # stores the button was pressed
            
            lw $4, 0x73000($0)                  # reads the swichs and stores them in $4

                            #check which button was pressed 
            seqi $3, $2, 2                      #checks if the middle button was pressed 
            bnez $3, invertswitches             #if it was branches to invert switches

            #could make it if the right and middle button pressed check for multiple of 4 when inverted. 

            seqi $7, $2, 4                      # checks if the left button was pressed
            bnez $7, exitbutton                       # if it was branches to exit

            #coud make it if the left and middle button pressed then exit as well. 

                            #If anything else is pressed (combination) then does the same as if the right button was pressed
        
        multiplecheck: 
            remi $6, $4, 4              # stores the remainder when divided by 4 
            bnez $6, LEDoff             # if there is a remainder brakes to ledoff 

            addi $6, $0, 0xFFFF         # makes all bits on 
            sw $6, 0x7300A($0)          # turns on all the LEDs
            j printswitches             # jumps to print the switches 


        LEDoff:
            sw $0, 0x7300A($0)          #resets all the LEDs to off

        printswitches: 
            sw $4, 0x73005($5)          #loops through each SSD 
            divi $4, $4, 0x10           #removes the right 4 bits
            subi $5, $5, 1              #incrments the counter 
            bnez $5, printswitches      #checks that 4 things have printed to the SSD
            j parallel_job

        invertswitches:
            xori $4, $4, 0xFFFF         #exclusive or to flip all the switchs
            j printswitches             #jumps to printswitches to print all the flipped switches

        exitbutton:
            bnez $7, returnparallel
            j exit

        returnparallel:
            jr $ra      #return from parallel job
            

       