        //
        //  XSQL0001 - Retrieve variable delimiters
        //  to be used in SQL scripts and in PARMS
        //  parameter
        //

        ctl-opt dftactgrp(*no) actgrp(*caller)
           option(*nodebugio:*srcstmt);
       // *ENTRY PLIST
        dcl-pi XSQL0001;
           pDelim1  char(1);
           pDelim9  char(1);
           pError   char(3);
        end-pi;

        *inLR=*on;
        Exec SQL
          SET OPTION Commit=*None,
                     CloSqlCsr=*EndMod,
                     DlyPrp=*YES
          ;
          monitor;
          // get variable delimiters
          pDelim1 = '[';
          pDelim9 = ']';

          on-error;
             exsr errors;
          endmon;

        return;
        // ---------------------------------------------------
        begsr errors;

        endsr;

