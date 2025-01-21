*----------------------------------------------------------------------*
***INCLUDE ZCOCKPIT_ORDERS2_STATUS_010O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'TEST'.

  READ TABLE lt_temp_data INTO DATA(ls_changing) INDEX 1.
    in_ebeln = ls_changing-ebeln.
    in_ebelp = ls_changing-ebelp.
    in_menge = ls_changing-menge.

ENDMODULE.
