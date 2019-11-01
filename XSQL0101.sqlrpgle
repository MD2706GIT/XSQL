        //
        // XSQL0101 - Build script replacing variables
        //

        ctl-opt dftactgrp(*no) actgrp(*caller)
                option(*nodebugio:*srcstmt);
       // *ENTRY PLIST
        dcl-pi XSQL0101 ;
           pMbr    char(10);
           pParms  char(200);
           pError  char(3);
        end-pi;

       // XSQL0002 - Parse parameters
        dcl-pr XSQL0002  extpgm('XSQL0002');
           *n      char(200);
           *n      char(10)  dim(100);
           *n      char(200) dim(100);
           *n      char(3);
        end-pr;

        dcl-s  tag       char(10) dim(100);
        dcl-s  val       char(200) dim(100);
        dcl-s  i         packed(3:0);
        dcl-c  $a        const(X'7D');
        dcl-s  SQLcmd    char(5000);
        dcl-s  logTxt    char(180);
        dcl-ds PgmDS psds qualified;
           Pgm  *proc;
           User char(10) pos(358);    // current user
        end-ds;

        *inLR=*on;
        Exec SQL
          SET OPTION Commit=*none,
                     CloSqlCsr=*EndMod,
                     DlyPrp=*YES
          ;

          monitor;
          // parse parameters -----------------------------------
          XSQL0002(pParms:tag:val:pError);

          if pError=*blank;
             // create alias
             SQLcmd = 'CREATE OR REPLACE ALIAS qtemp.&A ' +
                      ' FOR qtemp.XSqlSrcF (&M)' ;
             SQLcmd=%scanrpl('&A':%trim(pMbr)+'A':SQLcmd);
             SQLcmd=%scanrpl('&M':%trim(pMbr):SQLcmd);
             Exec SQL
                EXECUTE IMMEDIATE :SQLcmd;
             if SQLCODE<>0;
                exsr wrtLog;
             endif;

             // update source
             i=1;
             dow tag(i)<>*blank;
                SQLcmd = 'UPDATE qtemp.&A ' +
                         ' SET srcdta=REPLACE(srcdta, &T, &V )' +
                         ' WHERE srcdta LIKE &Q ' ;
                SQLcmd=%scanrpl('&A':%trim(pMbr) + 'A':SQLcmd);
                SQLcmd=%scanrpl('&T':$a + %trim(tag(i)) + $a:SQLcmd);
                SQLcmd=%scanrpl('&V':$a + %trim(val(i)) + $a:SQLcmd);
                SQLcmd=%scanrpl('&Q':$a + '%' + %trim(tag(i)) + '%' + $a
                               :SQLcmd) ;
                Exec SQL
                   EXECUTE IMMEDIATE :SQLcmd;
                if SQLCODE<>0 and SQLCODE<>100;
                   exsr wrtLog;
                endif;

                i+=1;
             enddo;
          endif;

          on-error;
             pError='101';
             exsr errors;
          endmon;

        return;
        // ---------------------------------------------------
        // Error handling
        // ---------------------------------------------------
        begsr errors;

        endsr;
        // ---------------------------------------------------
        // Writes event to Log file
        // ---------------------------------------------------
        begsr wrtLog;
           logTxt=SQLcmd;
           Exec SQL
             INSERT INTO LogPf00f
              VALUES (CURRENT_TIMESTAMP, :PgmDS.User,
                      :PgmDS.Pgm, :logTxt, ' ') ;
           exsr errors;
        endsr;

