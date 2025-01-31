*&---------------------------------------------------------------------*
*& Report ZTEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST.



TABLES sscrfields.
DATA dummy_structure_pernr TYPE pernr.
DATA:
  BEGIN OF structure_custom_fields,
    anything_1 TYPE c LENGTH 10,
    anything_2 TYPE c LENGTH 10,
  END OF structure_custom_fields.

SELECTION-SCREEN BEGIN OF TABBED BLOCK tab FOR 10 LINES.
  SELECTION-SCREEN TAB (40) tab_tab1 USER-COMMAND tab1 DEFAULT SCREEN 1001.
  SELECTION-SCREEN TAB (20) tab_tab2 USER-COMMAND tab2 DEFAULT SCREEN 1002.
SELECTION-SCREEN END OF BLOCK tab.

" Subscreen for Tab 1: Interface for Period and Personnel Number / Interface para periodo e Numero staff
SELECTION-SCREEN BEGIN OF SCREEN 1001 AS SUBSCREEN.
SELECT-OPTIONS s_pernr FOR dummy_structure_pernr-pernr.
SELECT-OPTIONS s_massn FOR dummy_structure_pernr-massn.
SELECT-OPTIONS s_massg FOR dummy_structure_pernr-massg.
SELECTION-SCREEN END OF SCREEN 1001.

" Subscreen for Tab 2
SELECTION-SCREEN BEGIN OF SCREEN 1002 AS SUBSCREEN.
SELECT-OPTIONS s_any_1 FOR structure_custom_fields-anything_1.
SELECT-OPTIONS s_any_2 FOR structure_custom_fields-anything_2.
SELECTION-SCREEN END OF SCREEN 1002.

INITIALIZATION.
  tab_tab1 = 'STANDARD SELECTION'.
  tab_tab2 = 'OTHER SELECTION'.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'TAB1'.
      MESSAGE 'STANDARD SELECTION' TYPE 'S'.
    WHEN 'TAB2'.
      MESSAGE 'OTHER SELECTION' TYPE 'S'.
  ENDCASE.

START-OF-SELECTION.
  WRITE: / 'Active Tab:', tab-activetab.
