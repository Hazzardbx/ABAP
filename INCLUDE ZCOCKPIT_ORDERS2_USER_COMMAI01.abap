*----------------------------------------------------------------------*
***INCLUDE ZCOCKPIT_ORDERS2_USER_COMMAI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE okcode100.
    WHEN 'FCT_CANCELAR'.
      MESSAGE 'Operação cancelada.' TYPE 'I'.
      LEAVE TO SCREEN 0.
    WHEN 'FCT_SUBMETER'.

*        PERFORM edit_order.
      CALL FUNCTION 'ZCHANGE_ORDER'
        EXPORTING
          po_key   = in_ebeln
          po_item  = in_ebelp
          quantity = in_menge2.

      IF sy-subrc = 0.
        MESSAGE 'Registo editado' TYPE 'I'.
*          lo_alv->get_columns( ).
*          lo_alv->refresh( ).
*          lo_alv->display( ).
      ELSE.
        MESSAGE 'Não foi possível editar o registo' TYPE 'I'.
      ENDIF.



      SET SCREEN 0.
      LEAVE SCREEN.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&F3'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
