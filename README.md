# XSQL
For IBM i - tool to execute SQL statements passing variable values

Instructions for installing:
- in a library of your choice, create QXSQL source file 
  CRTSRCPF FILE(mylib/QXSQL) RCDLEN(112)
- copy all sources in QXSQL source file
- compile ZZZXSQL CLLE program
- run ZZZXSQL program 
  CALL PGM(ZZZXSQL) PARM(mylib)
  this will simply compile all programs and the XSQL command in one shot.  
 
