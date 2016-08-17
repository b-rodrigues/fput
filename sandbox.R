sqrt_newton <- function(a, init, eps = 0.01){
    while(abs(init**2-a) > eps){
        init <- 1/2 *(init + a/init)
    }
    return(init)
}



sqrt_newton2 <- function(a, init, eps = 0.01){
    if(abs(init**2 - a) < eps){
        result <- init
    } else {
        result <- sqrt_newton2(a, 1/2 * (init + a/init), eps)
    }
    return(result)
}

sqrt_newton_tail <- function(a, init){
    sqrt_helper <- function(a, init, eps = 0.01){
        if(abs(init**2 - a) < eps){
            return(init)
        } else {
            sqrt_helper(a, 1/2 * (init + a/init), eps)
        }
    }
    return(sqrt_helper(a, init))
}


untrace(sqrt_newton_tail)
sqrt_newton_tail(16000,2)

untrace(sqrt_newton2)
sqrt_newton2(16000,2)

Fibo <- function(n){
    a <- 0
    b <- 1
    for (i in 1:n){
        temp <- b
        b <- a
        a <- a + temp
    }
    return(a)
}

FiboRecur <- function(n){
    if (n == 0 || n == 1){
        return(n)
    } else {
        return(FiboRecur(n-1) + FiboRecur(n-2))
        }
}

FiboRecurTail <- function(n){
    fib_help <- function(a, b, n){
        if(n > 0){
            return(fib_help(b, a+b, n-1))
        } else {
            return(a)
        }
    }
    return(fib_help(0, 1, n))
}

untrace(FiboRecurTail)
FiboRecurTail(25)

