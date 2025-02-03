*&---------------------------------------------------------------------*
*& Include          ZCOCKPIT_SCREEN
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-001.
*PARAMETERS: cb_check AS CHECKBOX.
SELECT-OPTIONS: so_dtped FOR ekko-aedat.
PARAMETERS: p_tpedid TYPE ekko-bsart.
SELECT-OPTIONS: so_nped FOR ekko-ebeln.
SELECTION-SCREEN END OF BLOCK a2.
