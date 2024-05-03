.global main
.text
main: 
    add $2, $0, $0      # init $2 stores which button was pressed 
    add $3, $0, $0      # init $3 used to check which button 
    add $4, $0, $0      # init $4 stores the switches 
    addi $5, $0, 4      # init $5 used to loop through SSD

buttonpress:
    lw $2, 0x73001($0)                  # has a button been pressed stores it in $2
    beqz $2, buttonpress                # if not keep looping until one has been pressed

    sw $2, 0x73001($0)                  # stores the button was pressed
    
    lw $4, 0x73000($0)                  # reads the swichs and stores them in $4

                    #check which button was pressed 
    seqi $3, $2, 2                      #checks if the middle button was pressed 
    bnez $3, invertswitches             #if it was branches to invert switches

    #could make it if the right and middle button pressed check for multiple of 4 when inverted. 

    seqi $3, $2, 4                      # checks if the left button was pressed
    bnez $3, exit                       # if it was branches to exit

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
    j main

invertswitches:
    xori $4, $4, 0xFFFF         #exclusive or to flip all the switchs
    
    j multiplecheck             #jumps to multiplecheck to see if the new value is a multiple of 4

exit:
    jr $ra                      #exits the code

