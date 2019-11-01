        // -----------------------------------------------
        // XSQL0002 - Parse PARMS parameter in
        //            key-value pairs
        // -----------------------------------------------

        ctl-opt dftactgrp(*no) actgrp(*caller)
           option(*nodebugio:*srcstmt);
       // *ENTRY PLIST
        dcl-pi XSQL0002;
           pParms  char(200);
           pTag    char(10) dim(100);
           pValue  char(200) dim(100);
           pError  char(3);
        end-pi;

       // XSQL0001 - Retrieve delimiters
        dcl-pr XSQL0001  extpgm('XSQL0001');
           *n      char(1);
           *n      char(1);
           *n      char(3);
        end-pr;

        dcl-s  x1   char(1);
        dcl-s  x9   char(1);
        dcl-s  tag  char(10);
        dcl-s  val  char(100);
        dcl-s  i    packed(3:0);
        dcl-s  d1   packed(3:0);
        dcl-s  d2   packed(3:0);
        dcl-s  v1   packed(3:0);
        dcl-s  v2   packed(3:0);

        *inLR=*on;
        Exec SQL
          SET OPTION Commit=*none,
                     CloSqlCsr=*EndActGRP,
                     DlyPrp=*YES
          ;
          monitor;
          // if no parameters specifed, return
          if pParms = *blank;
             return;
          endif;
          // get variable delimiters
          XSQL0001(x1:x9:pError);
          if pError<>*blank;
             return;
          endif;

          // check if no delimiters found in PARMS parameter
          if %scan(x1:pParms) = 0 or
             %scan(x9:pParms) = 0 ;
             pError = '011';
             return;
          endif;
          // initial delimiter must be the first non-blank char
          if %scan(x1:%trim(pParms)) <> 1;
             pError = '011';
             return;
          endif;

          // scan for delimiters, get placeholders and values
          d1=0;
          d2=1;
          clear pTag;
          clear pValue;

          dou d1=0;
             clear tag;
             clear val;
             d1=%scan(x1:pParms:d2);
             if d1<>0;
                d2=%scan(x9:pParms:d1);
                tag = %subst(pParms:d1:(d2-d1+1));
                // trim spaces within delimiters
                tag = %scanrpl(x1:' ':tag);
                tag = %scanrpl(x9:' ':tag);
                tag = x1 + %trim(tag) + x9;
                // scan for equal sign '='
                v1=%scan('=':pParms:d2);
                if v1=0;
                   pError='011';
                   exsr errors;
                   leave;
                endif;
                v1+=1;
                v2=%scan(x1:pParms:v1);
                if v2=0;
                   v2=200;
                endif;
                val=%trim(%subst(pParms:v1:(v2-v1)));

                i+=1;
                pTag(i)=tag;
                pValue(i)=val;
             endif;
          enddo;


          on-error;
             pError='012';
             exsr errors;
          endmon;

        return;
        // ---------------------------------------------------
        begsr Errors;
        endsr;

