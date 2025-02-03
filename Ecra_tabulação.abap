*&---------------------------------------------------------------------*
*& Report ZKM_ECRA_TABULACAO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkm_ecra_tabulacao.

*&---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
*Conforme falado, a ideia será desenvolver um report com as seguintes features:
*Ecrã de seleção: Parâmetro: Nº Material (mara-matnr)
*                 Bloco com tabuladores
*                               1º TAB(“Info Mat”)  : Nº Material (mara-matnr) + Descritivo (makt-maktx)
*                               2º TAB(“Tipo Mat”) : Tipo de material (mara-mtart) + Grupo Mercadorias(mara-matkl) + Unidade de Medida (mara-meins)
*                               3ºTAB(“Criação”)    : Data de Criação (mara-ersda) + User criação (mara-ernam)
*Objetivo Inicial: o objetivo é que sejam preenchidos todos os campos dos diferentes tabuladores quando é pressionado “Enter”  após a colocação do material no parâmetro de seleção.
*&---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*

TABLES: mara, makt, sscrfields. "sscrdfields-ucomm.
*https://stackoverflow.com/questions/79302968/how-to-include-a-standard-selection-tables-pernr-in-a-tab-in-sap



SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
PARAMETERS: p_matnum TYPE mara-matnr.
SELECTION-SCREEN END OF BLOCK a1.

"Inicio da TABBED BLOCK.
SELECTION-SCREEN BEGIN OF TABBED BLOCK tab_block FOR 10 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND tab1 DEFAULT SCREEN 1001.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND tab2 DEFAULT SCREEN 1002.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND tab3 DEFAULT SCREEN 1003.
SELECTION-SCREEN END OF BLOCK tab_block.


SELECTION-SCREEN BEGIN OF SCREEN 1001 AS SUBSCREEN.
PARAMETERS: p_maktx TYPE makt-maktx.
SELECTION-SCREEN END OF SCREEN 1001.

SELECTION-SCREEN BEGIN OF SCREEN 1002 AS SUBSCREEN.
PARAMETERS: p_mtart TYPE mara-mtart,
            p_matkl TYPE mara-matkl,
            p_meins TYPE mara-meins.
SELECTION-SCREEN END OF SCREEN 1002.




SELECTION-SCREEN BEGIN OF SCREEN 1003 AS SUBSCREEN.
PARAMETERS: p_ersda TYPE mara-ersda,
            p_ernam TYPE mara-ernam.
SELECTION-SCREEN END OF SCREEN 1003.

INITIALIZATION.
*  text-001 = 'Seleção de Material'.
  tab1 = 'Info Mat'.
  tab2 = 'Tipo Mat'.
  tab3 = 'Criação'.

AT SELECTION-SCREEN ON p_matnum.
  PERFORM fill_data.

FORM fill_data.
  CLEAR: p_maktx, p_mtart, p_matkl, p_meins, p_ersda, p_ernam.

  SELECT SINGLE maktx INTO p_maktx FROM makt WHERE matnr = p_matnum.
  SELECT SINGLE mtart matkl meins INTO (p_mtart, p_matkl, p_meins) FROM mara WHERE matnr = p_matnum.
  SELECT SINGLE ersda ernam INTO (p_ersda, p_ernam) FROM mara WHERE matnr = p_matnum.
ENDFORM.







*    SELECT-OPTIONS: so_matinfo FOR mara-matnr.
*    SELECT-OPTIONS: so_mattype FOR mara-matnr.
*    SELECT-OPTIONS: so_crtdat FOR mara-ersda.
