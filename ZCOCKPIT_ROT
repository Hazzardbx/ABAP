*&---------------------------------------------------------------------*
*& Include          ZCOCKPIT_ROT
*&---------------------------------------------------------------------*

FORM get_data.

  REFRESH gt_data.

  IF so_dtped IS NOT INITIAL.
    LOOP AT so_dtped INTO DATA(ls_data).
      ls_data-high = sy-datum.
      so_dtped-high = ls_data-high.
      MODIFY so_dtped FROM ls_data.

    ENDLOOP.

    IF p_tpedid IS INITIAL.
      p_tpedid = 'NB'.
    ENDIF.

    ol_orders->get_orders_filter(
      EXPORTING
        aedats          = so_dtped[]
        bsart           = p_tpedid
        ebelns          = so_nped[]
      IMPORTING
        it_orders2      = it_orders
    ).

    LOOP AT it_orders INTO ls_orders.
      APPEND ls_orders TO gt_data.
    ENDLOOP.

  ELSE.

    IF p_tpedid IS INITIAL.
      p_tpedid = 'NB'.
    ENDIF.

    ol_orders->get_orders_filter(
      EXPORTING
        aedats          = so_dtped[]
        bsart           = p_tpedid
        ebelns          = so_nped[]
      IMPORTING
        it_orders2      = it_orders
    ).

    LOOP AT it_orders INTO ls_orders.
      APPEND ls_orders TO gt_data.
    ENDLOOP.

  ENDIF.

ENDFORM.

FORM set_multiselection.

  lo_alv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>cell ).

ENDFORM.

FORM set_events. "form para o evento "on click"

  CREATE OBJECT event_handler.

  gr_events = lo_alv->get_event( ).
  SET HANDLER event_handler->on_click FOR gr_events.

ENDFORM.

FORM create_alv.

  DATA: lt_fieldcat TYPE lvc_t_fcat,
        ls_fieldcat TYPE lvc_s_fcat.

  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = lo_alv                          " Basis Class Simple ALV Tables
    CHANGING
      t_table      = gt_data.

  " PF STATUS ANTES DO DISPLAY DA ALV
  lo_alv->set_screen_status(
    EXPORTING
      report        = sy-repid
      pfstatus      = 'STANDARD'
      set_functions = cl_salv_table=>c_functions_all
  ).

  IF lo_alv IS NOT INITIAL.
    lo_alv->get_functions( )->set_all( abap_true ).

    PERFORM set_events.
    PERFORM set_multiselection.
  ENDIF.

ENDFORM.

FORM display_alv.

  lo_alv->display( ).

ENDFORM.

FORM get_selected_rows.

  lt_selected_rows = lo_alv->get_selections( )->get_selected_rows( ).

  IF lt_selected_rows IS INITIAL.
    MESSAGE 'Please select a line' TYPE 'I'.
    RETURN.
  ELSE.
    CLEAR lt_temp_data.
    LOOP AT lt_selected_rows INTO ls_selected_row.
      READ TABLE gt_data INTO DATA(ls_data) INDEX ls_selected_row.
      IF sy-subrc = 0.
        "popular nova tabela com linhas selecionadas
        ls_temp_data = ls_data.
        APPEND ls_temp_data TO lt_temp_data.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM release_order.

  LOOP AT lt_temp_data INTO ls_temp_data.
    CALL FUNCTION 'ZRELEASE_ORDER'
      EXPORTING
        po_key = ls_temp_data-ebeln.
  ENDLOOP.

  IF sy-subrc EQ 0.
    MESSAGE 'Pedido Liberado com Sucesso' TYPE 'S'.
  ENDIF.

ENDFORM.

FORM delete_order.

  DATA: lt_index TYPE TABLE OF sy-tabix,
        lv_index TYPE sy-tabix.

  lt_selected_rows = lo_alv->get_selections( )->get_selected_rows( ).
  IF lt_selected_rows IS INITIAL.
    MESSAGE 'Por favor selecione a(s) linha(s) a apagar.' TYPE 'I'.
    RETURN.
  ELSE.
    LOOP AT lt_selected_rows INTO ls_selected_row.
      READ TABLE gt_data INTO DATA(ls_data) INDEX ls_selected_row TRANSPORTING NO FIELDS.
      " TRANSPOSRTING NO FIELDS - A linha existe, mas os dados da linha não foram transferidos para uma variável
      IF sy-subrc = 0.
        DELETE gt_data INDEX ls_selected_row.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM send_mail_order.

  CONCATENATE 'Order number: ' ls_temp_data-ebeln
              'Item: ' ls_temp_data-ebelp
              'Material: ' ls_temp_data-matnr
              INTO in_mail SEPARATED BY space.

  LOOP AT lt_temp_data INTO ls_temp_data.

*    IF in_mail IS INITIAL.
      CALL FUNCTION 'ZSEND_MAIL_ORDER'
        EXPORTING
          po_key       = ls_temp_data-ebeln
          message_mail = lv_message_mail
        IMPORTING
          ls_result    = lv_msg_r.

      IF lv_msg_r-rc = 0. " Sucesso
        MESSAGE 'E-mail enviado com sucesso.' TYPE 'S'.
      ELSE.
        MESSAGE 'Erro ao enviar e-mail' TYPE 'E'.
      ENDIF.

*    ENDIF.



  ENDLOOP.


ENDFORM.


*FORM send_mail_order.
*
*
*
*  custom_control = 'TEDITOR'.
*
*  CREATE OBJECT ol_grid
*    EXPORTING
*      container_name = custom_control.
*
*  CREATE OBJECT editor
*    EXPORTING
*      parent = ol_grid.                         " Parent Container
*
*
*  CALL METHOD editor->get_selected_text_as_r3table
*    IMPORTING
*      table = lt_objcont.                 " table with selected text
*
*
*  DATA: lv_email_body TYPE string.
*  LOOP AT lt_objcont INTO DATA(ls_line).
*    CONCATENATE lv_email_body ls_line INTO lv_email_body  SEPARATED BY space. "Para adicionar texto do container
*  ENDLOOP.
*
*  LOOP AT lt_temp_data INTO ls_temp_data.
*    CONCATENATE lv_email_body
*                'Order Number: ' ls_temp_data-ebeln
*                'Item: ' ls_temp_data-ebelp
*                'Material: ' ls_temp_data-matnr
*                INTO lv_email_body SEPARATED BY cl_abap_char_utilities=>cr_lf.
*  ENDLOOP.
*
**    DATA: string_mail TYPE string.
**    LOOP AT lt_objcont into DATA(ls_line).
*
**  ENDLOOP.
*
*
*
*
*
*  LOOP AT lt_temp_data INTO ls_temp_data.
*
*    CALL FUNCTION 'ZSEND_MAIL_ORDER'
*      EXPORTING
*        po_key       = ls_temp_data-ebeln
*        message_mail = lv_message_mail
*      IMPORTING
*        ls_result    = lv_msg_r.
*
*    IF lv_msg_r-rc = 0. " campo RC = 0 / Sucesso
*
**        CALL SCREEN 200.
*
*      MESSAGE 'E-mail enviado com sucesso.' TYPE 'S'.
*    ELSE.
*      MESSAGE 'Erro ao enviar e-mail' TYPE 'E'.
*    ENDIF.
*
*  ENDLOOP.
*
*  " Chamar a tela 200 para preencher o texto do e-mail
*
*
*ENDFORM.

"https://sapcodes.com/2016/10/10/concatenation-new-way-of-using/
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(PO_KEY) TYPE  EBELN
*"     REFERENCE(MESSAGE_MAIL) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     REFERENCE(LS_RESULT) TYPE  ZCKF_MSG_ST
*"----------------------------------------------------------------------
