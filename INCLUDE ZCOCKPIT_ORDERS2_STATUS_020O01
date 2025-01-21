*----------------------------------------------------------------------*
***INCLUDE ZCOCKPIT_ORDERS2_STATUS_020O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  IF editor IS INITIAL.
    SET PF-STATUS 'STANDARD'.
    SET TITLEBAR 'EMAIL'.

    "criar o container
    CREATE OBJECT textedit_container
      EXPORTING
        container_name              = 'TEDITOR'         " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1                " CNTL_ERROR
        cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
        create_error                = 3                " CREATE_ERROR
        lifetime_error              = 4                " LIFETIME_ERROR
        lifetime_dynpro_dynpro_link = 5.                " LIFETIME_DYNPRO_DYNPRO_LINK
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.



    "criar o editor de texto
    CREATE OBJECT editor
      EXPORTING
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position " 0: OFF; 1: wrap a window border; 2: wrap at fixed position
        wordwrap_position          = 72                       " position of wordwrap, only makes sense with wordwrap_mode=2
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true                    " eq 1: change wordwrap to linebreak; 0: preserve wordwraps
        parent                     = textedit_container     " Parent Container
      EXCEPTIONS
        error_cntl_create          = 1                        " Error while performing creation of TextEdit control!
        error_cntl_init            = 2                        " Error while initializing TextEdit control!
        error_cntl_link            = 3                        " Error while linking TextEdit control!
        error_dp_create            = 4                        " Error while creating DataProvider control!
        gui_type_not_supported     = 5                        " This type of GUI is not supported!
        OTHERS                     = 6.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

*    definir conteudo inicial para estar vazio
    REFRESH lt_objcont.
    CALL METHOD editor->set_text_as_r3table
      EXPORTING
        table = lt_objcont.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ENDIF.

ENDMODULE.
