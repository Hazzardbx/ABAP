*----------------------------------------------------------------------*
***INCLUDE ZCOCKPIT_ORDERS2_USER_COMMAI02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE okcode200.
    WHEN 'BTN_SEND'.
        PERFORM send_mail_order.
    WHEN 'BTN_CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN '&F03'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCELAR'.
      CLEAR old_ebeln.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
