# KroneckerProduct
Calculates Kronecker Product of given A and B matrix. Function template:

kronecker(float* AMatrix, float* BMatrix, float* DestMatrix, int* SizeMatrix);

where: 
AMatrix - pointer to first matrix
BMatrix - pointer to second matrix
DestMatrix - pointer to preallocated matrix where kronecker product will be stored 
SizeMatirx - pointer to matrix of sizes - [ARows, ACols, BRows, BCols]

