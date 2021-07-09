#Yahav Zarfati

.data
.section .rodata

        format_invalid: .string "invalid input!\n"

.text
.global pstrlen
    .type pstrlen, @function
# pstrlen func
pstrlen:
	subq $1,(%rdi)							
	movzbq    (%rdi), %rax                 
    ret

.globl replaceChar
	.type replaceChar, @function
# replaceChar func
replaceChar: 
# Get char 2, char 1, pstring*
    movq %rdx, %r9                                 
    movq %rsi, %r11                                 
    movq %rdi, %rsi                                 
    movq %rsi, %r8                                  
    movq (%r8), %rax                                
    movq $0, %rax								
    movb %al, %cl
    movq %rcx, %r10
    incq %r8                                       
    
    movq $0, %rax                               
    cmp %rcx, %r10
    
    # Check if r10 > rcx
    ja replaceCharLoop                              
    jmp replaceCharEnd
    replaceCharLoop:
    
    movq $0, %rdx                                
    movq $0, %rax								
    movb (%r8), %dl                                 # dl = pstr[i]
    movq %r11, %rax								
    cmpb %dl, %al
    
    # Check if equal
    je replaceChar_check							
    jmp replaceChar_endcheck
    replaceChar_check:
    movq %r9, %rax
    movq $0, %rdx									
    movb %al, %dl
    movb %dl, (%r8)
    
    replaceChar_endcheck:
    incq %r8                                        
    incq %rcx                                       
    cmp %rcx, %r10	
    
    # Check if r10 > rcx								
    ja replaceCharLoop                              
    
    # Return pstring *
    replaceCharEnd:
    movq %rsi, %rax                                 
    ret
    
.globl pstrijcpy
	.type pstrijcpy, @function
 # pstrijcpy func
pstrijcpy:

    # Get dst - Pstring 1 - rdi, src - Pstring 2 - rsi, i - rdx, j - rcx
    movb %dl, %al									
    movb %cl, %ah 									
    movq %rsi, %rsi 								
	subq $1, (%rsi)									
    movq %rdi, %rdi 								
	subq $1, (%rdi)									
    movq %rdi, %r13
    
    # Check if i,j are legal
    cmpb %ah, (%rdi)    							#Check if j > pstr1.len
    jb pstrijcpy_if
    cmpb %al, (%rsi)    							#Check if i > pstr2.len
    jb pstrijcpy_if
    cmpb %al, (%rdi)    							#Check if i > pstr1.len
    jb pstrijcpy_if
	cmpb %ah, (%rsi)    							#Check if j > pstr2.len
    jb pstrijcpy_if
    jmp pstrijcpy_endcheck 							#After i,j is legal check, jump to func
    
    # If i, j invalid
    pstrijcpy_if:
    movq $format_invalid, %rdi
    movq $0, %rax
    call printf
    jmp pstrijcpy_end 								
        
    pstrijcpy_endcheck:
    pstrijcpy_loop: 								
    cmpb %al, %ah									
    jb pstrijcpy_end								# Check if(i > j) - finished string
    
    movq $0, %rbx
    movb %al, %bl                        			#i in rbx
    leaq 1(%rsi, %rbx, 1), %rcx         			#pstr2[i]
    leaq 1(%rdi, %rbx, 1), %rdx          			#pstr1[i]
    
    movq $0, %rbx
    movb (%rcx), %bl 								#pstr1[i] = pstr2[i]
    movb %bl, (%rdx) 
        
    incb %al 										#i++
    jmp pstrijcpy_loop								# Continue loop
    pstrijcpy_end:									# End of loop, return pstring*
    movq %r13, %rax 								
    ret

.globl swapCase
	.type swapCase, @function
swapCase:
    # Get Pstring* - rdi
    subq $1, (%rdi)    
    movq %rdi, %rax 							    
    movzbq (%rax), %rcx 							
    movq $0, %rdx 								
    letters_loop: 									# Iterate on string
    cmpb %dl, %cl        							# Check if(i >= length) 
    jle swapCase_end
    leaq 1(%rax,%rdx,1), %rbx 	        			#str[i]
    cmpb $65, (%rbx) 								# Check if(str[i] < 65)
    jb notCapital
    cmpb $90, (%rbx) 								# Check if(str[i] > 90) 
    ja notCapital
    addb $32, (%rbx) 								# Change to small
    jmp notSmall 		
    
    # Check if not capital
    notCapital:
    cmpb $97, (%rbx) 								# Check if(str[i] < 97)
    jb notSmall		
    cmpb $122, (%rbx) 								# Check if(str[i] > 122)
    ja notSmall
    subb $32, (%rbx) 								# Change to capital
	
	# Check if not small
    notSmall:
    incq %rdx 										#i++
    jmp letters_loop 								
    
    swapCase_end:
    ret

.globl pstrijcmp
	.type pstrijcmp, @function
pstrijcmp:
    # Get i, j, pstring * 2, pstring * 1
    movb %dl, %al                       
    movb %cl, %ah                       
    movq %rsi, %rsi                     
    movq %rdi, %rdi                     
    
    # Check if i and j are valid
    cmpb %ah, (%rdi) 					#Check j > str1.len
    jb pstrijcmp_isvalid
    cmpb %al, (%rsi) 					#Check i > str2.len
    jb pstrijcmp_isvalid
    cmpb %al, (%rdi) 					#Check i > str1.len
    jb pstrijcmp_isvalid
	cmpb %ah, (%rsi) 					#Check j > str2.len
    jb pstrijcmp_isvalid
    jmp pstrijcmp_canStart				

	# Invalid input
    pstrijcmp_isvalid:
    movq $format_invalid, %rdi
    movq $0, %rax
    call printf
    jmp pstrijcmp_error		

    pstrijcmp_canStart:
    pstrijcmp_loop:        	            #Loop
    cmpb %al, %ah 						#Check if(i > j) 
    jb pstrijcmp_endloop
    
    movq $0, %rbx 					
    movb %al, %bl 						#bl = i
    leaq 1(%rdi,%rbx,1), %rcx       	#str1[i]
    leaq 1(%rsi,%rbx,1), %rdx 	        #str2[i]
    
    movq $0, %rbx
    movb (%rcx), %bl 					#bl = str1[i]
    movb (%rdx), %bh 					#bh = str2[i]
    cmpb %bl, %bh
    
    jb pstrijcmp_bigger  				#Check if(str1[i] > str2[i])
    ja pstrijcmp_smaller             	#Check if(str1[i] < str2[i])

    incb %al 							#i++
    jmp pstrijcmp_loop 					#continue loop

    pstrijcmp_endloop: 					#Strings same len
    movq $0, %rax
    jmp pstrijcmp_exit
    
    pstrijcmp_error: 		        #if invalid input
    movq $-2, %rax 						
    jmp pstrijcmp_exit
    
    pstrijcmp_bigger: 					#if pstr1 is bigger
    movq $1, %rax 						
    jmp pstrijcmp_exit
    
    pstrijcmp_smaller: 					#if pstr2 is smaller
    movq $-1, %rax						
    jmp pstrijcmp_exit
    
    pstrijcmp_exit:
    ret
    