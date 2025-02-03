*&---------------------------------------------------------------------*
*& Include          ZCOCKPIT_ROT
*&---------------------------------------------------------------------*

FORM get_data.

  REFRESH gt_data.

  "verifica se a data foi enviada
  IF so_dtped IS INITIAL.

    LOOP AT so_dtped INTO DATA(ls_data).
      ls_data-high = sy-datum.
      so_dtped-high = ls_data-high.
      MODIFY so_dtped FROM ls_data .
    ENDLOOP.

    IF p_tpedid IS INITIAL.
      p_tpedid = 'NB'.
    ELSE.
      IF p_tpedid <> 'NB'.
*        MESSAGE | 'Nenhum pedido encontrado' | TYPE 'S' DISPLAY LIKE 'E'.
        MESSAGE e021(zcl_ckf_msg).
        lv_msg_r-rc = 1.
        RETURN.
      ENDIF.
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
    "verifica se a data fim foi enviada
    LOOP AT so_dtped INTO DATA(ls_data2).
      IF ls_data2-high IS INITIAL.
        ls_data2-high = sy-datum.
        so_dtped-high = ls_data2-high.
        MODIFY so_dtped FROM ls_data2 .
      ENDIF.
    ENDLOOP.

    IF p_tpedid IS INITIAL.
      p_tpedid = 'NB'.
    ELSE.
      IF p_tpedid <> 'NB'.
*        MESSAGE | 'Nenhum pedido encontrado' | TYPE 'S' DISPLAY LIKE 'E'.
        MESSAGE e021(zcl_ckf_msg).
        lv_msg_r-rc = 1.
        RETURN.
      ENDIF.
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

  IF lv_msg_r-rc <> 1.
    lo_alv->display( ).
  ENDIF.

ENDFORM.

FORM get_selected_rows.

  lt_selected_rows = lo_alv->get_selections( )->get_selected_rows( ).

  IF lt_selected_rows IS INITIAL.
    MESSAGE s015(zcl_ckf_msg).
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

  DATA: it_results TYPE TABLE OF i.

  "libera os pedidos das linhas selecionadas
  LOOP AT lt_temp_data INTO ls_temp_data.

    "cria um objeto do pedido
    CREATE OBJECT ol_order
      EXPORTING
        lv_po_key = ls_temp_data-ebeln.

    "recebe o pedido de compra
    ol_order->get_order( ).

    "libera o pedido
    ol_order->release_order(
      IMPORTING
        result = lv_msg_r
    ).

    "verifica se houve erro no processo
    IF lv_msg_r-rc NE 0.
      APPEND lv_msg_r-rc TO it_results.
    ENDIF.

  ENDLOOP.

  "verifica erros de liberação
  READ TABLE it_results INTO DATA(ls_results) INDEX 1.
  IF sy-subrc EQ 0.
    MESSAGE s002(zcl_ckf_msg) WITH ls_temp_data-ebeln.
  ELSE.
    MESSAGE s000(zcl_ckf_msg) WITH ls_temp_data-ebeln.
  ENDIF.

ENDFORM.

FORM delete_order.

  DATA: lv_count TYPE i VALUE 1, "contador para linhas selecionadas
        lv_ebeln TYPE ebeln.     "casting de ebeln

  "recebe linhas selecionadas
  PERFORM get_selected_rows.

  "verifica se houveram linhas selecionadas
  IF lt_selected_rows IS INITIAL.
    MESSAGE s012(zcl_ckf_msg).
    RETURN.
  ELSE.

    "ciclo dura a quantidade de vezes == linhas selecionadas
    DO lines( lt_selected_rows ) TIMES.

      "busca o index da linha selecionada
      READ TABLE lt_selected_rows INTO DATA(ls_selected_rows) INDEX lv_count.

      "procura na tabela do alv usando o index como filtro
      READ TABLE gt_data INTO DATA(ls_data) INDEX ls_selected_rows.

      "se encontrou...
      IF sy-subrc = 0.

        "recebe o ebeln da linha encontrada
        lv_ebeln = ls_data-ebeln.

        "itera sobre a tabela do alv onde o ebeln existe
        LOOP AT gt_data INTO ls_data WHERE ebeln = lv_ebeln.

          "marca um campo desta linha com uma string
          ls_data-bukrs = 'DEL0'.

          "altera a tabela com as marcações
          MODIFY gt_data FROM ls_data.
        ENDLOOP.

        "incrementa o contador para a proxima linha selecionada
        ADD 1 TO lv_count.
      ENDIF.
    ENDDO.

    "depois de marcar as linhas da tabela que devem ser apagadas
    "iteramos novamente sobre a tabela procurando as strings de marcação
    LOOP AT gt_data INTO ls_data WHERE bukrs = 'DEL0'.
      "limpamos estas linhas // estruturas // de forma que fiquem vazias
      CLEAR ls_data.
      "alteramos a tabela do alv
      MODIFY gt_data FROM ls_data.
    ENDLOOP.

    "ao fim de todo o processo, removemos as linhas vazias da tabela.
    DELETE gt_data WHERE ebeln IS INITIAL.

  ENDIF.

ENDFORM.

FORM send_mail_order.

  "recebe texto do container
  CALL METHOD editor->get_text_as_r3table
    IMPORTING
      table = lt_objcont.

  "verifica se texto foi retornadoo
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "criar variáveis para passar a string o texto
  DATA: lv_line         TYPE string,
        lv_message_mail TYPE string.

  "trata mensagem a ser enviada
  CLEAR lv_message_mail.
  LOOP AT lt_objcont INTO lv_line.
    CONCATENATE lv_message_mail lv_line INTO lv_message_mail SEPARATED BY cl_abap_char_utilities=>cr_lf.
  ENDLOOP.

  "cria um objeto de ordem de compra
  IF ol_order IS INITIAL.
    CREATE OBJECT ol_order
      EXPORTING
        lv_po_key = old_ebeln.
  ENDIF.

  "recebe o pedido de compra da classe
  ol_order->get_order( ).

  "verifica se há texto para ser enviado antes de enviar o email
  IF lv_message_mail IS INITIAL.
    "envia email sem texto
    ol_order->send_mail_order(
      IMPORTING
        result       = lv_msg_r
    ).
  ELSE.
    "envia email com texto
    ol_order->send_mail_order(
      EXPORTING
        message_mail = lv_message_mail "texto do email
      IMPORTING
        result       = lv_msg_r "mensagem de retorno de operacoes
    ).
  ENDIF.

  "verifica retorno da operacao e envia mensagem de classe
  IF lv_msg_r-rc = 0. " Sucesso
    MESSAGE s001(zcl_ckf_msg).
  ELSE.
    MESSAGE s002(zcl_ckf_msg).
  ENDIF.

ENDFORM.
