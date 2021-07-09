#Yahav Zarfati

.data
.section .rodata
format_c1: .string "%c"
format_d1: .string "%d"
format_s1: .string "%s"

.align 8
SWITCH:
	.quad L50
  .quad L51
	.quad L52
	.quad L53
	.quad L54
	.quad L55
  .quad L56
  .quad L57
  .quad L58
  .quad L59
  .quad L60
	.quad default


    # for the switch case
    format_50:    .string "first pstring length: %d, second pstring length: %d\n"
    format_52:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n" 
    format_53:    .string "length: %d, string: %s\n"
    format_54:    .string "length: %d, string: %s\n"
    format_55:    .string "compare result: %d\n"
    format_invalid:   .string "invalid option!\n"
    
.text
.globl run_func
	.type run_func, @function
	
run_func:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14


	# Set up switch frame
    leaq -50(%rdi), %r8
    cmpq $10, %r8
    ja default
    jmp *SWITCH(,%r8,8)
     
    L50:	
    movq    %r15, %rdi                      # r15 gets pstring* 1
    movq    $0, %rax
    call    pstrlen                         # first pstring len
    pushq   %r13                            
    movq    %rax, %r13                      # r13 gets first pstring len
    
    movq    $0, %rax
    movq    %r12, %rdi                      # r12 gets second pstring
    call    pstrlen                         # second pstring len
    pushq   %r14                            
    movq    %rax, %r14                      # r14 gets second pstring len
            
    movq    %r13, %rsi                      # r13 gets first pstring len
    movq    %r14, %rdx                      # r14 gets second pstring len
    movq    $format_50, %rdi   
    movq    $0, %rax
    call    printf                          # print the pstrings len
    popq    %r14                            
    popq    %r13  
    jmp end			
    
    L51:
    jmp default 
     
    L52:
    # Get oldChar
    pushq %rdx 							#second string
    pushq %rsi 							#first string
    movq $format_s1, %rdi		       
    
    movq $0, %rbx
    pushq %rbx                                                  
    movq %rsp, %rsi                                             
    movq $0, %rax
    call scanf
    
	
    # Get newChar
    movq $format_s1, %rdi     		    
    movq $0, %rbx
    pushq %rbx  
    movq $0, %rax                        
    movq %rsp, %rsi                                            
    call scanf
 
    
    popq %rdx                           # Second char
    popq %rsi                           # First char
    popq %rdi                           # First string
    
    movq %rdx, %r12                     
    movq %rsi, %r13                     
    movq %rdi, %r14                     
    
    call replaceChar
    
    popq %rdi
    movq %r13, %rsi
    movq %r12, %rdx
    movq %rax, %r15                      
    
    call replaceChar
    
    movq $format_52, %rdi
    movq %r12, %rdx 
    movq %r13, %rsi                                           
    movq %r15, %rcx                     
    movq %rax, %r8                      
    incq %r8
    incq %rcx
    movq $0, %rax
    call printf
    jmp end
    
     
    L53: 
    pushq %rdx 							#second string
    pushq %rsi 							#first string
	
    # Scanf i
    movq $format_d1, %rdi    		
    movq $0, %r12
    pushq %r12                                              
    movq %rsp, %rsi                   
    movq $0, %rax
    call scanf
    movq $0, %rax                       

    # Scanf j
    movq $format_d1, %rdi    			
    movq $0, %rbx                       
    pushq %rbx                         
    movq %rsp, %rsi                     
    movq $0, %rax
    call scanf
    movq $0, %rax                       

    
     popq %rcx          # i               
     popq %rdx          # j            
     popq %rdi          # dst             
     popq %rsi          # src                
     movq %rsi, %r14                    
     call pstrijcpy						
     
     # Print format
     movq $format_53, %rdi 			
     movq %rax, %r15                    
     movzbq (%r15), %rsi			
	   incb %r15b
     movq %r15, %rdx
     movq $0, %rax
     call printf
     
     # Print format
     movq $format_53, %rdi 				
     movzbq (%r14), %rsi				
	   incb %r14b
     movq %r14, %rdx
     movq $0, %rax
     call printf 
     
     jmp end
     
     L54:
     movq %rdx, %r13                        #second string
     movq %rsi ,%r14                        #first string
     movq %rsi, %rdi                        #rdi gets string
     call swapCase
     
     movq $format_54, %rdi
     movq %rax, %rbx                        #rbx gets the new string
     movzbq (%rbx), %rsi					
     incb %bl
     movq %rbx, %rdx
     movq $0, %rax
     call printf
       
     movq %r13 ,%rdi                         #rdi gets second string
     call swapCase
     
     movq $format_54, %rdi
     movq %rax, %r12                         #r12 gets new string
     movzbq (%r12), %rsi					 
     incb %r12b
     movq %r12, %rdx
     movq $0, %rax
     call printf
     
     jmp end
 
     L55:
     pushq %rdx                          	# Get pstring * 2
     pushq %rsi                          	# Get pstring * 1
     
     # Scanf i
     movq $format_d1, %rdi    			 
     movq $0, %r12
     pushq %r12                         	
                                        
     movq %rsp, %rsi                  		
										
     movq $0, %rax
     call scanf
     movq $0, %rax
     
     # Scanf j
     movq $format_d1, %rdi     			  
     movq $-1, %rbx                      
     pushq %rbx                         
     movq %rsp, %rsi                    
     movq $0, %rax
     call scanf
  
     popq %rcx                             
     popq %rdx                              
     popq %rdi                              
     popq %rsi                              
     movq %rsi, %r14                       
     
     call pstrijcmp							
     
     movq $format_55, %rdi
     movq %rax, %rsi
     movq $0, %rax
     call printf
     
     jmp end
     
     L56:
     jmp default
     
     L57:
     jmp default
     
     L58:
     jmp default
     
     L59:
     jmp default
     
     L60:
     jmp L50
     
     default:
     
	   # Default for switch case, print invalid
     movq $format_invalid, %rdi   			
     movq $0, %rax					
     call printf							
     
     end:  
	   # Clear all calle registers
     popq %r14
     popq %r13
     popq %r12
     popq %rbx
      
     ret
     