.global main
.text
main: 
    add $2, $0, $0      # init $2
    add $3, $0, $0      # init $3
    add $4, $0, $0      # init $4

buttonpress:
    lw $2, 0x73001($0)                  # has a button been pressed 
    bnez $2, buttonpress                # if not keep looping until one has been pressed

    sw $2, 0x73001($0)                  # stores the button was pressed
    sw $4, 0x73000($0)                  #reads the swichs and stores them in $4

                #check which button was pressed 
    seqi $3, $2, 2                      #checks if the middle button was pressed 
    bnez $3, invertswitches             #if it was branches to invert switches

    seqi $3, $2, 4                      # checks if the left button was pressed
    bnez $3, exit                       # if it was branches to exit

    #bnez $2, printswitches              #otherwise branches to printing out the switches normally.  

printswitches:

    #read last 4
        



invertswitches:


    

exit: 
    jr $ra 
