#Yahav Zarfati

.section .rodata
format_d: .string "%d"
format_s: .string "%s"

.text
.global run_main
.type run_main, @function
run_main:
    # Set stack frame                       
    pushq %rbp                              
    movq %rsp, %rbp                         
    
    # Scanf 1 Pstring length
    subq $4,%rsp  
    movq $format_d, %rdi                           
    movq %rsp,%rsi                                            
    movq $0, %rax                        
    call scanf                              
    movzbq (%rsp), %r10                     
    leaq 4(%rsp), %rsp                       
    
    # Scanf 1 Pstring string
    subq %r10, %rsp                         
    leaq -1(%rsp), %rsp                     
    movq %rsp, %rsi                         
    movq $format_s, %rdi                    
    movq $0, %rax                           
    call scanf
    
    leaq    -1(%rsp), %rsp                  
    movb    %r10b, (%rsp)                   
    movq    %rsp, %r15                      

    # Scanf 2 Pstring length
    subq    $4, %rsp                        
    movq    %rsp, %rsi                      
    movq    $format_d, %rdi                 
    movq    $0, %rax                      
    call    scanf
    movzbq  (%rsp), %r10                    
    leaq    4(%rsp), %rsp                   
    
    # Scanf 2 Pstring string
    subq    %r10, %rsp                      
    leaq    -1(%rsp), %rsp       
    movq    $format_s, %rdi            
    movq    %rsp, %rsi                                      
    movq    $0, %rax                      
    call    scanf
    
    leaq    -1(%rsp), %rsp                  
    movb    %r10b, (%rsp)                   
    movq    %rsp, %r12                      
    
    # Scanf option
    leaq    -4(%rsp), %rsp       
    movq    $format_d, %rdi             
    movq    %rsp, %rsi                                    
    movq    $0, %rax                      
    call    scanf                           
    movq    $0, %r13
    movb    (%rsp), %r13b                  
  
    # Call fun_func with args opt, Pstring1, Pstring2
    movq    %r13, %rdi                     
    movq    %r15, %rsi                      
    movq    %r12, %rdx                      
    movq  	$0, %rax                     
    call    run_func                        
    
    
    # Close stack frame
    movq $0, %rax                      
    movq %rbp, %rsp                         
    popq %rbp                               
    ret
