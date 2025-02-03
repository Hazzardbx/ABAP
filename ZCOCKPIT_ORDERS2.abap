
*&---------------------------------------------------------------------*
*& Report ZCOCKPIT_ORDERS2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcockpit_orders2.

TABLES: ekko, ekpo, makt.

INCLUDE zcockpit_screen.
INCLUDE zcockpit_top.
INCLUDE zlcl_class.
INCLUDE zcockpit_rot.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM create_alv.
  PERFORM display_alv.

END-OF-SELECTION.
