# XSQL
For IBM i - tool to execute SQL statements passing variable values

The XSQL utility runs under the covers the RUNSQLSTM command, allowing you to specify a parameter in which you can pass variable values, which will replace the special “placeholders” appropriately set in the SQL script source.
XSQL command parameters:
- SRCLIB:     Source library
- SRCFILE:    Source file
- SRCMBR:     Member
- STMF:       Stream file
- PARMS:      Parameters

In the first four parameters you specify where the script source is stored (source file member OR IFS file). <br>
In PARMS parameter you can specify placeholders and their value, which will be then replaced in the SQL script where the variable placeholder appears. The replacement is performed on a temporary source member, so that the original script will remain untouched.
The variable names must be enclosed within square brackets. In the script source the variables must also be enclosed within brackets. 
The format of each variable to be passed is:

- open square bracket "`[`"
- variable name, as it appears in the script. I use the “CL style”, with an initial ampersand and one or more letters to identify the  variables (eg &L, &LIB, etc …)
- closed square bracket “`]`”
- equal sign “=”
- value to be replaced – WITHOUT QUOTES. The quotes are to be indicated in the script, in order to facilitate building the PARMS parameter string.
Examples of variables: `[&L] = LIB001, [ &F] = FILE001, [ &DATE ] = 20191101 etc.`

Instructions for installing:
- in a library of your choice, create QXSQL source file<br>
  CRTSRCPF FILE(mylib/QXSQL) RCDLEN(112)
- copy all sources in QXSQL source file
- compile ZZZXSQL CLLE program
- run ZZZXSQL program <br>
  CALL PGM(ZZZXSQL) PARM(mylib) <br>
  this will simply compile all programs and the XSQL command in one shot.  
 
