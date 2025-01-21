*&---------------------------------------------------------------------*
*& Include          ZCOCKPIT_TOP
*&---------------------------------------------------------------------*

"instancias das classes
DATA: ol_orders TYPE REF TO zcl_ckf_orders,
      ol_order  TYPE REF TO zcl_ckf_order,
      ol_items  TYPE REF TO zcl_ckf_items.

"tabelas internas e estruturas para pedidos de compras
DATA: it_orders TYPE zckf_p_orders_tt,
      ls_orders TYPE zckf_p_orders_st.

"tabela para receber regitos das linhas do alv
DATA: lt_temp_data TYPE zckf_p_orders_tt,
      ls_temp_data TYPE zckf_p_orders_st.

"Ordens de compras e items para exibicao alv
DATA: gt_data TYPE zckf_p_orders_tt,
      ls_data TYPE zckf_p_orders_st.

"alv e instâncias de uso
DATA: lo_alv     TYPE REF TO cl_salv_table.
DATA: gr_events     TYPE REF TO cl_salv_events_table.

DATA: lt_selected_rows TYPE salv_t_row,
      ls_selected_row  LIKE LINE OF lt_selected_rows.

"---------------------------------------------------------

DATA: okcode100 TYPE sy-ucomm,
      in_menge  TYPE ekpo-menge,
      in_menge2 TYPE ekpo-menge. " ou BSTMG que é o tipo de dado de MENGE

"Variáveis para SEND MAIL
DATA: lt_objcont TYPE TABLE OF soli.

DATA: lv_message_mail TYPE string,
      lv_msg_r        TYPE zckf_msg_st.

DATA: in_email   TYPE string,
      in_subject TYPE string,
      in_mail    TYPE string,
      ok_code    TYPE sy-ucomm.

DATA: textedit_container TYPE REF TO cl_gui_custom_container,
      editor             TYPE REF TO cl_gui_textedit. "classe para o editor de texto

DATA: teditor TYPE scrfname.

DATA: ol_container TYPE REF TO cl_gui_container.

"para utilizar o screen tem que criar o tipo de dado IN_MENGE2

"CRIAR VARIÁVEIS PARA O INPUT
DATA: okcode200 TYPE sy-ucomm.

DATA: in_ebelp TYPE ekpo-ebelp,
      in_ebeln TYPE ekko-ebeln.

DATA: lv_email_body TYPE string.

DATA: custom_control TYPE scrfname. "para construir o grid
DATA: ol_grid TYPE REF TO cl_gui_custom_container.   "classe do grid
