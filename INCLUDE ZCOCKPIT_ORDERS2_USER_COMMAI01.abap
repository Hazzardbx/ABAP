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
      MESSAGE s013(zcl_ckf_msg).
      LEAVE TO SCREEN 0.
    WHEN 'FCT_SUBMETER'.
      "ALTERAR ITEMS(EDIT)
      "cria um objeto de item
      CREATE OBJECT ol_items
        EXPORTING
          po_key = in_ebeln.

      "recebe os items relacionados ao pedido
      ol_items->get_items( ).

      "cria uma estrutura para enviar ao metodo
      DATA: ls_items TYPE zckf_items_st.
      ls_items-ebeln = in_ebeln.
      ls_items-ebelp = in_ebelp.
      ls_items-menge = in_menge2.

      "envia a estrutura para alteracao da quantidade do item
      ol_items->set_new_quantity( ls_items = ls_items ).

      "verifica retorno de operacao
      IF sy-subrc = 0.
        MESSAGE s014(zcl_ckf_msg).
      ELSE.
        MESSAGE e019(zcl_ckf_msg).
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
