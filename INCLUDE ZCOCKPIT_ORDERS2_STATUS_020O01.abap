*----------------------------------------------------------------------*
***INCLUDE ZCOCKPIT_ORDERS2_STATUS_020O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.



  IF editor IS INITIAL.
    SET PF-STATUS 'EMAIL'.
    SET TITLEBAR 'EMAIL'.

    "criar o container
    CREATE OBJECT textedit_container
      EXPORTING
        container_name              = 'TEDITOR'  " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    CREATE OBJECT editor
      EXPORTING
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_position          = 72
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true
        parent                     = textedit_container
      EXCEPTIONS
        error_cntl_create          = 1
        error_cntl_init            = 2
        error_cntl_link            = 3
        error_dp_create            = 4
        gui_type_not_supported     = 5
        OTHERS                     = 6.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

  ENDIF.

  "Obter o texto do editor e concatenar no conteúdo do email
  CALL METHOD editor->get_text_as_r3table "obter texto como uma tabela "lt_objcont"
    IMPORTING
      table = lt_objcont.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA: lv_line TYPE string.

  "Concatena texto do editor no body do email
  CLEAR lv_message_mail.
  LOOP AT lt_objcont INTO lv_line.
    CONCATENATE lv_message_mail lv_line INTO lv_message_mail SEPARATED BY cl_abap_char_utilities=>cr_lf. "class para processar string
  ENDLOOP.

  "Variáveis para preencher automático destinatário
  DATA: lv_ernam     TYPE ekko-ernam,
        lv_smtp_addr TYPE puser002-smtp_addr.

"Ler a primeira linha de lt_temp_data e armazena em ls_temp_data
  READ TABLE lt_temp_data INTO ls_temp_data INDEX 1.
  IF sy-subrc = 0.
    "seleciona quem criou o pedido na tabela EKKO
    SELECT SINGLE ernam INTO lv_ernam
      FROM ekko
      WHERE ebeln = ls_temp_data-ebeln.
  ENDIF.

  IF sy-subrc = 0.
    "seleciona quem criou o pedido na tabela puser002
    SELECT SINGLE smtp_addr INTO lv_smtp_addr
      FROM puser002
      WHERE bname = lv_ernam.

    IF sy-subrc = 0.
      in_mail = lv_smtp_addr.
    ENDIF.
  ENDIF.

ENDMODULE.

*
**      CONTEUDO DO EMAIL
*    DATA: lv_teditor TYPE string,
*          lv_objcont TYPE STANDARD TABLE OF string.
*
*    CALL METHOD editor->get_text_as_r3table
**     EXPORTING
**       only_when_modified     = false            " get text only when modified
*      IMPORTING
*        table = lt_objcont.
*
*    CONCATENATE lv_txtedit lv_editor INTO lv_txtedit SEPARATED BY cl_abap_char_utilities=>cr_lf.

**    PERFORM send_mail_order.
