import scipy.sparse as sparse
from scipy.io import mmread
import petsc4py
petsc4py.init()
from petsc4py import PETSc
import numpy as np

# read mtx 
matrix_name = "bcsstk06.mtx"
matrix = mmread(matrix_name)
matrix = matrix.toarray()
N = matrix.shape[0]

# create PETSc comm
comm = PETSc.COMM_WORLD
size = comm.getSize()
rank = comm.getRank()

# create PETSc vectors
x = PETSc.Vec().create(comm=comm)
x.setSizes(N)
x.setFromOptions()

b = x.duplicate()
u = x.duplicate()

rstart, rend = x.getOwnershipRange()
nlocal = x.getLocalSize()

# Create PETSc matrix
A = PETSc.Mat().create(comm=comm)
A.setSizes(N, nlocal)
A.setFromOptions()
A.setUp()

print(rstart, rend)
for i in range(rstart, rend):
    for j in range(matrix.shape[1]):
        A.setValue(i, j, matrix[i,j])

A.assemblyBegin()
A.assemblyEnd()

# set PETSc vectors
u.set(1.0)
b = A(u)

# create ksp solver and solve
ksp = PETSc.KSP().create(comm=comm)
ksp.setOperators(A)
pc = ksp.getPC()
pc.setType('jacobi')
ksp.setTolerances(rtol=1.e-7)
ksp.setFromOptions()
ksp.solve(b, x)

# check the error
x = x - u # x.axpy(-1.0,u)
norm = x.norm(PETSc.NormType.NORM_2)
its = ksp.getIterationNumber()

PETSc.Sys.Print("Norm of error {}, Iterations {}\n".format(norm,its),comm=comm)
if size==1:
    PETSc.Sys.Print("- Serial OK",comm=comm)
else:
    PETSc.Sys.Print("- Parallel OK",comm=comm)
