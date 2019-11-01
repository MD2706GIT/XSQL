        // ---------------------------------------------------
        // XSQL0003 - Builds work member name
        // ---------------------------------------------------

        ctl-opt dftactgrp(*no) actgrp(*caller)
           option(*nodebugio:*srcstmt);
       // *ENTRY PLIST
        dcl-pi XSQL0003;
           pStmf   char(120);
           pNewMbr char(120);
           pNewMbr2 char(10);
        end-pi;

        dcl-s  mbr  char(27);

        *inLR=*on;
        Exec SQL
          SET OPTION Commit=*none,
                     CloSqlCsr=*EndActGRP,
                     DlyPrp=*YES
          ;
          monitor;
          // build name
          clear pNewMbr;

          mbr='M' + %char(%time():*ISO0);
          pNewMbr='/QSYS.LIB/QTEMP.LIB/XSQLSRCF.FILE/' +
              %trim(mbr) + '.MBR';
          pNewMbr2=%trim(mbr);

          on-error;
             exsr errors;
          endmon;

        return;
        // ---------------------------------------------------
        begsr Errors;

        endsr;


