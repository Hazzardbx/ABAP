
*&---------------------------------------------------------------------*
*& Report ZCOCKPIT_ORDERS2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcockpit_orders2.

"tabelas para armazenar dados relativos a pedidos(ekko e ekpo) e materiais(makt)
TABLES: ekko, ekpo, makt.

INCLUDE zcockpit_screen.
INCLUDE zcockpit_top. "variáveis globais
INCLUDE zlcl_class.
INCLUDE zcockpit_rot.

START-OF-SELECTION.

  CREATE OBJECT ol_orders.

  PERFORM get_data. "obter dados necessários
  PERFORM create_alv.
  PERFORM display_alv.

END-OF-SELECTION.

  INCLUDE zcockpit_orders2_status_010o01.
  INCLUDE zcockpit_orders2_user_commai01.

  INCLUDE zcockpit_orders2_status_020o01.
  INCLUDE zcockpit_orders2_user_commai02.
