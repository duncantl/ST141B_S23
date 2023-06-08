m = matrix(1:15, 3, 5)
m[ m > 4 ]
i = which(m > 4, TRUE)
m[i]


m = matrix(1:15, 3, 5)

m[1, 3] = NA
m[2, 2] = NA
m[2, 4] = NA
m[3, 5] = NA

# Set these separately
# But
i = cbind(c(1, 2, 2, 3), c(3, 2, 4, 5))
m[i]

m[i] = NA







