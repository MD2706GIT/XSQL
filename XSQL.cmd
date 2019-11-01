/* ---------------------------------------------------- */
/*                                                      */
/* XSQL - Execute SQL scripts with parameters           */
/*                                                      */
/*        CPP : XSQL0000                                */
/*                                                      */
/* ---------------------------------------------------- */
CMD        PROMPT('XSQL - Execute SQL script')

             PARM       KWD(SRCLIB) TYPE(*NAME) LEN(10) +
                          PROMPT('Source library')
             PARM       KWD(SRCFILE) TYPE(*NAME) LEN(10) +
                          PROMPT('Source file')
             PARM       KWD(SRCMBR)  TYPE(*NAME) LEN(10) +
                          PROMPT('Member')
             PARM       KWD(STMF)    TYPE(*CHAR) LEN(120) +
                          PROMPT('Stream file')
             PARM       KWD(PARMS)   TYPE(*CHAR) LEN(200) +
                          PROMPT('Parameters')

             DEP        CTL(SRCLIB) PARM((SRCFILE) (SRCMBR)) NBRTRUE(*EQ 2)
             DEP        CTL(SRCFILE) PARM((SRCLIB) (SRCMBR)) NBRTRUE(*EQ 2)
             DEP        CTL(SRCMBR) PARM((SRCFILE) (SRCLIB)) NBRTRUE(*EQ 2)
             DEP        CTL(*ALWAYS) PARM((SRCLIB) (STMF)) +
                          NBRTRUE(*EQ 1) MSGID(CPDEF80)
